//
//  BaseCustomView.swift
//  TestApp
//
//  Created by NguyenNV on 26/02/2022.
//

import Foundation
import UIKit

open class BaseXibCustomView: UIView {
    
    @IBOutlet public var contentView: UIView!
    
    @IBInspectable public var paddingLeft: CGFloat {
        get {
            return leadingConstraint.constant
        }
        
        set {
            leadingConstraint.constant = newValue
        }
    }
    
    @IBInspectable public var paddingTop: CGFloat {
        get {
            return topConstraint.constant
        }
        
        set {
            topConstraint.constant = newValue
        }
    }
    
    @IBInspectable public var paddingRight: CGFloat {
        get {
            return trailingConstraint.constant
        }
        
        set {
            trailingConstraint.constant = newValue
        }
    }
    
    @IBInspectable public var paddingBottom: CGFloat {
        get {
            return bottomConstraint.constant
        }
        
        set {
            bottomConstraint.constant = newValue
        }
    }
    
    private var leadingConstraint: NSLayoutConstraint!
    private var topConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    public func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
            
        leadingConstraint = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
            
        topConstraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
            
        trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
            
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
    }
    
    public func findViewByTag(tag: Int)-> UIView? {
        return contentView.viewWithTag(tag)
    }
    
    public func extraView(view: UIView)-> ExtraViewParamsBuilder {
        return ExtraViewParamsBuilder(extraView: view, customView: self)
    }
}


open class ExtraViewParamsBuilder {
    
    private var extraView: UIView!
    private var customView: BaseXibCustomView!
    
    init(extraView: UIView, customView: BaseXibCustomView) {
        self.extraView = extraView
        self.customView = customView
        self.extraView.removeAllConstraints()
        self.extraView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func toRightOf(tagView: Int, margin: CGFloat)-> ExtraViewParamsBuilder {
        guard let viewWithTag = self.customView.findViewByTag(tag: tagView) else {
            return self
        }
        
        let rightConstraint = NSLayoutConstraint(item: extraView, attribute: .leading, relatedBy: .equal, toItem: viewWithTag, attribute: .trailing, multiplier: 1, constant: margin)
        rightConstraint.isActive = true
        return self
    }
    
    public func centerY(tagView: Int)-> ExtraViewParamsBuilder {
        guard let viewWithTag = self.customView.findViewByTag(tag: tagView) else {
            return self
        }
        
        let centerYConstraint = NSLayoutConstraint(item: extraView, attribute: .centerY, relatedBy: .equal, toItem: viewWithTag, attribute: .centerY, multiplier: 1, constant: 0)
        centerYConstraint.isActive = true
        return self
    }
}
