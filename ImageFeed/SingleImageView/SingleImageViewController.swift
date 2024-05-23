//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 21.05.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
