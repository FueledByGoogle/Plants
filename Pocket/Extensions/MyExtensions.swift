import UIKit



// The pro approach would be to use an extension:
//extension Dictionary {
//
//    public init(keys: [Key], values: [Value]) {
//        precondition(keys.count == values.count)
//
//        self.init()
//
//        for (index, key) in keys.enumerate() {
//            self[key] = values[index]
//        }
//    }
//}
