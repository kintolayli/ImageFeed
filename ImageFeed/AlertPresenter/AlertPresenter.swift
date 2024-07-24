//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 11.07.2024.
//

import UIKit


struct AlertModel {
    let title: String
    let message: String
    let buttonTitle: String
    let buttonAction: ((UIAlertAction) -> Void)?
}

struct AlertModelWith2Buttons {
    let title: String
    let message: String
    let buttonTitle1: String
    let buttonAction1: ((UIAlertAction) -> Void)?
    let buttonTitle2: String
    let buttonAction2: ((UIAlertAction) -> Void)?
}

class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(model: AlertModel) {
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonTitle, style: .default, handler: model.buttonAction)
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showWith2Buttons(model: AlertModelWith2Buttons) {
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: model.buttonTitle1, style: .default, handler: model.buttonAction1)
        let action2 = UIAlertAction(title: model.buttonTitle2, style: .default, handler: model.buttonAction2)
        alertController.addAction(action1)
        alertController.addAction(action2)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
