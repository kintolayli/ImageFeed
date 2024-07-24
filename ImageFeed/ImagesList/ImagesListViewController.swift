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
    
    let placeholderImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "scribble")
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        return tableView
    }()
    
    private var photos: [Photo] = []
    private let imageListService = ImageListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        UIBlockingProgressHUD.show()
        imageListService.fetchPhotosNextPage() { _ in }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imageListServiceObserver = NotificationCenter.default
              .addObserver(
                  forName: ImageListService.didChangeNotification,
                  object: nil,
                  queue: .main
              ) { [weak self] _ in
                  guard let self = self else { return }
                  
                  self.updateTableViewAnimated()
                  UIBlockingProgressHUD.dismiss()
                  placeholderImage.isHidden = true
              }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        view.addSubview(placeholderImage)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypBlack
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 83),
            placeholderImage.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.backgroundColor = .clear
        
        guard let url = URL(string: photos[indexPath.item].thumbImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 8)
        cell.mainImage.kf.indicatorType = .activity
        
        cell.mainImage.kf.setImage(with: url,
                                   placeholder: .none,
                                 options: [.processor(processor)]) { result in
            switch result {
            case .success(let value):
                print(value.image)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        cell.cellDataLabel.text = dateFormatter.string(from: Date())
        cell.likeButton.setTitle("", for: .normal)
        cell.setIsLiked(state: photos[indexPath.item].isLiked)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.prepareForReuse()
        cell.delegate = self
        
        configCell(for: cell, with: indexPath)
        return cell
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
            UIBlockingProgressHUD.show()
            imageListService.fetchPhotosNextPage { result in
                self.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        UIBlockingProgressHUD.show()

        guard let url = URL(string: photos[indexPath.item].largeImageUrl) else { return }
        let viewController = SingleImageViewController()
        viewController.delegate = self
        viewController.downloadFullImage(url: url)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
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

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imageListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { result in
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.photos = self.imageListService.photos
                cell.setIsLiked(state: self.photos[indexPath.row].isLiked)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось поставить лайк",
                    buttonTitle: "ОК",
                    buttonAction: nil
                )
                let alertPresenter = AlertPresenter(viewController: self)
                alertPresenter.show(model: alertModel)
            }
        }
    }
}
