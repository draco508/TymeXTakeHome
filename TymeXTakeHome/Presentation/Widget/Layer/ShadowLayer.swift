//
//  ShadowLayer.swift
//  TestApp
//
//  Created by Draco Nguyen on 08/07/2022.
//

import Foundation
import UIKit

open class ShadowLayer: CAShapeLayer {
    
    //var corner
    
    
    open override var frame: CGRect {
        didSet {
            shadowPath = customShadowPath()
            if isShadowTop || isShadowBottom{
                shadowOffset = CGSize(width: 0, height: shadowRadius / 4)
            }
        }
    }
    
    var isShadowLeft: Bool = false
    var isShadowTop: Bool = false
    var isShadowRight: Bool = false
    var isShadowBottom: Bool = false
    var isCornerTopLeft: Bool = false
    var isCornerTopRight: Bool = false
    var isCornerBottomRight: Bool = false
    var isCornerBottomLeft: Bool = false
   
    func update() {
        shadowPath = customShadowPath()
        if isShadowTop || isShadowBottom{
            shadowOffset = CGSize(width: 0, height: shadowRadius / 4)
        }
    }
    
    private func customShadowPath() -> CGMutablePath {
        self.lineWidth = 0
        
        let path = CGMutablePath()
        
        let topLeftPoint = topLeftPoint()
        path.move(to: topLeftPoint)
        
        let topRightPoint = topRightPoint()
        path.addLine(to: topRightPoint)
        if isCornerTopRight {
            cornerTopRight(path: path, topRightPoint: topRightPoint)
        }
        
        let bottomRightPoint = bottomRightPoint()
        path.addLine(to: bottomRightPoint)
        if isCornerBottomRight {
            cornerBottomRight(path: path, bottomRightPoint: bottomRightPoint)
        }
        
        let bottomLeftPoint = bottomLeftPoint()
        path.addLine(to: bottomLeftPoint)
        if isCornerBottomLeft {
            cornerBottomleft(path: path, bottomLeftPoint: bottomLeftPoint)
        }
        
        if isCornerTopLeft {
            let closePoint = closePoint()
            path.addLine(to: closePoint)
            cornerTopleft(path: path, closePoint: closePoint)
        } else {
            path.addLine(to: topLeftPoint)
        }
        
        return path
    }
    
    private func topLeftPoint()-> CGPoint {
        var x = self.shadowRadius / 2
        var y = self.shadowRadius / 2
        if !isShadowLeft {
            x -= self.shadowRadius * 5 / 2
        }
        
        if isCornerTopLeft {
            x += self.cornerRadius
        }
        
        if !isShadowTop {
            y -= self.shadowRadius * 5 / 2
        }
        
        
        return CGPoint(x: x, y: y)
    }
    
    private func topRightPoint()-> CGPoint {
        var x = self.bounds.size.width - self.shadowRadius / 2
        var y = self.shadowRadius / 2
        if !isShadowRight {
            x += self.shadowRadius * 5 / 2
        }
        
        if !isShadowTop {
            y -= self.shadowRadius * 5 / 2
        }
        
        if isCornerTopRight {
            x -= self.cornerRadius
        }
        
        return CGPoint(x: x, y: y)
    }
    
    private func cornerTopRight(path: CGMutablePath, topRightPoint: CGPoint) {
        path.addArc(center: CGPoint(x: topRightPoint.x, y: topRightPoint.y + self.cornerRadius),
                    radius: self.cornerRadius,
                    startAngle: .pi * 3/2,
                    endAngle: 0,
                    clockwise: false)
    }
    
    private func bottomRightPoint()-> CGPoint {
        var x = self.bounds.size.width - self.shadowRadius / 2
        var y = self.bounds.size.height - self.shadowRadius / 2
        
        if !isShadowRight {
            x += self.shadowRadius * 5 / 2
        }
        
        if !isShadowBottom {
            y += self.shadowRadius * 5 / 2
        }
        
        if isCornerBottomRight {
            y -= self.cornerRadius
        }
        
        return CGPoint(x: x, y: y)
    }
    
    private func cornerBottomRight(path: CGMutablePath, bottomRightPoint: CGPoint) {
        path.addArc(center: CGPoint(x: bottomRightPoint.x - self.cornerRadius, y: bottomRightPoint.y),
                    radius: self.cornerRadius,
                    startAngle: 0,
                    endAngle: .pi / 2,
                    clockwise: false)
    }
    
    private func bottomLeftPoint()-> CGPoint {
        var x = self.shadowRadius / 2
        var y = self.bounds.size.height - self.shadowRadius / 2
        
        if !isShadowLeft {
            x -= self.shadowRadius * 5 / 2
        }
        
        if !isShadowBottom {
            y += self.shadowRadius * 5 / 2
        }
        
        if isCornerBottomLeft {
            x += self.cornerRadius
        }
        
        return CGPoint(x: x, y: y)
    }
    
    private func cornerBottomleft(path: CGMutablePath, bottomLeftPoint: CGPoint) {
        path.addArc(center: CGPoint(x: bottomLeftPoint.x, y: bottomLeftPoint.y - self.cornerRadius),
                    radius: self.cornerRadius,
                    startAngle: .pi / 2,
                    endAngle: .pi,
                    clockwise: false)
    }
    
    private func closePoint()-> CGPoint {
        var x = self.shadowRadius / 2
        var y = self.shadowRadius / 2
        if !isShadowLeft {
            x -= self.shadowRadius * 5 / 2
        }
        
        if !isShadowTop {
            y -= self.shadowRadius * 5 / 2
        }
        
        if isCornerTopLeft {
            y += self.cornerRadius
        }
        
        return CGPoint(x: x, y: y)
    }
    
    private func cornerTopleft(path: CGMutablePath, closePoint: CGPoint) {
        path.addArc(center: CGPoint(x: closePoint.x + self.cornerRadius, y: closePoint.y),
                    radius: self.cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi * 3/2,
                    clockwise: false)
    }
}
