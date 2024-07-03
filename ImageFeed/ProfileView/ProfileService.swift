//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 02.07.2024.
//

import UIKit

enum ProfileServiceError: Error {
    case invalidRequest
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    var loginName: String {
        return "@\(username)"
    }
    let bio: String?
    
    init(username: String, firstName: String, lastName: String, bio: String?) {
        self.username = username
        self.name = "\(firstName) \(lastName)"
        self.bio = bio
    }
    
    static func makeProfileRequest() -> URLRequest? {
        guard let baseUrl = Constants.defaultBaseUrl else {
            fatalError("Invalid BaseUrl")
        }
        guard let url = URL(string: "/me", relativeTo: baseUrl) else {
            fatalError("InvalidUrl")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            fatalError("Error get token")
        }
        let tokenStringField = "Bearer \(token)"
        
        request.setValue(tokenStringField, forHTTPHeaderField: "Authorization")
        return request
    }
}

final class ProfileService {
    
    static let shared = ProfileService()

    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = Profile.makeProfileRequest() else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(ProfileResult.self, from: data)
                    
                    let profile = Profile(username: response.username, firstName: response.firstName, lastName: response.lastName, bio: response.bio)
                    self?.profile = profile

                    ProfileImageService.shared.fetchProfileImageURL(username: response.username) { _ in }
                    completion(.success(profile))
                } catch {
                    print("Error decoding profile response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error fetching profile: \(error)")
                completion(.failure(error))
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
