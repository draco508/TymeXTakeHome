//
//  RectangleStrockLayer.swift
//  TestApp
//
//  Created by Draco Nguyen on 22/02/2022.
//

import Foundation
import QuartzCore
import UIKit

open class RectangleStrockLayer: CAShapeLayer {
    
    struct Border {
        static let LEFT: UInt8 = 0b00000001
        static let TOP: UInt8 = 0b00000010
        static let RIGHT: UInt8 = 0b00000100
        static let BOTTOM: UInt8 = 0b00001000
        static let ALL: UInt8 = 0b00010000
        static let NONE: UInt8 = 0b00000000
    }
    
    struct Corner {
        static let TOP_LEFT: UInt8 = 0b00000001
        static let TOP_RIGHT: UInt8 = 0b00000010
        static let BOTTOM_RIGHT: UInt8 = 0b00000100
        static let BOTTOM_LEFT: UInt8 = 0b00001000
        static let ALL: UInt8 = 0b00010000
        static let NONE: UInt8 = 0b00000000
    }
    
    var corner: UInt8 = Corner.NONE
    var border: UInt8 = Border.NONE
    var strokeThickness: CGFloat = 0
    var strockColor: CGColor = UIColor.clear.cgColor
    
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    private var bgLayer = CAShapeLayer()
    private var points: [CGPoint?] = [CGPoint?]()
    
    open override var frame: CGRect {
        didSet {
            config()
        }
    }
    
    override public init() {
        super.init()
        bgLayer.lineWidth = 0
        addSublayer(bgLayer)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        bgLayer.lineWidth = 0
        addSublayer(bgLayer)
    }
    
    override public init(layer: Any) {
        super.init(layer: layer)
        bgLayer.lineWidth = 0
        addSublayer(bgLayer)
    }
    
    public func makeChange() {
        config()
        setNeedsDisplay()
    }
    
    private func config() {
       
        bgLayer.fillColor = UIColor.white.cgColor
        bgLayer.strokeColor = UIColor.clear.cgColor
        bgLayer.frame = self.frame
        bgLayer.lineWidth = 0.0
        bgLayer.path = drawBackground()
        
        width = frame.width
        height = frame.height
        
        points = generatePoints()
        let cgPath = generatePath(startIndex: 0)
        if cgPath != nil {
            closePath(path: cgPath!)
            self.path = cgPath
        }

        self.lineWidth = strokeThickness
        self.strokeColor = strockColor

    }
    
    private func generatePath(startIndex: Int)-> CGMutablePath? {
        var path: CGMutablePath? = nil
        var nextPathPointIndex: Int? = nil
        
        var firtPointIndex: Int? = nil
        for i in startIndex...(points.count - 1) {
            if points[i] != nil {
                firtPointIndex = i
                break
            }
        }
        if firtPointIndex == nil {
            return nil
        }
        
        for i in firtPointIndex!...(points.count - 1) {
            if points[i] != nil {
                if path == nil {
                    path = CGMutablePath()
                }
                gotoNextPoint(cgPath: path!, nextIndex: i)
            } else {
                nextPathPointIndex = i
                break
            }
        }
        
        if nextPathPointIndex != nil {
            let nextPath = generatePath(startIndex: nextPathPointIndex!)
            if nextPath != nil {
                path?.addPath(nextPath!)
            }
        }
        return path
    }
    
    private func gotoNextPoint(cgPath: CGMutablePath, nextIndex: Int) {
        if nextIndex == 0 {
            cgPath.move(to: points[0]!)
        } else {
            let prevPoint = points[nextIndex - 1]
            let currPoint = points[nextIndex]!
            if prevPoint == nil {
                cgPath.move(to: points[nextIndex]!)
            } else {
                if isArcLine(point1: prevPoint!, point2: currPoint) {
                    let angles = startAndEndAngle(currentIndex: nextIndex)!
                    cgPath.addArc(center: arcCenterPoint(currentIndex: nextIndex)!,
                                  radius: self.cornerRadius - strokeThickness / 2,
                                  startAngle: angles.start, endAngle: angles.end, clockwise: false)
                } else {
                    cgPath.addLine(to: currPoint)
                }
            }
        }
    }
    
    private func isArcLine(point1: CGPoint, point2: CGPoint)-> Bool {
        return (abs(point1.x - point2.x) > strokeThickness) && (abs(point1.y - point2.y) > strokeThickness)
    }
    
    private func arcCenterPoint(currentIndex: Int)-> CGPoint? {
        if currentIndex == 2 {
            return CGPoint(x: width - self.cornerRadius, y: self.cornerRadius)
        }
        
        if currentIndex == 4 {
            return CGPoint(x: width - self.cornerRadius, y: height - self.cornerRadius)
        }
        
        if currentIndex == 6 {
            return CGPoint(x: self.cornerRadius, y: height - self.cornerRadius)
        }
        
        return nil
    }
    
