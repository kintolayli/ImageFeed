//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 21.05.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
        realNameLabel.text = "Екатерина Новикова"
        realNameLabel.textColor = .ypWhite
        realNameLabel.font = UIFont.systemFont(ofSize: 23)
        return realNameLabel
    }()
    
    private let usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.textColor = .ypGray
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        return usernameLabel
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Hello, world!"
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
        
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        setupUI()
    }
    
    private func setupUI() {
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
    
    @objc
    private func logoutButtonDidTap(_ sender: Any) {
        print("logout")
    }
}
