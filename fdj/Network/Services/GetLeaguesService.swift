import Foundation

protocol GetLeaguesService {
    func getLeagues(completion: @escaping ([League]) -> Void)
}

final class GetLeaguesServiceImpl: GetLeaguesService {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getLeagues(completion: @escaping ([League]) -> Void) {
        guard let url = URL(string: Constants.API.baseURL + Constants.API.EndPoints.leagues) else {
            completion([])   // Should be handling error cases
            return
        }

        apiClient.get(type: Leagues.self, url: url) { response in
            switch response {
                case .success(let leagues): completion(leagues.list)
                case .failure: completion([])   // Should be handling error cases
            }
        }
    }
}
