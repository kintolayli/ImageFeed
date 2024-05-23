//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 07.05.2024.
//

import UIKit

class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.backgroundColor = .clear
        
        guard let image = UIImage(named: "\(indexPath.item)") else { return }
        cell.mainImage.image = image
        cell.mainImage.layer.cornerRadius = 16
        cell.mainImage.contentMode = .scaleAspectFill
        
        cell.cellDataLabel.text = dateFormatter.string(from: Date())
        
        if indexPath.item % 2 == 0 {
            cell.likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        }
        cell.likeButton.setTitle("", for: .normal)
        
        let gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            let startColor = UIColor.clear.cgColor
            let endColor = UIColor(white: 0, alpha: 0.2).cgColor
            gradientLayer.colors = [startColor, endColor]
            gradientLayer.frame = cell.gradientView.bounds
            return gradientLayer
        }()
        cell.gradientView.layer.insertSublayer(gradientLayer, at: 0)
        cell.gradientView.layer.corner(radius: 16, corners: [.bottomLeft, .bottomRight])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
            }
        }
    }

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let standartSize = CGFloat(200)
        
        guard let image = UIImage(named: "\(indexPath.item)") else { return standartSize }
        guard let width = image.cgImage?.width else { return standartSize }
        guard let height = image.cgImage?.height else { return standartSize }
        
        let imageRatioFactor = Double(width) / Double(height)
        
        let imageInsets = CGFloat(16)
        let imageViewWidth = tableView.layer.bounds.width - (imageInsets * 2)
        let cellHeight = imageViewWidth / imageRatioFactor
        
        return cellHeight
    }
}

