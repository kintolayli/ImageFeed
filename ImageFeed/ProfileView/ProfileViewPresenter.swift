//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 29.07.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func getProfileImage()
    func getProfileDetails()
    func showAlert()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    
    func getProfileImage() {
        guard let profileImageURL = ProfileImageService.shared.profileImageURL,
              let url = URL(string: profileImageURL)
        else { return }
        
        let profileImageView = UIImageView(image: UIImage(named: "userpick_stub"))
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                                     placeholder: .none,
                                     options: [.processor(processor)]) { result in
            switch result {
            case .success:
                
                guard let profileImage = profileImageView.image else { return }
                self.view?.updateProfileImage(image: profileImage)
                
            case .failure(let error):
                let logMessage =
                """
                [\(String(describing: self)).\(#function)]:
                \(ProfileImageServiceError.fetchProfileImageError) - Ошибка обновления изображения профиля, \(error.localizedDescription)
                """
                print(logMessage)
            }
        }
    }
    
    func getProfileDetails() {
        guard let profile = profileService.profile else {
            return
        }
        view?.updateProfileDetails(profile: profile)
    }
    
    func showAlert() {
        let profileViewController = view as! UIViewController
        let alertPresenter = AlertPresenter(viewController: profileViewController)
        
        let alertModel = AlertModelWith2Buttons(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttonTitle1: "Да",
            buttonAction1: { _ in
                ProfileLogoutService.shared.logout()
                let splashViewController = SplashViewController()
                splashViewController.modalPresentationStyle = .fullScreen
                profileViewController.present(splashViewController, animated: true, completion: nil)
            },
            buttonTitle2: "Нет",
            buttonAction2: nil
        )
        
        alertPresenter.showWith2Buttons(model: alertModel)
    }
}
