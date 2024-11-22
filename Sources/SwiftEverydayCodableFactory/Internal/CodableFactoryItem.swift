protocol ICodableFactoryItem {
    var type: Any.Type { get }
    func load(decoder: any Decoder) throws -> Encodable
    func save(encoder: any Encoder, object: Any) throws
}

struct CodableFactoryItem<T: Codable>: ICodableFactoryItem {
    let type: Any.Type

    init(type: T.Type) {
        self.type = type
    }

    func load(decoder: any Decoder) throws -> Encodable {
        try T(from: decoder)
    }

    func save(encoder: any Encoder, object: Any) throws {
        guard let object = object as? T else {
            throw "Incorrect object type '\(Swift.type(of: object))' is not '\(T.self)'"
        }
        try object.encode(to: encoder)
    }
}
