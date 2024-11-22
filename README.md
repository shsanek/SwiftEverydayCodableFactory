# CodableFactory

The CodableFactory is a utility designed to facilitate the encoding and decoding of heterogeneous collections of objects that conform to a common protocol but are of different concrete types. It leverages Swift's Codable protocol and custom property wrappers to serialize and deserialize objects while preserving their concrete types.

## Overview
When working with protocols and abstract types in Swift, encoding and decoding can be challenging because the Codable protocol requires concrete types. The CodableFactory addresses this limitation by:

 - Registering concrete types with unique identifiers.
 - Using custom property wrappers to encode and decode objects based on their type identifiers.
 - Allowing collections (arrays and dictionaries) of protocol types to be encoded and decoded seamlessly.
 
## Key Components
### `CodableFactory`
A class responsible for managing the mapping between type identifiers and their corresponding types.

Methods:

`register<T: Codable>(typeIdentifier: String, _ type: T.Type)`: Registers a type with the factory.

### `Property Wrappers`

#### `@CodableFactoryValue<ObjectType>`
A property wrapper for encoding and decoding a single object of a protocol type.

Usage:

```swift
@CodableFactoryValue
var myObject: MyProtocol
```

#### @CodableFactoryValueArray<ObjectType>
A property wrapper for encoding and decoding an array of protocol type objects.

Usage:

```swift
@CodableFactoryValueArray
var myObjects: [MyProtocol]
```
#### @CodableFactoryValueDictionary<KeyType, ObjectType>
A property wrapper for encoding and decoding a dictionary with protocol type values.

Usage:

```swift
@CodableFactoryValueDictionary
var myDictionary: [String: MyProtocol]
```

### Extension for Registering Types
Adds a method to register a type with the CodableFactory.

```swift
static func addToCodableFactory(
    _ factory: CodableFactory = CodableFactory.global,
    typeIdentifier: String = "\(Self.self)"
)
```

## Usage Example
Suppose you have a protocol `A` and two structs `A1` and `A2` conforming to `A` and `Codable`.

```swift
protocol A { }

struct A1: A, Codable {
    let value: String
}

struct A2: A, Codable {
    let number: Int
}
```
You can create a struct that uses the `CodableFactory` to encode and decode instances of A.

```swift
struct MyObject: Codable {
    @CodableFactoryValue
    var a: A
}
```
Registering Types
Before encoding or decoding, you must register the concrete types with the factory.

```swift
let factory = CodableFactory.global
try A1.addToCodableFactory(factory)
try A2.addToCodableFactory(factory)
```

Encoding and Decoding
### To encode:
```swift
let myObject = MyObject(a: A1(value: "Hello"))
let encoder = JSONEncoder().addToCodableFactory(factory)
let data = try encoder.encode(myObject)
```

### To decode:
```swift
let decoder = JSONDecoder().addToCodableFactory(factory)
let decodedObject = try decoder.decode(MyObject.self, from: data)
```
