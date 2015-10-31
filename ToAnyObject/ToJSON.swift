//
//  ToJSON.swift
//  ToAnyObject
//
//  Created by Yasuhiro Inami on 2015-10-31.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import Foundation

// MARK: toJSONData/String

public func toJSONData(value: Any, options: NSJSONWritingOptions = []) -> NSData?
{
    guard value is () == false else { return nil }
    guard value is NSNull == false else {
        return "null".dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    return try? NSJSONSerialization.dataWithJSONObject(toAnyObject(value), options: options)
}

public func toJSONString(value: Any, options: NSJSONWritingOptions = []) -> String?
{
    return toJSONData(value, options: options)
        .flatMap { NSString(data: $0, encoding: NSUTF8StringEncoding) as? String }
}