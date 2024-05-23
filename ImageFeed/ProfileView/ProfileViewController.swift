//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 21.05.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userTextLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageLabel.layer.cornerRadius = profileImageLabel.layer.frame.height / 2
        
    }
    @IBAction func logoutButtonDidTap(_ sender: Any) {
    }
}
