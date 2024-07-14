//
//  extension+CALayer.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 09.05.2024.
//

import UIKit

extension CALayer {
    func corner(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        if #available(iOS 11.0, *) {
            masksToBounds = true
            cornerRadius = radius
            maskedCorners = corners.caCornerMask
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            mask = shapeLayer
            setNeedsDisplay()
        }
    }
}

extension UIRectCorner {
    var caCornerMask: CACornerMask {
        var cornersMask = CACornerMask()
        if self.contains(.topLeft) {
            cornersMask.insert(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) {
            cornersMask.insert(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomLeft) {
            cornersMask.insert(.layerMinXMaxYCorner)
        }
        if self.contains(.bottomRight) {
            cornersMask.insert(.layerMaxXMaxYCorner)
        }
        return cornersMask
    }
}
