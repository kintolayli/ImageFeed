////
////  PhotoResult2.swift
////  ImageFeed
////
////  Created by Ilya Lotnik on 12.07.2024.
////
//
//import Foundation
//
//
//// MARK: - UrlsResultElement
//struct _PhotoResult: Codable {
//    let id, slug: String
//    let createdAt, updatedAt, promotedAt: Date
//    let width, height: Int
//    let color, blurHash: String
//    let description: String?
//    let altDescription: String
//    let urls: _UrlsResult
//    let links: UrlsResultLinks
//    let likes: Int
//    let likedByUser: Bool
//    let user: ProfileResult
//
//    enum CodingKeys: String, CodingKey {
//        case id, slug
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case promotedAt = "promoted_at"
//        case width, height, color
//        case blurHash = "blur_hash"
//        case description
//        case altDescription = "alt_description"
//        case urls, links, likes
//        case likedByUser = "liked_by_user"
//        case user
//    }
//}
//
//enum AssetType: String, Codable {
//    case photo = "photo"
//}
//
//// MARK: - UrlsResultLinks
//struct UrlsResultLinks: Codable {
//    let linksSelf, html, download, downloadLocation: String
//
//    enum CodingKeys: String, CodingKey {
//        case linksSelf = "self"
//        case html, download
//        case downloadLocation = "download_location"
//    }
//}
//
//
//// MARK: - Urls
//struct _UrlsResult: Codable {
//    let raw, full, regular, small: String
//    let thumb, smallS3: String
//
//    enum CodingKeys: String, CodingKey {
//        case raw, full, regular, small, thumb
//        case smallS3 = "small_s3"
//    }
//}
