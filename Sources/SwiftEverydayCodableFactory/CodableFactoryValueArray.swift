import Foundation

@propertyWrapper
public struct CodableFactoryValueArray<ObjectType>: Codable {
    public var wrappedValue: [ObjectType]

    public init(wrappedValue: [ObjectType]) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container
            .decode([CodableFactoryValue<ObjectType>].self)
            .map { $0.wrappedValue }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.map { CodableFactoryValue<ObjectType>(wrappedValue: $0) })
    }
}
