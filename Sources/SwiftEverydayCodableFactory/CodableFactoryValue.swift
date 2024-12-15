import Foundation

@propertyWrapper
public struct CodableFactoryValue<ObjectType>: Codable {
    public var wrappedValue: ObjectType

    public init(wrappedValue: ObjectType) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: any Decoder) throws {
        let factory = (decoder.userInfo[CodableFactory.сodingUserInfoKey] as? CodableFactory) ?? .global
        let object = try factory.load(decoder: decoder)
        guard let value = object as? ObjectType else {
            throw "'\(type(of: object))' is not '\(ObjectType.self)'"
        }
        self.wrappedValue = value
    }

    public func encode(to encoder: any Encoder) throws {
        let factory = (encoder.userInfo[CodableFactory.сodingUserInfoKey] as? CodableFactory) ?? .global
        try factory.save(encoder: encoder, object: wrappedValue)
    }
}
