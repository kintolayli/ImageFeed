//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 11.07.2024.
//

import Foundation


enum ProfileServiceError: Error {
    case invalidRequest
    case invalidResponse
    case invalidBaseUrl
    case invalidUrl
    case gettingTokenError
    case fetchProfileError
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
