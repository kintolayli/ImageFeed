//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 21.05.2024.
//

import UIKit


final class SingleImageViewController: UIViewController {
    
    private var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView.image = image
            imageView.frame.size = image.size
        }
    }
    weak var delegate: UIViewController?
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentMode = .scaleToFill
        scrollView.backgroundColor = .ypBlack
        return scrollView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scribble")
        return imageView
    }()
    
    private let sharingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        return button
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Backward"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        scrollView.delegate = self
        
        sharingButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
    }
    
    @objc private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if #available(iOS 13.0, *) {
            activityViewController.overrideUserInterfaceStyle = .dark
        }
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.postToFacebook
        ]
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func rescaleAndCenterImageInScrollView() {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        guard let image = imageView.image else { return }
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func downloadFullImage(url: URL) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.rescaleAndCenterImageInScrollView()
            case .failure(let error):
                self.showError(url)
                
                let logMessage =
                """
                [\(String(describing: self)).\(#function)]:
                - Ошибка загрузки изображения, \(error.localizedDescription)")
                """
                print(logMessage)
            }
        }
    }
    
    func showError(_ url: URL) {
        
        let alertModel = AlertModelWith2Buttons(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            buttonTitle1: "Не надо",
            buttonAction1: nil,
            buttonTitle2: "Повторить",
            buttonAction2: { [weak self] _ in
                self?.downloadFullImage(url: url)
            }
        )
        let alertPresenter = AlertPresenter(viewController: self)
        alertPresenter.showWith2Buttons(model: alertModel)
    }
    
    private func setupUI() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        [scrollView, sharingButton, backwardButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backwardButton.widthAnchor.constraint(equalToConstant: 48),
            backwardButton.heightAnchor.constraint(equalToConstant: 48),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backwardButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            sharingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sharingButton.heightAnchor.constraint(equalToConstant: 51),
            
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let view = view else { return }
        
        let offsetX = max((scrollView.bounds.size.width - view.frame.size.width) / 2, 0)
        let offsetY = max((scrollView.bounds.size.height - view.frame.size.height) / 2, 0)
        
        UIView.animate(withDuration: 0.3) {
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        }
    }
}
