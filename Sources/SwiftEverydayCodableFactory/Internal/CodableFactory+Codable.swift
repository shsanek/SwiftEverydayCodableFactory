extension CodableFactory {
    func load(decoder: any Decoder) throws -> Encodable {
        let container = try decoder.container(keyedBy: Keys.self)
        let type = try container.decode(String.self, forKey: .type)
        let item = try items[type].noOptional()
        let decoder = try container.superDecoder(forKey: .data)
        return try item.load(decoder: decoder)
    }

    func save(encoder: any Encoder, object: Any) throws {
        let item = try items.first(where: { type(of: object) == $0.value.type }).noOptional()
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(item.key, forKey: .type)
        let encoder = container.superEncoder(forKey: .data)
        try item.value.save(encoder: encoder, object: object)
    }
}


extension CodableFactory {
    enum Keys: CodingKey {
        case type
        case data
    }
}
