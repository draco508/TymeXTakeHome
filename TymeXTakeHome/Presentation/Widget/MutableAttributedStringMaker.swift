//
//  MutableAttributedStringMaker.swift
//  Finhay
//
//  Created by Pham Hai Quang on 10/11/2021.
//  Copyright © 2021 Finhay CoLtd. All rights reserved.
//

import UIKit

class MutableAttributedStringMaker {
    
    private var result: NSMutableAttributedString = NSMutableAttributedString()
    private var next: String? = nil
    
    init(_ string: String?) {
        if string != nil {
            result.append(NSAttributedString(string: string!))
        }
    }
    
    func append(str: String) -> MutableAttributedStringMaker {
        if next != nil {
            result.append(NSAttributedString(string: str))
        }
        next = str
        return self
    }
    
    func with(color: UIColor) -> MutableAttributedStringMaker {
        if next != nil {
            let nextAttr = NSMutableAttributedString(string: next!, attributes: [NSAttributedString.Key.foregroundColor : color])
            result.append(nextAttr)
            next = nil
        }
        return self
    }
    
    func with(font: UIFont) -> MutableAttributedStringMaker {
        if next != nil {
            let nextAttr = NSMutableAttributedString(string: next!, attributes: [NSAttributedString.Key.font : font])
            result.append(nextAttr)
            next = nil
        }
        return self
    }
    
    func build() -> NSMutableAttributedString {
        if next != nil {
            result.append(NSAttributedString(string: next!))
        }
        return result
    }
}
