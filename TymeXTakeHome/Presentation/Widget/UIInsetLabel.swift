//
//  UIInsetLabel.swift

//
//  Created by ph quang on 03/03/2022.
//

import Foundation
import UIKit

@IBDesignable
open class UIInsetLabel: UILabel {
    var edgeInsets = UIEdgeInsets.zero {
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var textInsetLeft: CGFloat {
        set { edgeInsets.left = newValue }
        get { return edgeInsets.left }
    }
        
    @IBInspectable var textInsetRight: CGFloat {
        set { edgeInsets.right = newValue }
        get { return edgeInsets.right }
    }
        
    @IBInspectable var textInsetTop: CGFloat {
        set { edgeInsets.top = newValue }
        get { return edgeInsets.top }
    }
        
    @IBInspectable var textInsetBottom: CGFloat {
        set { edgeInsets.bottom = newValue }
        get { return edgeInsets.bottom }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = CGRect(x: bounds.minX + edgeInsets.left,
                               y: bounds.minY + edgeInsets.top,
                               width: bounds.width - edgeInsets.left - edgeInsets.right,
                               height: bounds.height - edgeInsets.top - edgeInsets.bottom)
        let tectRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return CGRect(x: tectRect.minX - edgeInsets.left,
                      y: tectRect.minY - edgeInsets.top,
                      width: tectRect.width + edgeInsets.left + edgeInsets.right,
                      height: tectRect.height + edgeInsets.top + edgeInsets.bottom)
    }
    
    override open func drawText(in rect: CGRect) {
        let rectText = CGRect(x: rect.minX + edgeInsets.left, y: rect.minY + edgeInsets.top, width: rect.width - edgeInsets.left - edgeInsets.right, height: rect.height - edgeInsets.top - edgeInsets.bottom)
        super.drawText(in: rectText)
    }
}

@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSizeMake(CGRectGetWidth(self.frame), CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedString.Key.font: font],
                context: nil).size
            super.drawText(in: CGRectMake(0, 0, CGRectGetWidth(self.frame), ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
