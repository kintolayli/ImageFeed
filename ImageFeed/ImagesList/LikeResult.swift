//
//  PhotoResult2.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 23.07.2024.
//

import Foundation

// MARK: - Welcome
struct LikeResult: Codable {
    let photo: PhotoResult
    let user: ProfileResult
}
