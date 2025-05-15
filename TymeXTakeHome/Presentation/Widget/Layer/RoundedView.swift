//
//  CALayerView.swift
//  TestApp
//
//  Created by Draco Nguyen on 23/02/2022.
//

import Foundation
import UIKit

open class RoundedView: UIView {
    
    public struct Border {
        public static let LEFT: UInt8 = 0b00000001
        public static let TOP: UInt8 = 0b00000010
        public static let RIGHT: UInt8 = 0b00000100
        public static let BOTTOM: UInt8 = 0b00001000
        public static let ALL: UInt8 = 0b00010000
        public static let NONE: UInt8 = 0b00000000
    }
    
    public struct Corner {
        public static let TOP_LEFT: UInt8 = 0b00000001
        public static let TOP_RIGHT: UInt8 = 0b00000010
        public static let BOTTOM_RIGHT: UInt8 = 0b00000100
        public static let BOTTOM_LEFT: UInt8 = 0b00001000
        public static let ALL: UInt8 = 0b00010000
        public static let NONE: UInt8 = 0b00000000
    }
    
    public struct Shadow {
        public static let LEFT: UInt8 = 0b00000001
        public static let TOP: UInt8 = 0b00000010
        public static let RIGHT: UInt8 = 0b00000100
        public static let BOTTOM: UInt8 = 0b00001000
        public static let ALL: UInt8 = 0b00010000
        public static let NONE: UInt8 = 0b00000000
    }
    
    private var corner: UInt8 = Corner.NONE
    private var border: UInt8 = Border.NONE
    private var cornerRadius: Int = 0
    private var strockThickness: CGFloat = 0
    private var borderColor: CGColor = UIColor.lightGray.cgColor
    private var shadow: UInt8 = Shadow.NONE
    private var needChanged = false
    private var needShadowChanged = false
    
