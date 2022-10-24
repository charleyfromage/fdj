import Foundation

protocol APIClient: AnyObject {
    func get<T: Decodable>(type: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

final class APIClientImpl: APIClient {
    private let session = URLSession(configuration: .default)

    public func get<T: Decodable>(type: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let dataTask = session.dataTask(with: urlRequest){ data, response, error in
            if let data = data {
                do {
                    let entity = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(entity))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
