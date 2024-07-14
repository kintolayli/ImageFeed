//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.07.2024.
//

import Foundation

enum ImageListServiceError: Error {
    case invalidBaseUrl
    case invalidUrl
    case invalidRequest
    case gettingTokenError
}


final class ImageListService {
    
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
//    private var lastLoadedPage: Int?
    private var lastLoadedPage: Int = 0
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    enum OrderBy: String {
        case latest = "latest"
        case oldest = "oldest"
        case popular = "popular"
    }
    
    func makeImageListRequest(page: Int, perPage: Int = 10, orderBy: OrderBy = .latest) throws -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: Constants.defaultBaseUrlString) else {
            throw ImageListServiceError.invalidBaseUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: page.description),
            URLQueryItem(name: "per_page", value: perPage.description),
            URLQueryItem(name: "orderBy", value: orderBy.rawValue)
        ]
        
        urlComponents.path = "/photos"
        
        guard let url = urlComponents.url else {
            throw ImageListServiceError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2TokenStorage().token else {
            throw ImageListServiceError.gettingTokenError
        }
        let tokenStringField = "Bearer \(token)"
        request.setValue(tokenStringField, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<String, Error>) -> Void) {
        let nextPage = lastLoadedPage + 1
        
        guard let request = try? makeImageListRequest(page: nextPage) else {
            completion(.failure(ImageListServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let response):
                for element in response {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    guard let date = dateFormatter.date(from: element.createdAt) else { return }
                    
                    let photo = Photo(
                        id: element.id,
                        size: CGSize(width: element.width, height: element.height),
                        createdAt: date,
                        welcomeDescription: element.description,
                        thumbImageURL: element.urls.thumb,
                        largeImageUrl: element.urls.full,
                        isLiked: element.likedByUser
                    )
                    
                    DispatchQueue.main.async {
                        self.photos.append(photo)
                    }
                    
                    self.lastLoadedPage += 1
                }
                
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
                
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: \(ProfileImageServiceError.fetchProfileImageError) - Ошибка получения ленты изображений, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
