struct Teams {
    var list: [Team]
}

extension Teams: Decodable {
    enum CodingKeys: String, CodingKey {
        case list = "teams"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.list = try container.decode([Team].self, forKey: .list)
    }
}
