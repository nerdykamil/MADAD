//
//  Extension.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//


import Foundation
import UIKit

func degreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * CGFloat.pi / 180.0
}

func radiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat.pi
}

func dialogBezierPathWithFrame(_ frame: CGRect, arrowOrientation orientation: UIImage.Orientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
    var transposedFrame = CGRect.zero
    switch orientation {
    case .up, .down, .upMirrored, .downMirrored:
        transposedFrame = CGRect(x: 0, y: 0, width: frame.size.width - frame.origin.x, height: frame.size.height - frame.origin.y)
    case .left, .right, .leftMirrored, .rightMirrored:
        transposedFrame = CGRect(x: 0, y: 0,  width: frame.size.height - frame.origin.y, height: frame.size.width - frame.origin.x)
    }
    let midX = transposedFrame.midX
    let point1 = CGPoint(x: transposedFrame.minX, y: transposedFrame.minY + arrowLength)
    let point2 = CGPoint(x: midX - (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point3 = CGPoint(x: midX, y: transposedFrame.minY)
    let point4 = CGPoint(x: midX + (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point5 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.minY + arrowLength)
    let point6 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.maxY)
    let point7 = CGPoint(x: transposedFrame.minX, y: transposedFrame.maxY)
    
    // Bezier path
    let path = UIBezierPath()
    path.move(to: point1)
    path.addLine(to: point2)
    path.addLine(to: point3)
    path.addLine(to: point4)
    path.addLine(to: point5)
    path.addLine(to: point6)
    path.addLine(to: point7)
    path.close()
    
    
    switch orientation {
    case .up, .upMirrored:
        break
    case .down, .downMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(180.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.width, y: transposedFrame.size.height))
    case .left, .leftMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(-90.0)))
        path.apply(CGAffineTransform(translationX: 0, y: transposedFrame.size.width))
    case .right, .rightMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(90.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.height, y: 0))
    }
    
    return path
}

extension UIView {
    func ArrowDialogOrientation(arrowOrientation: UIImage.Orientation) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dialogBezierPathWithFrame(self.frame, arrowOrientation: arrowOrientation).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd
        self.layer.mask = shapeLayer
    }
    
}
