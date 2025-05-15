//
//  ViewExtension.swift
//  TestApp
//
//  Created by ph quang on 18/11/2021.
//

import Foundation
import UIKit
import WebKit

public protocol Highlightable {
    func show(highlight: Bool)
}

open class OpacityHighlight: Highlightable {
    
    private weak var view: UIView?
    private var highlightAlpha: CGFloat
    private var normalAlpha: CGFloat
    private var originalColor: UIColor? = nil
    private var usingAlpha = true
    
    init(view: UIView, highlightAlpha: CGFloat) {
        self.view = view
        if view.backgroundColor == UIColor.clear
            || view.backgroundColor == UIColor.white {
            usingAlpha = false
        }
        if usingAlpha {
            self.normalAlpha = view.alpha
            self.highlightAlpha = highlightAlpha
        } else {
            originalColor = view.backgroundColor
            self.normalAlpha = -1
            self.highlightAlpha = -1
        }
    }
    
    public func show(highlight: Bool) {
        if highlight {
            if usingAlpha {
                self.view?.alpha = self.highlightAlpha
            } else {
                self.view?.backgroundColor = UIColor("E0E0E0")
            }
        } else {
            if usingAlpha {
                self.view?.alpha = normalAlpha
            } else {
                self.view?.backgroundColor = originalColor
            }
        }
    }
}

open class OnClickListener: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    var action: ()-> Void
    
    private var highlights = [Highlightable]()
    private var downPoint: CGPoint? = nil
    
    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
        self.delegate = self
    }
    
    deinit {
        print("OnClickListener deinit")
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        showHighlight(isHighlight: true)
    
        if let first = touches.first {
            downPoint = first.location(in: self.view)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        showHighlight(isHighlight: false)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        showHighlight(isHighlight: false)
        
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let t = touches.first {
            if downPoint != nil {
                let curr = t.location(in: self.view)
                if abs(curr.y - downPoint!.y) > 2 {
                    showHighlight(isHighlight: false)
                    downPoint = nil
                }
            }
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func execute() {
        self.action()
    }
    
    public func addHighlightable(highlight: Highlightable) {
        highlights.append(highlight)
    }
    
    private func showHighlight(isHighlight: Bool) {
        for hl in highlights {
            hl.show(highlight: isHighlight)
        }
    }
}

extension UIView {
    func setOnClickedListener(_ action: @escaping () -> Void) {
        var hasSet = false
        if let gestures = self.gestureRecognizers {
            for gesture in gestures {
                if gesture is OnClickListener {
                    //self.removeGestureRecognizer(gesture)
                    (gesture as! OnClickListener).action = action
                    hasSet = true
                    break
                }
            }
        }
        
        if !hasSet {
            self.isUserInteractionEnabled = true
            let onClickedGes = OnClickListener(action)
            onClickedGes.addHighlightable(highlight: OpacityHighlight(view: self, highlightAlpha: 0.5))
            self.addGestureRecognizer(onClickedGes)
        }
    }
}

extension UIView {
    @IBInspectable var strockColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        
        set {
            if newValue != nil {
                self.layer.borderColor = newValue!.cgColor
            }
        }
    }
    
    @IBInspectable var strockWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            if newValue > 0 {
                self.layer.borderWidth = newValue
            }
        }
    }
    
    @IBInspectable var radius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            if newValue == -1 {
                self.layer.cornerRadius = self.bounds.width / 2
                self.clipsToBounds = true
            } else if newValue > 0 {
                self.layer.cornerRadius = newValue
                self.layer.masksToBounds = true
            }
        }
    }
}

extension UIView {
    func removeAllConstraints() {
        var parent = self.superview
        while let parentView = parent {
            for const in parentView.constraints {
                if let first = const.firstItem as? UIView, first == self {
                    parentView.removeConstraint(const)
                }
                
                if let second = const.secondItem as? UIView, second == self {
                    parentView.removeConstraint(const)
                }
            }
            parent = parentView.superview
        }
        
        self.removeConstraints(constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func addShadow(
        color: UIColor = .black,
        opacity: Float = 0.2,
        offset: CGSize = .init(width: 0, height: 4),
        radius: CGFloat = 6
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

extension CALayer {
    func addGradientBorder(corners: UIRectCorner, radius: CGFloat, colors: [UIColor],width: CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0,y:1.0)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }
}

extension UIImage {

    func with(_ insets: UIEdgeInsets) -> UIImage {
        let targetWidth = size.width + insets.left + insets.right
        let targetHeight = size.height + insets.top + insets.bottom
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let targetOrigin = CGPoint(x: insets.left, y: insets.top)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: targetOrigin, size: size))
        }.withRenderingMode(renderingMode)
    }
}

//MARK: - Constraints
extension UIView {
    public func fill(parent view: UIView, constant: UIEdgeInsets = .zero){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant.left).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant.top).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: constant.right).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant.bottom).isActive = true
        self.layoutIfNeeded()
    }
}

extension WKWebView {
    
    func didScrollEnd(completion: @escaping (_ isScrolledAtBottom: Bool, _ isScrollAtTop: Bool) -> Void) {
        self.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    let bodyScrollHeight = height as! CGFloat
                    var bodyoffsetheight: CGFloat = 0
                    var htmloffsetheight: CGFloat = 0
                    var htmlclientheight: CGFloat = 0
                    var htmlscrollheight: CGFloat = 0
                    var wininnerheight: CGFloat = 0
                    var winpageoffset: CGFloat = 0
                    var winheight: CGFloat = 0
                    
                    //body.offsetHeight
                    self.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (offsetHeight, error) in
                        bodyoffsetheight = offsetHeight as! CGFloat
                        
                        self.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { (offsetHeight, error) in
                            htmloffsetheight = offsetHeight as! CGFloat
                            
                            self.evaluateJavaScript("document.documentElement.clientHeight", completionHandler: { (clientHeight, error) in
                                htmlclientheight = clientHeight as! CGFloat
                                
                                self.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (scrollHeight, error) in
                                    htmlscrollheight = scrollHeight as! CGFloat
                                    
                                    self.evaluateJavaScript("window.innerHeight", completionHandler: { (winHeight, error) in
                                        if error != nil {
                                            wininnerheight = -1
                                        } else {
                                            wininnerheight = winHeight as! CGFloat
                                        }
                                        
                                        self.evaluateJavaScript("window.pageYOffset", completionHandler: { (winpageOffset, error) in
                                            winpageoffset = winpageOffset as! CGFloat
                                            
                                            let docHeight = max(bodyScrollHeight, bodyoffsetheight, htmlclientheight, htmlscrollheight,htmloffsetheight)
                                            
                                            winheight = wininnerheight >= 0 ? wininnerheight : htmloffsetheight
                                            let winBottom = winheight + winpageoffset
                                            if (winBottom >= docHeight) {
                                                completion(true,false)
                                            } else if winpageoffset == 0 {
                                                completion(false,true)
                                            }
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            }
        })
    }
}

