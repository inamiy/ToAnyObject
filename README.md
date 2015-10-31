# ToAnyObject

Cocoa-friendly AnyObject (and JSON) minimal encoder using Mirror API.


## Example

```swift
struct TestModel: AutoNSDictionaryType
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

// Let's encode...

let model = TestModel()

let obj = toAnyObject(model)
// or
let jsonString = toJSONString(model)
```


## Usage

1. Conform your model type (e.g. struct, class) to `AutoNSDictionaryType`.
2. Implement `static var customMapping: [String : (String, Any -> Any)]` if needed.
3. Conform non-ObjC types (e.g. enum) to `ToAnyObjectType`.
4. Call `let obj = toAnyObject(_testModel)`.
5. That's it!

See [Test Models](https://github.com/inamiy/ToAnyObject/blob/master/ToAnyObjectTests/_TestModels.swift) in XCTests for more details.


## Licence

[MIT](https://github.com/inamiy/ToAnyObject/blob/master/LICENSE)
