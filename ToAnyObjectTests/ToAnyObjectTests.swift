//
//  ToAnyObjectTests.swift
//  ToAnyObjectTests
//
//  Created by Yasuhiro Inami on 2015-10-31.
//  Copyright © 2015 Yasuhiro Inami. All rights reserved.
//

import XCTest
import ToAnyObject

class ToAnyObjectTests: XCTestCase
{
    // MARK: toAnyObject
    
    func test_toAnyObject()
    {
        let obj = toAnyObject(TestModel1())
        
        let fileJSONObj = NSBundle(forClass: self.dynamicType).URLForResource("_TestModel1", withExtension: "json")
            .flatMap { NSData(contentsOfURL: $0) }
            .flatMap { try? NSJSONSerialization.JSONObjectWithData($0, options: []) }
        
        guard let fileJSONObj_ = fileJSONObj else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(obj.isEqual(fileJSONObj_))
    }
    
    // MARK: toJSONString
    
    func test_toJSONString()
    {
        let jsonString = toJSONString(TestModel1(), options: .PrettyPrinted)
        
        XCTAssertNotNil(jsonString)
//        print(jsonString!)
    }
    
    func test_toJSONString_NSNull()
    {
        let jsonString = toJSONString(NSNull(), options: .PrettyPrinted)
        
        XCTAssertNotNil(jsonString)
        XCTAssertEqual(jsonString!, "null")
    }
    
    func test_toJSONString_empty()
    {
        let jsonString = toJSONString((), options: .PrettyPrinted)
        XCTAssertNil(jsonString)
    }
    
    // MARK: Custom Mapping
    
    func test_mapping()
    {
        let model = MappingTestModel()
        
        let obj = toAnyObject(model)
        
        guard let obj_ = obj as? [String : AnyObject] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(model.name, "inamiy")
        XCTAssertEqual(model.age, 21)
        XCTAssertEqual(model.isAuthor, true)
        XCTAssertEqual(model.message, "Hello")
        XCTAssertEqual(model.secret, "4649")
        
        XCTAssertEqual((obj_["name"] as! String), "inamiy")
        XCTAssertEqual((obj_["real_age"] as! Int), 0x21)
        XCTAssertEqual((obj_["is_author"] as! Bool), true)
        XCTAssertEqual((obj_["message"] as! String), "Hello World!")
        XCTAssertNil(obj_["secret"])
    }
    
    // MARK: Performance Tests
    
    func test_toAnyObject_performance()
    {
        let test = TestModel1()
        
        self.measureBlock {
            toAnyObject(test)
        }
    }
    
    func test_toJSONString_performance()
    {
        let test = TestModel1()
        
        self.measureBlock {
            toJSONString(test)
        }
    }
}