    private func startAndEndAngle(currentIndex: Int) -> (start: CGFloat, end: CGFloat)? {
        if currentIndex == 2 {
            return (.pi * 3/2, 0)
        }
        
        if currentIndex == 4 {
            return (0, .pi / 2)
        }
        
        if currentIndex == 6 {
            return (.pi / 2, .pi)
        }
        
        return nil
    }
    
    private func closePath(path: CGMutablePath) {
        let prev = points[7]
        let curr = points[0]
        if prev != nil && curr != nil {
            if isArcLine(point1: prev!, point2: curr!) {
                path.addArc(center: CGPoint(x: self.cornerRadius, y: self.cornerRadius),
                            radius: self.cornerRadius - strokeThickness / 2,
                            startAngle: .pi,
                            endAngle: .pi * 3/2,
                            clockwise: false)
            } else {
                path.addLine(to: curr!)
            }
        }
    }
    
    private func generatePoints()-> [CGPoint?] {
        var points = [CGPoint?]()
        points.append(calculateTopLeftPoint1(layer: self))
        points.append(calculateTopRightPoint1(layer: self))
        points.append(calculateTopRightPoint2(layer: self))
        points.append(calculateBottomRightPoint1(layer: self))
        points.append(calculateBottomRightPoint2(layer: self))
        points.append(calculateBottomLeftPoint1(layer: self))
        points.append(calculateBottomLeftPoint2(layer: self))
        points.append(calculateTopLeftPoint2(layer: self))
        return points
    }
    
    private func calculateTopLeftPoint1(layer: CALayer)-> CGPoint? {
        if !isBorderTop() {
            return nil
        }
        
        var x: CGFloat = 0
        let y: CGFloat = strokeThickness / 2
        if isCornerTopLeft() {
            x = layer.cornerRadius
        }
        return CGPoint(x: x, y: y)
    }
    
    private func calculateTopRightPoint1(layer: CALayer)-> CGPoint? {
        if !isBorderTop() {
            return nil
        }
        var x: CGFloat = width - strokeThickness / 2
        
        if !isBorderRight() {
            x = width
        }
        
        if isCornerTopRight() {
            x = width - layer.cornerRadius
        }
        
        let y: CGFloat = strokeThickness / 2
        return CGPoint(x: x, y: y)
    }
    
    private func calculateTopRightPoint2(layer: CALayer)-> CGPoint? {
        if !isBorderRight() {
            return nil
        }
        
        let x: CGFloat = width - strokeThickness / 2
        var y: CGFloat = strokeThickness / 2
        
        if !isBorderTop() {
            y = 0
        }
        
        if isCornerTopRight() {
            y = layer.cornerRadius
        }
        return CGPoint(x: x, y: y)
    }
    
    private func calculateBottomRightPoint1(layer: CALayer)-> CGPoint? {
        if !isBorderRight() {
            return nil
        }
        let x: CGFloat = width - strokeThickness / 2
        var y: CGFloat = height - strokeThickness / 2
        
        if !isBorderBottom() {
            y = height
        }
       
        if isCornerBottomRight() {
            y = height - layer.cornerRadius
        }
        return CGPoint(x: x, y: y)
    }
    
    private func calculateBottomRightPoint2(layer: CALayer)-> CGPoint? {
        if !isBorderBottom() {
            return nil
        }
        var x: CGFloat = width - strokeThickness / 2
        
        if !isBorderRight() {
            x = width
        }
        
        if isCornerBottomRight() {
            x = width - layer.cornerRadius
        }
        
        let y: CGFloat = height - strokeThickness / 2
        return CGPoint(x: x, y: y)
    }
    
    private func calculateBottomLeftPoint1(layer: CALayer)-> CGPoint? {
        if !isBorderBottom() {
            return nil
        }
        var x: CGFloat = strokeThickness / 2
        if !isBorderLeft() {
            x = 0
        }
        
        if isCornerBottomLeft() {
            x = layer.cornerRadius
        }
        
        let y: CGFloat = height - strokeThickness / 2
        return CGPoint(x: x, y: y)
    }
    
    private func calculateBottomLeftPoint2(layer: CALayer)-> CGPoint? {
        if !isBorderLeft() {
            return nil
        }
        let x: CGFloat = strokeThickness / 2
        var y: CGFloat = height - strokeThickness / 2
        
        if !isBorderBottom() {
            y = height
        }
        
        if isCornerBottomLeft() {
            y = height - layer.cornerRadius
        }
        return CGPoint(x: x, y: y)
    }
    
