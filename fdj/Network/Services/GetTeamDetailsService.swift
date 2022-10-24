import Foundation

protocol GetTeamDetailsService {
    func getTeam(for teamName: String, completion: @escaping (Team?) -> Void)
}

final class GetTeamDetailsServiceImpl: GetTeamDetailsService {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getTeam(for teamName: String, completion: @escaping (Team?) -> Void) {
        guard var urlComponents = URLComponents(string: Constants.API.baseURL + Constants.API.EndPoints.teamDetails) else {
            completion(nil)   // Should be handling error cases
            return
        }

        urlComponents.queryItems = [URLQueryItem(name: "t", value: teamName)]

        guard let url = urlComponents.url else {
            completion(nil)   // Should be handling error cases
            return
        }

        apiClient.get(type: Teams.self, url: url) { response in
            switch response {
                case .success(let teams): completion(teams.list.first)
                case .failure: completion(nil)   // Should be handling error cases
            }
        }
    }
}
