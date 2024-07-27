//
//  ProfileImageResult.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 11.07.2024.
//

import Foundation


struct ProfileImageResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}


