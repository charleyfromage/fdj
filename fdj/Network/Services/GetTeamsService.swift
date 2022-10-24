import Foundation

protocol GetTeamsService {
    func getTeams(for league: String, completion: @escaping ([Team]) -> Void)
}

final class GetTeamsServiceImpl: GetTeamsService {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getTeams(for league: String, completion: @escaping ([Team]) -> Void) {
        guard var urlComponents = URLComponents(string: Constants.API.baseURL + Constants.API.EndPoints.teams) else {
            completion([])   // Should be handling error cases
            return
        }

        urlComponents.queryItems = [URLQueryItem(name: "l", value: league)]

        guard let url = urlComponents.url else {
            completion([])   // Should be handling error cases
            return
        }

        apiClient.get(type: Teams.self, url: url) { response in
            switch response {
                case .success(let teams): completion(teams.list)
                case .failure: completion([])   // Should be handling error cases
            }
        }
    }
}