    private func calculateTopLeftPoint2(layer: CALayer)-> CGPoint? {
        if !isBorderLeft() {
            return nil
        }
        
        let x: CGFloat = strokeThickness / 2
        var y: CGFloat = strokeThickness / 2
        
        if !isBorderTop() {
            y = 0
        }
        
        if isCornerTopLeft() {
            y = layer.cornerRadius
        }
        return CGPoint(x: x, y: y)
    }
    
    private func drawBackground() -> CGMutablePath{
        let cgPath = CGMutablePath()
        var topY = 0.0
        if isBorderTop() {
            topY = strokeThickness
        }
        
        var leftX = 0.0
        if isBorderLeft() {
            leftX = strokeThickness
        }
        
        var rightX = self.frame.width
        if isBorderRight() {
            rightX -= strokeThickness
        }
        
        var bottomY = self.frame.height
        if isBorderBottom() {
            bottomY -= strokeThickness
        }
        
        if isCornerTopLeft() {
            cgPath.move(to: CGPoint(x: cornerRadius, y: topY))
        } else {
            cgPath.move(to: CGPoint(x: leftX, y: topY))
        }
        
        if isCornerTopRight() {
            cgPath.addLine(to: CGPoint(x: self.frame.width - cornerRadius, y: topY))
        } else {
            cgPath.addLine(to: CGPoint(x: rightX, y: topY))
        }
        
        if isCornerTopRight() {
            cgPath.addArc(center: CGPoint(x: self.frame.width - self.cornerRadius, y: self.cornerRadius),
                        radius: self.cornerRadius - strokeThickness,
                        startAngle: .pi * 3/2,
                        endAngle: 0,
                        clockwise: false)
        }
        
        if isCornerBottomRight() {
            cgPath.addLine(to: CGPoint(x: rightX, y: self.frame.height - cornerRadius))
        } else {
            cgPath.addLine(to: CGPoint(x: rightX, y: bottomY))
        }
        
        if isCornerBottomRight() {
            cgPath.addArc(center: CGPoint(x: self.frame.width - self.cornerRadius, y: self.frame.height - self.cornerRadius),
                        radius: self.cornerRadius - strokeThickness,
                        startAngle: 0,
                        endAngle: .pi / 2,
                        clockwise: false)
        }
        
        if isCornerBottomLeft() {
            cgPath.addLine(to: CGPoint(x: self.cornerRadius, y: bottomY))
        } else {
            cgPath.addLine(to: CGPoint(x: leftX, y: bottomY))
        }
        
        if isCornerBottomLeft() {
            cgPath.addArc(center: CGPoint(x: self.cornerRadius, y: self.frame.height - self.cornerRadius),
                        radius: self.cornerRadius - strokeThickness,
                          startAngle: .pi / 2,
                        endAngle: .pi,
                        clockwise: false)
        }
        
        if isCornerTopLeft() {
            cgPath.addLine(to: CGPoint(x: leftX, y: self.cornerRadius))
        } else {
            cgPath.addLine(to: CGPoint(x: leftX, y: topY))
        }
        
        if isCornerTopLeft() {
            cgPath.addArc(center: CGPoint(x: self.cornerRadius, y: self.cornerRadius),
                        radius: self.cornerRadius - strokeThickness,
                          startAngle: .pi,
                        endAngle: .pi * 3/2,
                        clockwise: false)
        }
        
        return cgPath
        
    }
    
    private func isCornerTopRight()-> Bool {
        return (corner & Corner.TOP_RIGHT) == Corner.TOP_RIGHT
        || (corner & Corner.ALL) == Corner.ALL
    }
    
    private func isCornerTopLeft()-> Bool {
        return (corner & Corner.TOP_LEFT) == Corner.TOP_LEFT
        || (corner & Corner.ALL) == Corner.ALL
    }
    
    private func isCornerBottomRight()-> Bool {
        return (corner & Corner.BOTTOM_RIGHT) == Corner.BOTTOM_RIGHT
        || (corner & Corner.ALL) == Corner.ALL
    }
    
    private func isCornerBottomLeft()-> Bool {
        return (corner & Corner.BOTTOM_LEFT) == Corner.BOTTOM_LEFT
        || (corner & Corner.ALL) == Corner.ALL
    }
    
    private func isBorderTop()-> Bool {
        return (border & Border.TOP) == Border.TOP || (border & Border.ALL) == Border.ALL
    }
    
    private func isBorderLeft()-> Bool {
        return (border & Border.LEFT) == Border.LEFT || (border & Border.ALL) == Border.ALL
    }
    
    private func isBorderBottom()-> Bool {
        return (border & Border.BOTTOM) == Border.BOTTOM || (border & Border.ALL) == Border.ALL
    }
    
    private func isBorderRight()-> Bool {
        return (border & Border.RIGHT) == Border.RIGHT || (border & Border.ALL) == Border.ALL
    }
}
