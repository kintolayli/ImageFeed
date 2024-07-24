//
//  PhotoResult2.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 23.07.2024.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct LikeResult: Codable {
    let photo: PhotoResult
    let user: ProfileResult
}
