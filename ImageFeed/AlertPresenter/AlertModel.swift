//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 27.07.2024.
//

import UIKit


struct AlertModel {
    let title: String
    let message: String
    let buttonTitle: String
    let buttonAction: ((UIAlertAction) -> Void)?
}
