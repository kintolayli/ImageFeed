//
//  AlertModelWith2Buttons.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 27.07.2024.
//

import UIKit


struct AlertModelWith2Buttons {
    let title: String
    let message: String
    let buttonTitle1: String
    let buttonAction1: ((UIAlertAction) -> Void)?
    let buttonTitle2: String
    let buttonAction2: ((UIAlertAction) -> Void)?
}
