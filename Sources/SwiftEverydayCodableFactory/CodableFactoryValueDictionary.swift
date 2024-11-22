import Foundation

@propertyWrapper
public struct CodableFactoryValueDictionary<KeyType: Hashable&Codable, ObjectType>: Codable {
    public var wrappedValue: [KeyType: ObjectType]

    public init(wrappedValue: [KeyType: ObjectType]) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container
            .decode([KeyType: CodableFactoryValue<ObjectType>].self)
            .mapValues { $0.wrappedValue }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.mapValues { CodableFactoryValue<ObjectType>(wrappedValue: $0) })
    }
}
