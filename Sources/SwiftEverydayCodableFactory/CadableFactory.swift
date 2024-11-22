import Foundation
import SwiftEverydayUtils

public final class CodableFactory {
    private(set) var items: [String: ICodableFactoryItem] = [:]

    public init() { }

    public func register<T: Codable>(typeIdentifier: String = "\(T.self)", _ type: T.Type) throws {
        guard items[typeIdentifier] == nil else {
            throw "CodableFactory already have item with identifier: '\(typeIdentifier)' "
        }
        guard !items.values.contains(where: { $0.type == type }) else {
            throw "CodableFactory already have item with type: '\(T.self)' "
        }
        items[typeIdentifier] = CodableFactoryItem(type: T.self)
    }
}

extension CodableFactory {
    public static let global = CodableFactory()
    public static let сodingUserInfoKey: CodingUserInfoKey = {
        guard let key = CodingUserInfoKey(rawValue: "CodingUserInfoKey.CodableFactory") else {
            fatalError("Failed to create key")
        }
        return key
    }()
}
