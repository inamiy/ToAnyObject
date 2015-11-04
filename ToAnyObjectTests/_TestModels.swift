//
//  _TestModels.swift
//  ToAnyObject
//
//  Created by Yasuhiro Inami on 2015-10-31.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import Foundation
import ToAnyObject

struct TestModel1: AutoNSDictionaryType
{
    let void: () = ()
    let voidOpt: ()? = ()
    let bool: Bool = true
    let boolOpt: Bool? = true
    let int: Int = 1
    let intOpt: Int? = 1
    let double: Double = 0.1
    let doubleOpt: Double? = 0.1
    let str: String = "Swift.String"
    let strOpt: String? = "Swift.String"
    
    let arr: [Any] = [1, "one"]
    let arrOpt: [Any]? = [1, "one", TestModel2()]
    let dict: [String : Any] = ["key1" : "one", "key2" : 222]
    let dictOpt: [String : Any]? = ["key1" : "one", "key2" : 222, "key3" : TestModel2()]
    
    let nsNum: NSNumber = 999
    let nsNumOpt: NSNumber? = 999
    
    let nsStr: NSString = "NSString"
    let nsStrOpt: NSString? = "NSString"
    
    let nsArr: NSArray = [1, "NS-one"]
    let nsArrOpt: NSArray? = [1, "NS-one"]
    
    let nsDict: NSDictionary = ["NS-key1" : "NS-one", "NS-key2" : 222]
    let nsDictOpt: NSDictionary? = ["NS-key1" : "NS-one", "NS-key2" : 222]
    
    let testEnum: TestEnum = .Case1
    let testEnumOpt: TestEnum? = .Case1
    
    let testModel2: TestModel2 = TestModel2()
    let testModel2Opt: TestModel2? = TestModel2()
    
    let testModel2s: [TestModel2] = [TestModel2(), TestModel2()]
    let testModel2sOpt: [TestModel2]? = [TestModel2(), TestModel2()]
    
    let testModel2Dict: [String: TestModel2] = [ "test2-1" : TestModel2(), "test2-2" : TestModel2()]
    let testModel2DictOpt: [String: TestModel2]? = [ "test2-1" : TestModel2(), "test2-2" : TestModel2()]
}

struct TestModel2: AutoNSDictionaryType
{
    let void: () = ()
    let voidOpt: ()? = ()
    let bool: Bool = true
    let boolOpt: Bool? = true
    let int: Int = 1
    let intOpt: Int? = 1
    let double: Double = 0.1
    let doubleOpt: Double? = 0.1
    let str: String = "Swift.String"
    let strOpt: String? = "Swift.String"
    
    let arr: [Any] = [1, "one"]
    let arrOpt: [Any]? = [1, "one"]
    let dict: [String : Any] = ["key1" : "one", "key2" : 222]
    let dictOpt: [String : Any]? = ["key1" : "one", "key2" : 222]
    
    let nsNum: NSNumber = 999
    let nsNumOpt: NSNumber? = 999
    
    let nsStr: NSString = "NSString"
    let nsStrOpt: NSString? = "NSString"
    
    let nsArr: NSArray = [1, "NS-one"]
    let nsArrOpt: NSArray? = [1, "NS-one"]
    
    let nsDict: NSDictionary = ["NS-key1" : "NS-one", "NS-key2" : 222]
    let nsDictOpt: NSDictionary? = ["NS-key1" : "NS-one", "NS-key2" : 222]
    
    let testEnum: TestEnum = .Case1
    let testEnumOpt: TestEnum? = .Case1
}

enum TestEnum: ToAnyObjectType
{
    case Case1
    
    func toAnyObject() -> AnyObject
    {
        switch self {
            case .Case1: return "Case1"
        }
    }
}

struct MappingTestModel: AutoNSDictionaryType
{
    let name: String = "inamiy"
    let age: Int = 21
    let isAuthor: Bool = true
    let secret: String = "4649"
    
    static var customMapping: Mapping
    {
        return [
            "age" : ("real_age", { _ in 0x21 }),
            "isAuthor" : ("is_author", { $0 }), // NOTE: use `{ $0 }` for identity transform
            "secret" : nil
        ]
    }
}
