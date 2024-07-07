//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.06.2024.
//

import UIKit

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    let tokenStorage = OAuth2TokenStorage()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init () {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            fatalError("Invalid base URL")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }

    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
//        let task = urlSession.data(for: request) { [weak self] result in
//            switch result {
//            case .success(let data):
//                do {
//                    let decoder = JSONDecoder()
//                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                    self?.tokenStorage.token = response.accessToken
//                    
//                    completion(.success(response.accessToken))
//                } catch {
//                    print("Error decoding OAuth token response: \(error)")
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                print("Error fetching OAuth token: \(error)")
//                completion(.failure(error))
//            }
//            
//            self?.task = nil
//            self?.lastCode = nil
//        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                self?.tokenStorage.token = response.accessToken
                completion(.success(response.accessToken))
            case .failure(let error):
                print("Ошибка получения OAuth токена: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
}
