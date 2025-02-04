//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 09.05.2024.
//

import UIKit


final public class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    private let cellDataLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "SFProText-Regular", size: 13)
        label.font = font
        label.textColor = .ypWhite
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_button_off"), for: .normal)
        button.accessibilityIdentifier = "likeButton"
        button.layer.shadowColor = UIColor.ypBlack.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height:1)
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let mainImage: UIImageView = {
        let view = UIImageView()
        let whiteColorWithAlpha = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        view.backgroundColor = whiteColorWithAlpha
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let gradientView: UIView = {
        let view = GradientView()
        return view
    }()
    
    private let stubImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "scribble")
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse( )
        
        mainImage.kf.cancelDownloadTask()
        
        self.mainImage.image = nil
        self.cellDataLabel.text = nil
        self.stubImageView.isHidden = false
    }
    
    @objc private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "like_button_on" : "like_button_off"
            self.likeButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    func updateCell(cellDataLabelTitle: String, likeButtonTitle: String, imageView: UIImageView) {
        DispatchQueue.main.async {
            self.cellDataLabel.text = cellDataLabelTitle
            self.likeButton.setTitle(likeButtonTitle, for: .normal)
            self.mainImage.image = imageView.image
        }
    }
    
    private func setupUI() {
        
        mainImage.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        [stubImageView, mainImage, cellDataLabel, likeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate( [
            mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            stubImageView.centerXAnchor.constraint(equalTo: mainImage.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: mainImage.centerYAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 83),
            stubImageView.heightAnchor.constraint(equalToConstant: 75),
            
            gradientView.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            cellDataLabel.trailingAnchor.constraint(greaterThanOrEqualTo: mainImage.trailingAnchor),
            cellDataLabel.leadingAnchor.constraint(equalTo: mainImage.leadingAnchor, constant: 8),
            cellDataLabel.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -8),
            cellDataLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 4),
            
            likeButton.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: mainImage.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            
        ])
    }
}
