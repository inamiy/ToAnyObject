//
//  ToAnyObject.swift
//  ToAnyObject
//
//  Created by Yasuhiro Inami on 2015-10-31.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import Foundation

//
// Usage:
// 1. Conform your model type (e.g. struct, class) to `AutoNSDictionaryType`.
// 2. Implement `var customMapping: [String : (String, Any -> Any)]` if needed.
// 3. Conform non-ObjC types (e.g. enum) to `ToAnyObjectType`.
// 4. Call `let obj = toAnyObject(_testModel)`.
// 5. That's it!
//

// MARK: ToAnyObjectType

///
/// Conform non-ObjC-type (e.g. enum) to this protocol for better `toAnyObject()`.
///
/// - Note:
/// Actually, any AnyObject-like types should conform to this protocol, 
/// but we can use `as`-casting and `Mirror` instead to omit most of verbose implementations.
///
public protocol ToAnyObjectType
{
    func toAnyObject() -> AnyObject
}

// MARK: AutoNSDictionaryType

/// Model-to-NSDictionary auto-mapper
/// i.e. `[ModelPropertyName : (AutoNSDictionaryKey : AutoNSDictionaryValue)?]`
/// - Note: `AutoNSDictionaryValue` can be `Any` type which will be converted to `AnyObject` via `toAnyObject()`.
public typealias Mapping = [String : (String, Any)?]

///
/// Conform custom model type (e.g. struct, class) to this protocol for better `toAnyObject()` (creates NSDictionary).
///
public protocol AutoNSDictionaryType: ToAnyObjectType
{
    /// Additional mapping for manually converting model's property name
    /// to NSDictionary key name using transforming closure.
    var customMapping: Mapping { get }
}

extension AutoNSDictionaryType
{
    public var customMapping: Mapping
    {
        return [:]
    }
    
    public func toAnyObject() -> AnyObject
    {
        return _toDictionary(Mirror(reflecting: self), mapping: self.customMapping) as AnyObject
    }
}

// MARK: toAnyObject

/// Convert Any -> AnyObject using Mirror API.
public func toAnyObject(_ any: Any) -> AnyObject
{
    // use user-implemented `toAnyObject()` if possible
    if let any = any as? ToAnyObjectType {
        return any.toAnyObject()
    }
    
    let mirror = Mirror(reflecting: any)
    
    switch mirror.displayStyle {
        
        case .some(.optional):
            
            return mirror.children.first.map { toAnyObject($0.1) } ?? NSNull()
        
        case .some(.collection):   // e.g. Array, NSArray
            
            return mirror.children.map { toAnyObject($1) } as AnyObject
        
        case .some(.dictionary):   // e.g. Dictionary, NSDictionary
            
            var dict: [String : AnyObject] = [:]
            for (_, keyValue) in mirror.children {
                if let (key, value) = keyValue as? (String, Any) {
                    dict[key] = toAnyObject(value)
                }
                // NOTE: ObjC-type-tuple casting i.e. `keyValue as? (String, AnyObject)` doesn't work
                else {
                    let keyValueArray = Mirror(reflecting: keyValue).children
                        .prefix(2)  // NOTE: children should have [(_, key), (_, value)]
                        .map { $1 }
                    if let key = keyValueArray[0] as? String {
                        let value = keyValueArray[1]
                        dict[key] = toAnyObject(value)
                    }
                }
            }
            return dict as AnyObject
        
        default:
            if any is Void { return NSNull() }
            return any as AnyObject
    }
}

// MARK: Private

private func _toDictionary(_ mirror: Mirror, mapping: Mapping) -> [String : AnyObject]
{
    let superDict = mirror.superclassMirror.map { _toDictionary($0, mapping: mapping) } ?? [:]
    
    var dict: [String : AnyObject] = [:]
    for (key, value) in mirror.children {
        if let key = key {
            if let tuple = mapping[key] {
                if let (newKey, newValue) = tuple {
                    dict[newKey] = toAnyObject(newValue)
                }
            }
            else {
                // if mapping doesn't exist, convert original value to `AnyObject`
                dict[key] = toAnyObject(value)
            }
        }
    }
    
    for (key, value) in superDict {
        dict[key] = value
    }
    
    return dict
}
