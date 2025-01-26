//
//  Profile.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 11.07.2024.
//

import Foundation


public struct Profile {
    let username: String
    let name: String
    let bio: String?
    var loginName: String {
        return "@\(username)"
    }
    
    init(username: String, firstName: String, lastName: String, bio: String?) {
        self.username = username
        self.name = "\(firstName) \(lastName)"
        self.bio = bio
    }
}
