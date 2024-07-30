//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 07.05.2024.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    var tableView: UITableView { get }
    var imageListService: ImageListService { get }
    func reloadRows(indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    internal let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    var presenter: ImagesListPresenterProtocol?
    var photos: [Photo] = []
    
    private let placeholderImage: UIImageView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        setupObserver()
    }
    
    func reloadRows(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func setupObserver() {
        UIBlockingProgressHUD.show()
        imageListService.fetchPhotosNextPage() { _ in }
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
        tableView.backgroundColor = .ypBlack
        
        [tableView, placeholderImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
    
    private func updateTableViewAnimated() {
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
        
        self.presenter?.configCell(for: cell, with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 && !ProcessInfo.processInfo.arguments.contains("UITEST"){
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
        viewController.rescaleAndCenterImageInScrollView()
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
        self.presenter?.imageListCellDidTapLike(cell)
    }
}
