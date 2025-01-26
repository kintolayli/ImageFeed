//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 21.05.2024.
//

import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileImage(image: UIImage)
    func updateProfileDetails(profile: Profile)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - UI Components
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "userpick_stub")
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
        logoutButton.accessibilityIdentifier = "logoutButton"
        logoutButton.tintColor = .ypRed
        return logoutButton
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObserver()
        
        self.presenter?.getProfileDetails()
        self.presenter?.getProfileImage()
        
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
    
    func updateProfileDetails(profile: Profile) {
        DispatchQueue.main.async {
            self.realNameLabel.text = profile.name
            self.usernameLabel.text = profile.loginName
            self.textLabel.text = profile.bio
        }
    }
    
    func updateProfileImage(image: UIImage) {
        DispatchQueue.main.async {
            self.profileImage.image = image
        }
    }
    
    private func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.getProfileImage()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBlack
        
        [profileImage, realNameLabel, usernameLabel, textLabel, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        self.presenter?.showAlert()
    }
}
