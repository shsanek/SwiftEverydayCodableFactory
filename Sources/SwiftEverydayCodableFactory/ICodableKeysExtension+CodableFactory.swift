import SwiftEverydayUtils

extension ICodableKeysExtension {
    @discardableResult
    public mutating func addCodableFactory(_ factory: CodableFactory = .global) -> Self {
        self.userInfo[CodableFactory.сodingUserInfoKey] = factory
        return self
    }
}
