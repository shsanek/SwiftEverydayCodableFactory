import XCTest
@testable import SwiftEverydayCodableFactory

class CodableFactoryTests: XCTestCase {

    protocol A { }

    struct A1: A, Codable {
        let value: String
    }

    struct A2: A, Codable {
        let number: Int
    }

    struct MyObject: Codable {
        @CodableFactoryValue
        var a: A
    }

    override func setUp() {
        super.setUp()
        // Register types with the factory
        let factory = CodableFactory.global
        try? A1.addToCodableFactory(factory)
        try? A2.addToCodableFactory(factory)
    }

    func testEncodingAndDecodingA1() throws {
        let factory = CodableFactory.global
        let originalObject = MyObject(a: A1(value: "Test String"))

        let encoder = JSONEncoder()
        encoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let data = try encoder.encode(originalObject)

        let decoder = JSONDecoder()
        decoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let decodedObject = try decoder.decode(MyObject.self, from: data)

        if let decodedA1 = decodedObject.a as? A1,
           let originalA1 = originalObject.a as? A1 {
            XCTAssertEqual(decodedA1.value, originalA1.value)
        } else {
            XCTFail("Decoded object is not of type A1 or original object is not A1")
        }
    }

    func testEncodingAndDecodingA2() throws {
        let factory = CodableFactory.global
        let originalObject = MyObject(a: A2(number: 42))

        let encoder = JSONEncoder()
        encoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let data = try encoder.encode(originalObject)

        let decoder = JSONDecoder()
        decoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let decodedObject = try decoder.decode(MyObject.self, from: data)

        if let decodedA2 = decodedObject.a as? A2,
           let originalA2 = originalObject.a as? A2 {
            XCTAssertEqual(decodedA2.number, originalA2.number)
        } else {
            XCTFail("Decoded object is not of type A2 or original object is not A2")
        }
    }

    func testEncodingAndDecodingArray() throws {
        struct MyArrayObject: Codable {
            @CodableFactoryValueArray
            var array: [A]
        }

        let factory = CodableFactory.global
        let originalObject = MyArrayObject(array: [A1(value: "First"), A2(number: 100)])

        let encoder = JSONEncoder()
        encoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let data = try encoder.encode(originalObject)

        let decoder = JSONDecoder()
        decoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let decodedObject = try decoder.decode(MyArrayObject.self, from: data)

        XCTAssertEqual(decodedObject.array.count, originalObject.array.count)

        if let decodedA1 = decodedObject.array[0] as? A1,
           let originalA1 = originalObject.array[0] as? A1 {
            XCTAssertEqual(decodedA1.value, originalA1.value)
        } else {
            XCTFail("First element is not A1 or does not match")
        }

        if let decodedA2 = decodedObject.array[1] as? A2,
           let originalA2 = originalObject.array[1] as? A2 {
            XCTAssertEqual(decodedA2.number, originalA2.number)
        } else {
            XCTFail("Second element is not A2 or does not match")
        }
    }

    func testEncodingAndDecodingDictionary() throws {
        struct MyDictionaryObject: Codable {
            @CodableFactoryValueDictionary
            var dictionary: [String: A]
        }

        let factory = CodableFactory.global
        let originalObject = MyDictionaryObject(
            dictionary: ["one": A1(value: "Value"), "two": A2(number: 200)]
        )

        let encoder = JSONEncoder()
        encoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let data = try encoder.encode(originalObject)

        let decoder = JSONDecoder()
        decoder.userInfo[CodableFactory.сodingUserInfoKey] = factory
        let decodedObject = try decoder.decode(MyDictionaryObject.self, from: data)

        XCTAssertEqual(decodedObject.dictionary.count, originalObject.dictionary.count)

        if let decodedA1 = decodedObject.dictionary["one"] as? A1,
           let originalA1 = originalObject.dictionary["one"] as? A1 {
            XCTAssertEqual(decodedA1.value, originalA1.value)
        } else {
            XCTFail("'one' is not A1 or does not match")
        }

        if let decodedA2 = decodedObject.dictionary["two"] as? A2,
           let originalA2 = originalObject.dictionary["two"] as? A2 {
            XCTAssertEqual(decodedA2.number, originalA2.number)
        } else {
            XCTFail("'two' is not A2 or does not match")
        }
    }

    func testRegisteringSameTypeIdentifier() {
        let factory = CodableFactory.global
        XCTAssertThrowsError(try factory.register(typeIdentifier: "A1", A1.self)) { error in
            XCTAssertEqual(error as? String, "CodableFactory already have item with identifier: 'A1' ")
        }
    }

    func testRegisteringSameType() {
        let factory = CodableFactory.global
        XCTAssertThrowsError(try factory.register(typeIdentifier: "UniqueIdentifier", A1.self)) { error in
            XCTAssertEqual(error as? String, "CodableFactory already have item with type: 'A1' ")
        }
    }

    func testDecodingWithoutFactory() {
        struct MyObjectWithoutFactory: Codable {
            @CodableFactoryValue
            var a: A
        }

        let originalObject = MyObjectWithoutFactory(a: A1(value: "No Factory"))

        let encoder = JSONEncoder()
        encoder.userInfo[CodableFactory.сodingUserInfoKey] = CodableFactory.global
        let data = try? encoder.encode(originalObject)

        let decoder = JSONDecoder()
        // Not setting the factory in decoder.userInfo
        XCTAssertThrowsError(try decoder.decode(MyObjectWithoutFactory.self, from: data!)) { error in
            XCTAssertTrue(error is String)
        }
    }
}

