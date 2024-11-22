import Foundation

extension Decodable where Self: Encodable {
    public static func addToCodableFactory(
        _ factory: CodableFactory = CodableFactory.global,
        typeIdentifier: String = "\(Self.self)"
    ) throws {
        try factory.register(typeIdentifier: typeIdentifier, Self.self)
    }
}
