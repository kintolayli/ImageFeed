//
//  AuthServiceError.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 27.07.2024.
//

import Foundation


enum AuthServiceError: Error {
    case invalidRequest
    case invalidResponse
    case invalidBaseUrl
    case invalidUrl
    case invalidCode
}
