//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 21.05.2024.
//

import UIKit
import Kingfisher
import WebKit

class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - UI Components
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "userpick_photo")
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    private let realNameLabel: UILabel = {
        let realNameLabel = UILabel()
        realNameLabel.text = ""
        realNameLabel.textColor = .ypWhite
        realNameLabel.font = UIFont.systemFont(ofSize: 23)
        return realNameLabel
    }()
    
    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = ""
        usernameLabel.textColor = .ypGray
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        return usernameLabel
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = ""
        textLabel.textColor = .ypWhite
        textLabel.font = UIFont.systemFont(ofSize: 13)
        return textLabel
    }()
    
    private let logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: ProfileViewController.self,
            action: nil
        )
        logoutButton.tintColor = .ypRed
        
        return logoutButton
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateProfileImage()
        }
        updateProfileImage()
        
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        setupUI()
    }
    
    private func updateProfileImage() {
        guard let profileImageURL = ProfileImageService.shared.profileImageURL,
              let url = URL(string: profileImageURL)
        else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url,
                                 placeholder: UIImage(named: "userpick_stub"),
                                 options: [.processor(processor)]) { result in
            switch result {
            case .success(let value):
                print(value.image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        self.realNameLabel.text = profile.name
        self.usernameLabel.text = profile.loginName
        self.textLabel.text = profile.bio
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBlack
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        realNameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImage)
        view.addSubview(realNameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(textLabel)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            realNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            realNameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: realNameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func clearCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    func clearWebsiteData() {
        let dataStore = WKWebsiteDataStore.default()
        let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        
        dataStore.removeData(ofTypes: dataTypes, modifiedSince: date) {
            print("Все данные WKWebsiteDataStore были очищены")
        }
    }
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        OAuth2TokenStorage.deleteToken()
        clearCookies()
        clearWebsiteData()
        
        let viewController = SplashViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
