import Foundation

struct Team {
    var id: String
    var name: String?
    var country: String?
    var league: String?
    var badgeImageURL: URL?
    var bannerImageURL: URL?
    var description: String?
}

extension Team: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idTeam"
        case name = "strTeam"
        case country = "strCountry"
        case league = "strLeague"
        case badgeImageURL = "strTeamBadge"
        case bannerImageURL = "strTeamBanner"
        case description = "strDescriptionEN"   /// Localization should not be handled here. The API should allow some 'language' header parameter instead of returning different keys for different languages.
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.league = try container.decodeIfPresent(String.self, forKey: .league)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .badgeImageURL) {
            self.badgeImageURL = URL(string: urlString)
        }

        if let urlString = try container.decodeIfPresent(String.self, forKey: .bannerImageURL) {
            self.bannerImageURL = URL(string: urlString)
        }
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}
