//
//  ProfileImageResult.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 11.07.2024.
//

import Foundation


enum ProfileImageServiceError: Error {
    case invalidRequest
    case invalidResponse
    case invalidBaseUrl
    case invalidUrl
    case gettingTokenError
    case fetchProfileImageError
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}