    private var shadowLayer: ShadowLayer?
    private var caLayer = RectangleStrockLayer()
    private var maskLayer = CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initLayer()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayer()
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        caLayer.frame = self.bounds
        maskLayer.frame = self.bounds
        shadowLayer?.frame = self.bounds
        updateMaskLayer()
    }
    
    open func setCorner(type: UInt8) {
        if type != self.corner {
            self.corner = type
            needChanged = true
        }
    }
    
    open func setBorder(type: UInt8) {
        if type != self.border {
            self.border = type
            needChanged = true
        }
    }
    
    open func setCornerRadius(radius: Int) {
        if radius != self.cornerRadius {
            self.cornerRadius = radius
            self.shadowLayer?.cornerRadius = CGFloat(radius)
            needChanged = true
        }
    }
    
    open func setStrockThickness(thickness: CGFloat) {
        if self.strockThickness != thickness {
            self.strockThickness = thickness
            needChanged = true
        }
    }
    
    open func setStrockColor(color: CGColor) {
        if self.borderColor != color {
            self.borderColor = color
            needChanged = true
        }
    }
    
    open func setShadowSide(shadow: UInt8) {
        if shadow != RoundedView.Shadow.NONE {
            if self.shadowLayer == nil {
                self.shadowLayer = ShadowLayer()
            } else {
                needShadowChanged = true
            }
            
            self.shadow = shadow
            self.shadowLayer?.shadowOpacity = 0.5
            self.shadowLayer?.isShadowTop = isShadowTop()
            self.shadowLayer?.isShadowLeft = isShadowLeft()
            self.shadowLayer?.isShadowRight = isShadowRight()
            self.shadowLayer?.isShadowBottom = isShadowBottom()
            if !needShadowChanged {
                layer.insertSublayer(self.shadowLayer!, at: 0)
            }
            
            needChanged = true
        } else if self.shadowLayer != nil {
            self.shadowLayer?.removeFromSuperlayer()
            self.shadowLayer = nil
        }
    }
    
    open func setShadowOpacity(opacity: Float) {
        self.shadowLayer?.shadowOpacity = opacity
    }
    
    open func setShadowRadius(radius: Float) {
        self.shadowLayer?.shadowRadius = CGFloat(radius)
    }
    
    open func makeChange() {
        if needChanged {
            if isShadowLeft() || isShadowTop() || isShadowRight() || isShadowBottom() {
                self.borderColor = UIColor.clear.cgColor
            }
            
            updateMaskLayer()
            updateBorderLayer()
            updateShadow()
            needChanged = false
        }
    }
    
    private func initLayer() {
        layer.insertSublayer(caLayer, at: 0)
        updateMaskLayer()
        layer.mask = maskLayer
    }
    
    private func updateMaskLayer() {
        maskLayer.lineWidth = 0
        if self.shadow == RoundedView.Shadow.NONE {
            var corners = UIRectCorner()
            if isCornerTopLeft() {
                corners.insert(.topLeft)
            }
            if isCornerTopRight() {
                corners.insert(.topRight)
            }
            if isCornerBottomRight() {
                corners.insert(.bottomRight)
            }
            if isCornerBottomLeft() {
                corners.insert(.bottomLeft)
            }
            let path = UIBezierPath(roundedRect:bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            maskLayer.path = path.cgPath
        } else {
            var x = 0.0
            var y = 0.0
            var width = self.bounds.width
            var height = self.bounds.height
            let radius = self.shadowLayer?.shadowRadius ?? 0.0
            if isShadowLeft() {
                x -= radius * 3/2
                width += radius * 3/2
            }
            
            if isShadowTop() {
                y -= radius * 3/2
                height += radius * 3/2
            }
            
            if isShadowRight() {
                width += radius * 3/2
            }
            
            if isShadowBottom() {
                height += radius * 3/2
            }
            
            var corners = UIRectCorner()
            if isCornerTopLeft() && (isShadowLeft() && isShadowTop()){
                corners.insert(.topLeft)
            }
            if isCornerTopRight() && (isShadowRight() && isShadowTop()) {
                corners.insert(.topRight)
            }
            if isCornerBottomRight() && (isShadowRight() && isShadowBottom()) {
                corners.insert(.bottomRight)
            }
            if isCornerBottomLeft() && (isShadowLeft() && isShadowBottom()) {
                corners.insert(.bottomLeft)
            }
            
            maskLayer.path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: width, height: height), byRoundingCorners: corners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius)).cgPath
        }
    }
    
    private func updateBorderLayer() {
        caLayer.strockColor = borderColor
        caLayer.strokeThickness = self.strockThickness
        caLayer.cornerRadius = CGFloat(self.cornerRadius)
        caLayer.fillColor = UIColor.clear.cgColor
       
        var corner: UInt8 = RectangleStrockLayer.Corner.NONE
        if isCornerTopLeft() {
            corner = corner|RectangleStrockLayer.Corner.TOP_LEFT
        }
        if isCornerTopRight() {
            corner = corner|RectangleStrockLayer.Corner.TOP_RIGHT
        }
        if isCornerBottomRight() {
            corner = corner|RectangleStrockLayer.Corner.BOTTOM_RIGHT
        }
        if isCornerBottomLeft() {
            corner = corner|RectangleStrockLayer.Corner.BOTTOM_LEFT
        }
        
        caLayer.corner = corner
        
        var border = RectangleStrockLayer.Border.NONE
        if isBorderTop() {
            border = border|RectangleStrockLayer.Border.TOP
        }
        if isBorderRight() {
            border = border|RectangleStrockLayer.Border.RIGHT
        }
        if isBorderBottom() {
            border = border|RectangleStrockLayer.Border.BOTTOM
        }
        if isBorderLeft() {
            border = border|RectangleStrockLayer.Border.LEFT
        }
        
        caLayer.border = border
        caLayer.makeChange()
    }
    
    private func updateShadow() {
        self.shadowLayer?.isCornerTopLeft = isCornerTopLeft()
        self.shadowLayer?.isCornerTopRight = isCornerTopRight()
        self.shadowLayer?.isCornerBottomRight = isCornerBottomRight()
        self.shadowLayer?.isCornerBottomLeft = isCornerBottomLeft()
        self.shadowLayer?.cornerRadius = CGFloat(self.cornerRadius)
        if needShadowChanged {
            self.shadowLayer?.update()
        }
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
    
    private func isShadowLeft()-> Bool {
        return (shadow & Shadow.LEFT) == Shadow.LEFT || (shadow & Shadow.ALL) == Shadow.ALL
    }
    
    private func isShadowTop()-> Bool {
        return (shadow & Shadow.TOP) == Shadow.TOP || (shadow & Shadow.ALL) == Shadow.ALL
    }
    
    private func isShadowRight()-> Bool {
        return (shadow & Shadow.RIGHT) == Shadow.RIGHT || (shadow & Shadow.ALL) == Shadow.ALL
    }
    
    private func isShadowBottom()-> Bool {
        return (shadow & Shadow.BOTTOM) == Shadow.BOTTOM || (shadow & Shadow.ALL) == Shadow.ALL
    }
}
