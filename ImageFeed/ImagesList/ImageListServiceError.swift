//
//  ImageListServiceError.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 27.07.2024.
//

import Foundation


enum ImageListServiceError: Error {
    case invalidBaseUrl
    case invalidUrl
    case invalidRequest
    case gettingTokenError
    case fetchImageError
    case sendLikeError
}
