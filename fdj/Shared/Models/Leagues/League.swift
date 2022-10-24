struct League {
    var id: String
    var name: String?
}

extension League: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idLeague"
        case name = "strLeague"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}
