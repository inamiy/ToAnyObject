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
// 2. Implement `static var customMapping: [String : (String, Any -> Any)]` if needed.
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

public typealias ModelPropertyName = String
public typealias NSDictionaryKeyName = String
public typealias ModelToDictValueTransform = Any -> Any
public typealias Mapping = [ModelPropertyName : (NSDictionaryKeyName, ModelToDictValueTransform)?]

///
/// Conform custom model type (e.g. struct, class) to this protocol for better `toAnyObject()`.
///
public protocol AutoNSDictionaryType: ToAnyObjectType
{
    /// Additional mapping for manually converting model's property name
    /// to NSDictionary key name using transforming closure.
    static var customMapping: Mapping { get }
}

extension AutoNSDictionaryType
{
    public static var customMapping: Mapping
    {
        return [:]
    }
    
    public func toAnyObject() -> AnyObject
    {
        return _toNSDictionary(Mirror(reflecting: self), mapping: self.dynamicType.customMapping)
    }
}

// MARK: toAnyObject

/// Convert Any -> AnyObject using Mirror API.
public func toAnyObject(var any: Any) -> AnyObject
{
    var mirror = Mirror(reflecting: any)
    
    // unwrap Optional if needed
    while mirror.displayStyle == .Optional {
        if mirror.children.count == 0 { return NSNull() }
        (_, any) = mirror.children.first!
        
        mirror = Mirror(reflecting: any)
    }
    
    // use user-implemented `toAnyObject()` if possible
    if let any = any as? ToAnyObjectType {
        return any.toAnyObject()
    }
    
    switch mirror.displayStyle {
        
        case .Some(.Collection):   // e.g. Array, NSArray
            
            return mirror.children.map { toAnyObject($1) }
        
        case .Some(.Dictionary):   // e.g. Dictionary, NSDictionary
            
            var dict: [String : AnyObject] = [:]
            for (_, keyValue) in mirror.children {
                if let (key, value) = keyValue as? (String, Any) {
                    dict[key] = toAnyObject(value) ?? NSNull()
                }
                // NOTE: ObjC-type-tuple casting i.e. `keyValue as? (String, AnyObject)` doesn't work
                else {
                    let mirror = Mirror(reflecting: keyValue)
                    let index0 = mirror.children.startIndex
                    let (_, key) = mirror.children[index0]
                    let (_, value) = mirror.children[index0.successor()]
                    if let key = key as? String {
                        dict[key] = toAnyObject(value) ?? NSNull()
                    }
                }
            }
            return dict
        
        default:
            return any as? AnyObject ?? NSNull()
    }
}

// MARK: Private

private func _toNSDictionary(mirror: Mirror, mapping: Mapping) -> NSDictionary
{
    var dict: [String : AnyObject] = [:]
    for (key, value) in mirror.children {
        if let key = key {
            if let tuple = mapping[key] {
                if let (newKey, transform) = tuple {
                    dict[newKey] = toAnyObject(transform(value))
                }
            }
            else {
                dict[key] = toAnyObject(value)
            }
        }
    }
    return dict
}
