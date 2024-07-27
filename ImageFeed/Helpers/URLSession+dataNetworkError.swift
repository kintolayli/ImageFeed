//
//  URLSession+dataNetworkError.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 27.07.2024.
//

import Foundation


enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
