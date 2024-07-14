//
//  Photo.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.07.2024.
//

import Foundation


struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageUrl: String
    let isLiked: Bool
}
