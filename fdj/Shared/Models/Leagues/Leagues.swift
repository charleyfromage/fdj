struct Leagues {
    var list: [League]
}

extension Leagues: Decodable {
    enum CodingKeys: String, CodingKey {
        case list = "leagues"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.list = try container.decode([League].self, forKey: .list)
    }
}
