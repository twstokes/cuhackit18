////: Playground - noun: a place where people can play
//
//import UIKit
//
//// constants vs variables
//var hello = "Hello, hackathon!"
//
//// this fails when "hello" is a constant, works when a var
//hello = hello + " We love Swift."
//
//// type annotated
//let one: Int = 1
//// type inference
//let oneInferred = 1
//
//// emojis are 👌
//let 🎷 = "saxophone"
//
//// comments can be like this
///* or like this */
//
//// let's see how safe type safety is
//// error: MyPlayground.playground:17:5: error: binary operator
//// '+' cannot be applied to operands of type 'Int' and 'String'
//// one + hello
//
//// typealiases are handy
//typealias RGBAPixel = UInt32
//
//// booleans
//let enjoyingSwiftSoFar = true
//
//// tuples are a great way to return more than one value
//// tuples can optionally have element names
//let httpStatus = (statusCode: 200, description: "OK")
//httpStatus.statusCode
//httpStatus.description
//
//// initializing variables without element names
//let (code, status) = httpStatus
//code
//status
//
//// accessing another way
//httpStatus.0
//httpStatus.1
//
//let (statusCodeOnly, _) = httpStatus
//statusCodeOnly
//
//// optionals are one of the most important features of Swift
//// means "I have a value" or "I don't have a value"
//// say goodbyte to null pointer exceptions <--- they protect against this at compile time
//
//// imagine:
//
///*
// int returnVal = someFunc() <--- called some function that either returned a value > 0 or -1 if failure
// */
//
//func getFirstName() -> String? { // <--- says we return a String optional
//    var firstName: String? // <--- inits to nil, says we have a String optional
//
//    firstName = "tanner"
//
//    return firstName
//}
//
//// may or may not return a value
//let firstName = getFirstName()
//
//if firstName != nil {
//    // here we know it's safe to use firstName!, but optional binding is preferred
//    firstName!
//}
//
//// optional binding
//if let returnVal = firstName { // <---- try to unwrap optional
//    // got what I needed, and it's exactly what I want, I don't have to unwrap
//    returnVal
//} else {
//    print("Couldn't unwrap optional!")
//    // there was no value - act accordingly
//}
//
//// stay away from !
//// it's OK to use force-unwrapped optionals ONLY when you're confident they won't fail, otherwise
//// you get a runtime exception!
////firstName()! // uncomment this when returning nil
//
//struct Person {
//    let firstName: String
//
//    //    func sayHello() {
//    //        print("Helo, \(firstName)")
//    //    }
//    func helloString() -> String {
//        return "Hello, \(firstName)"
//    }
//}
//
//var person: Person?
//
////person = Person(firstName: "tanner")
//
//// this is OK either way! it uses optional chaining
//// "call helloString() in the chain if person exists"
//person?.helloString()
//
//// collection types: Array, Set, Dictionary
//var names = ["bob", "jan", "phil"] // <--- this is a type inferred array of strings
//var nameSet: Set = ["bob", "jan", "phil"] // <--- sets need a type annotation, or set
//var nameDict = ["bob": 40, "jan": 28, "phil": 19] // <---- dictionary of [String: Int]
//
//// all three are mutable
//// arrays: indexed list of values
//// dictionaries: key / value store
//// sets: unique values
//
//names.append("sue")
//nameSet.insert("bob") // <-- wasn't inserted because not unique
//nameDict["sue"] = 42
//
//nameDict["jan"] // <--- dict lookup
//
//// loop through the names
//for name in names {
//    print(name)
//}
//
//// index based loop
//for index in 0..<2 {
//    print(names[index])
//}
//
////// while loop
////var x = 0
////while x < 5 {
////    x += 1
////
////    if x == 2 {
////        print("x is two!")
////    }
////}
//
//if names.contains("sue") {
//    print("Sue was found!")
//} else {
//    print("No Sue in this list.")
//}
//
//
//
//// change me
//let x = 10
//
//// switches don't have to inclue a break - they don't naturally fall through
//switch x {
//case 5...9: // interval matching
//    print("x was greater > four and less than 10")
//case 10:
//    print("x was ten!")
//default:
//    print("Default case.")
//}
//
//// value bindings are awesome, check out the other powerful uses
//let anotherPoint = (2, 0)
//switch anotherPoint {
//case (let x, 0):
//    print("on the x-axis with an x value of \(x)")
//case (0, let y):
//    print("on the y-axis with a y value of \(y)")
//case let (x, y):
//    print("somewhere else at (\(x), \(y))")
//}
//
//// functions
//// first class citizens - can be assigned to variables and passed around
//func noParams() { // <--- also no return val
//    // in general, functions like these should cause a code smell
//    // they're causing some sort of side effects
//    print("No params, no return values.")
//}
//
//// argument labels, multiple params, return val
//func getAge(for name: String, using dict: [String: Int]) -> Int? {
//    // great usage of optional - we may or may not get what we want
//    let age = nameDict[name]
//
//    return age
//}
//
//noParams()
//
//if let age = getAge(for: "bob", using: nameDict) {
//    print("Bob's age is: \(age)")
//}
//
//// optional param name, it would be a bit redundant to include it
//func double(_ number: Int) -> Int {
//    return number*2
//}
//
//double(5)
//
//// default param value, variadic params
//
//// there's so much more
//// functions can return functions
//
//func makeIncrementer(forIncrement amount: Int) -> () -> Int {
//    var runningTotal = 0
//    func incrementer() -> Int {
//        runningTotal += amount
//        return runningTotal
//    }
//    return incrementer
//}
//
//let incrementByTen = makeIncrementer(forIncrement: 10)
//incrementByTen()
//// returns a value of 10
//incrementByTen()
//// returns a value of 20
//incrementByTen()
//// returns a value of 30
//
//
//// enums
//// classes / structs
//// computed properties
//// error handling
//// protocols
//

