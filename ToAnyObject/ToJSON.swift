//
//  ToJSON.swift
//  ToAnyObject
//
//  Created by Yasuhiro Inami on 2015-10-31.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import Foundation

// MARK: toJSONData/String

public func toJSONData(_ value: Any, options: JSONSerialization.WritingOptions = []) -> Data?
{
    guard value is () == false else { return nil }
    guard value is NSNull == false else {
        return "null".data(using: String.Encoding.utf8)
    }
    
    return try? JSONSerialization.data(withJSONObject: toAnyObject(value), options: options)
}

public func toJSONString(_ value: Any, options: JSONSerialization.WritingOptions = []) -> String?
{
    return toJSONData(value, options: options)
        .flatMap { NSString(data: $0, encoding: String.Encoding.utf8.rawValue) as? String }
}
