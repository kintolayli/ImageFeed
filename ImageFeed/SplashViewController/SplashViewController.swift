//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 12.06.2024.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        return imageView
    }()
    
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    private let authenticationScreenSegueIdentifier = "AuthenticationScreenSegue"
    private let imagesListScreenSegue = "ImagesListScreenSegue"
    
    var delegate: AuthViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token {
            fetchProfile(token: token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: authenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 75.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 77.68)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for \(authenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuntenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {
                fatalError("Failed to dismiss AuthViewController")
            }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {
                // TODO: - Если вместо return вставить fatalError("Failed to fetch OAuth token"), то приложение падает в этом месте. Почему?
//                fatalError("Failed to fetch OAuth token")
                return
            }

            switch result {
            case .success(_):
                performSegue(withIdentifier: imagesListScreenSegue, sender: nil)
                switchToTabBarController()
            case .failure(_):
                fatalError("Error getting profile data")
                break
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {
                fatalError("Failed to fetch OAuth token")
            }
            
            switch result {
            case .success:
                guard let token = tokenStorage.token else {
                    fatalError("Failed to get OAuth token")
                }
                fetchProfile(token: token)
                
                self.switchToTabBarController()
            case .failure:
                print("Failed to fetch OAuth token")
                
                let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОK", style: .default))
                self.present(alert, animated: true, completion: nil)
                
                break
            }
        }
    }
}
