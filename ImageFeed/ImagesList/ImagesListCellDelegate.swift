//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 24.07.2024.
//

import UIKit


protocol ImagesListCellDelegate: ImagesListViewController {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
