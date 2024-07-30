//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 11.07.2024.
//

import UIKit


final class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(model: AlertModel) {
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = "Alert"
        let action = UIAlertAction(title: model.buttonTitle, style: .default, handler: model.buttonAction)
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showWith2Buttons(model: AlertModelWith2Buttons) {
        guard let viewController = viewController else { return }
        
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = "Alert"
        let action1 = UIAlertAction(title: model.buttonTitle1, style: .default, handler: model.buttonAction1)
        let action2 = UIAlertAction(title: model.buttonTitle2, style: .default, handler: model.buttonAction2)
        alertController.addAction(action1)
        alertController.addAction(action2)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
