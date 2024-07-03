//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 03.07.2024.
//

import UIKit

enum ProfileImageServiceError: Error {
    case invalidRequest
}

// MARK: - UserResult
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small: String
}

func makeProfileImageRequest(username: String) -> URLRequest? {
    guard let baseUrl = Constants.defaultBaseUrl else {
        fatalError("Invalid BaseUrl")
    }
    guard let url = URL(string: "/users/\(username)", relativeTo: baseUrl) else {
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

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    private(set) var profileImageURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(UserResult.self, from: data)
                    
                    let profileImageURL = response.profileImage.small
                    self?.profileImageURL = profileImageURL
                    
                    completion(.success(self?.profileImageURL ?? ""))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL": profileImageURL])
                } catch {
                    print("Error decoding profileImageURL response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error fetching profileImageURL: \(error)")
                completion(.failure(error))
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
}

