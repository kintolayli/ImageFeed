//
//  GradientView.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 22.07.2024.
//

import UIKit


class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        let startColor = UIColor.clear.cgColor
        let endColor = UIColor(white: 0, alpha: 0.2).cgColor
        gradientLayer.colors = [startColor, endColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
