//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 29.07.2024.
//

import UIKit
import Kingfisher


public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.backgroundColor = .clear
        
        guard let thumbImageURL = view?.photos[indexPath.item].thumbImageURL else { return }
        guard let url = URL(string: thumbImageURL) else { return }
        let imageView = UIImageView()
        let processor = RoundCornerImageProcessor(cornerRadius: 8)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: .none,
                              options: [.processor(processor)]) { result in
            switch result {
            case .success(_):
                
                var textDate = ""
                let createdAt = self.view?.photos[indexPath.item].createdAt
                if let date = createdAt {
                    textDate = self.dateFormatter.string(from: date)
                }
                cell.updateCell(
                    cellDataLabelTitle: textDate,
                    likeButtonTitle: "",
                    imageView: imageView
                )
                self.view?.reloadRows(indexPath: indexPath)
            case .failure(let error):
                let logMessage =
                """
                [\(String(describing: self)).\(#function)]:
                \(ImageListServiceError.fetchImageError) - Ошибка получения изображения ячейки таблицы, \(error.localizedDescription)
                """
                print(logMessage)
            }
        }
        
        guard let isLiked = view?.photos[indexPath.item].isLiked else { return }
        cell.setIsLiked(isLiked: isLiked)
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell)  else { return }
        guard let photo = view?.photos[indexPath.row] else { return }
        
        UIBlockingProgressHUD.show()
        
        view?.imageListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { result in
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                guard let photos = self.view?.imageListService.photos else { return }
                self.view?.photos = photos
                guard let isLiked = self.view?.photos[indexPath.row].isLiked else { return }
                cell.setIsLiked(isLiked: isLiked)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось поставить лайк",
                    buttonTitle: "ОК",
                    buttonAction: nil
                )
                let viewController = self.view as! UIViewController
                let alertPresenter = AlertPresenter(viewController: viewController)
                alertPresenter.show(model: alertModel)
            }
        }
    }
}
