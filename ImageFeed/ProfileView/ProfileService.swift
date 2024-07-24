//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 02.07.2024.
//

import UIKit


final class ProfileService {
    
    static let shared = ProfileService()

    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    func clearProfile() {
        profile = nil
    }
    
    func makeProfileRequest() throws -> URLRequest? {
        guard let baseUrl = Constants.defaultBaseUrl else {
            throw ProfileServiceError.invalidBaseUrl
        }
        guard let url = URL(string: "/me", relativeTo: baseUrl) else {
            throw ProfileServiceError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            throw ProfileServiceError.gettingTokenError
        }
        let tokenStringField = "Bearer \(token)"
        
        request.setValue(tokenStringField, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = try? makeProfileRequest() else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let response):
                let profile = Profile(username: response.username, firstName: response.firstName, lastName: response.lastName, bio: response.bio)
                self.profile = profile
                ProfileImageService.shared.fetchProfileImageURL(username: response.username) { _ in }
                completion(.success(profile))
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(ProfileServiceError.fetchProfileError) - Ошибка получения данных профиля, \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
