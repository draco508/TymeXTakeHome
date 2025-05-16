//
//  AttributedStringMaker.swift
//   
//
//  Created by NGUYENNV on 10/03/2021.
//

import UIKit
class AttributedStringMaker {

    private enum MatchType {
        case first
        case last
        case all
    }

    private var font: UIFont?
    private var color: UIColor?
    private var backgroundColor: UIColor?
    private var paragraphStyle: NSParagraphStyle?
    private var underlineStyle: NSUnderlineStyle?
    private var link: String?
    private var strikethroughColor: UIColor?

    private var matchType: MatchType = .first

    private var subMakers: [AttributedStringMaker] = []

    var string: String
    
    /// For subMakers only
    var strings: [String]?

    init(string: String?) {
        self.string = string ?? ""
    }
    
    /// For subMakers only
    init(strings: [String]?) {
        self.string = ""
        self.strings = strings
    }

    @discardableResult
    func font(_ font: UIFont?) -> AttributedStringMaker {
        self.font = font
        return self
    }

    @discardableResult
    func color(_ color: UIColor?) -> AttributedStringMaker {
        self.color = color
        return self
    }

    @discardableResult
    func backgroundColor(_ color: UIColor?) -> AttributedStringMaker {
        self.backgroundColor = color
        return self
    }

    @discardableResult
    func paragraphStyle(_ style: NSParagraphStyle?) -> AttributedStringMaker {
        self.paragraphStyle = style
        return self
    }
    
    @discardableResult
    func underlineStyle(_ style: NSUnderlineStyle?) -> AttributedStringMaker {
        self.underlineStyle = style
        return self
    }

    @discardableResult
    func link(_ string: String?) -> AttributedStringMaker {
        self.link = string
        return self
    }

    @discardableResult
    func strikethroughColor(_ strikethroughColor: UIColor) -> AttributedStringMaker {
        self.strikethroughColor = strikethroughColor
        return self
    }

    @discardableResult
    func first(match substring: String?, maker: ((AttributedStringMaker) -> Void)) -> AttributedStringMaker {
        let sub = AttributedStringMaker(string: substring)
        sub.matchType = .first
        subMakers.append(sub)
        maker(sub)
        return self
    }

    @discardableResult
    func last(match substring: String?, maker: ((AttributedStringMaker) -> Void)) -> AttributedStringMaker {
        let sub = AttributedStringMaker(string: substring)
        sub.matchType = .last
        subMakers.append(sub)
        maker(sub)
        return self
    }

    @discardableResult
    func all(match substring: String?, maker: ((AttributedStringMaker) -> Void)) -> AttributedStringMaker {
        let sub = AttributedStringMaker(string: substring)
        sub.matchType = .all
        subMakers.append(sub)
        maker(sub)
        return self
    }
    
    @discardableResult
    func multiple(substrings: [String]?, maker: ((AttributedStringMaker) -> Void)) -> AttributedStringMaker {
        let sub = AttributedStringMaker(strings: substrings)
        sub.matchType = .all
        subMakers.append(sub)
        maker(sub)
        return self
    }
    
    func build() -> NSAttributedString {
        let attrs = makeAttributes()

        if subMakers.isEmpty {
            return NSAttributedString(string: string, attributes: attrs)
        }

        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        
        func make(maker: AttributedStringMaker, s: String) {
            var nsRange: NSRange?
            var nsRanges: [NSRange]?
            
            switch maker.matchType {
            case .first:
                nsRange = string.nsRange(of: s)
            case .last:
                nsRange = string.nsRanges(of: s).last
            case .all:
                nsRanges = string.nsRanges(of: s)
            }

            if let range = nsRange {
                attributedString.addAttributes(maker.makeAttributes(),
                                               range: range)
            } else if let ranges = nsRanges {
                for range in ranges {
                    attributedString.addAttributes(maker.makeAttributes(),
                                                   range: range)
                }
            }
        }
        
        for maker in subMakers {
            if let strings = maker.strings, strings.count > 0 {
                for s in strings {
                    make(maker: maker, s: s)
                }
            } else {
                make(maker: maker, s: maker.string)
            }
        }

        return attributedString
    }

    private func makeAttributes() -> [NSAttributedString.Key: Any] {
        var attrs: [NSAttributedString.Key: Any] = [:]
        
        if let color = color {
            attrs[.foregroundColor] = color
        }
        
        if let color = backgroundColor {
            attrs[.backgroundColor] = color
        }

        if let font = font {
            attrs[.font] = font
        }

        if let style = paragraphStyle {
            attrs[.paragraphStyle] = style
        }
        
        if let style = underlineStyle {
            attrs[.underlineStyle] = style.rawValue
        }

        if let link = link, let url = URL(string: link) {
            attrs[.link] = url
        }
        
        if let color = strikethroughColor {
            attrs[.strikethroughColor] = color
            attrs[.strikethroughStyle] = 1.0
        }

        return attrs
    }
}

extension String {
    
    var attributedMaker: AttributedStringMaker {
        return AttributedStringMaker(string: self)
    }
    
    var nsRange: NSRange {
        return NSRange(location: 0, length: count)
    }
    
    func nsRange(of substring: String) -> NSRange? {
        guard let range = range(of: substring) else {
            return nil
        }

        return NSRange(range, in: self)
    }
    
    func nsRanges(of substring: String) -> [NSRange] {
        return ranges(of: substring).map({ NSRange($0, in: self) })
    }
    
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
