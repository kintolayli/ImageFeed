//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Ilya Lotnik on 29.07.2024.
//


@testable import ImageFeed
import Foundation


final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var configCellCalled: Bool = false
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    
    func configCell(for cell: ImageFeed.ImagesListCell, with indexPath: IndexPath) {
        configCellCalled = true
    }
    
    func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell) {}
}
