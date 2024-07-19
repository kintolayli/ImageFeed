//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 07.05.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    private var photos: [Photo] = []
    private let imageListService = ImageListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageListService.fetchPhotosNextPage() { _ in }
        
        imageListServiceObserver = NotificationCenter.default
              .addObserver(
                  forName: ImageListService.didChangeNotification,
                  object: nil,
                  queue: .main
              ) { [weak self] _ in
                  guard let self = self else { return }
                  
                  updateTableViewAnimated()
              }
    }
    
    private func updateListViewImage(indexPath: IndexPath) {
        guard let url = URL(string: imageListService.photos[indexPath.item].largeImageUrl) else { return }
        let imageView = UIImageView()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
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
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.backgroundColor = .clear
        
        guard let placeholder_image = UIImage(named: "userpick_stub") else { return }
        guard let url = URL(string: photos[indexPath.item].thumbImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        cell.mainImage.kf.indicatorType = .activity
        
        cell.mainImage.kf.setImage(with: url,
                                   placeholder: placeholder_image,
                                 options: [.processor(processor)]) { result in
            switch result {
            case .success(let value):
                print(value.image)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
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
            
            let imageView = UIImageView()
            guard let placeholder_image = UIImage(named: "userpick_stub") else { return }
            guard let url = URL(string: photos[indexPath.item].largeImageUrl) else { return }
            let processor = RoundCornerImageProcessor(cornerRadius: 16)
            imageView.kf.indicatorType = .activity
            
            imageView.kf.setImage(with: url,
                                       placeholder: placeholder_image,
                                     options: [.processor(processor)]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    viewController.image = imageView.image
                case .failure(let error):
                    print(error.localizedDescription)
                    viewController.image = placeholder_image
                }
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        cell.prepareForReuse()
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imageListService.fetchPhotosNextPage { result in
                self.updateTableViewAnimated()
            }
        }
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

