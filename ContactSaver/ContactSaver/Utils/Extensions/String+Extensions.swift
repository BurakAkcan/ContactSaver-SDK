//
//  String+Extensions.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 25.10.2023.
//

import UIKit

extension String {
    func removingTrailingSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "\(Constants.emailRegex)").evaluate(with: self)
    }
}

extension NSMutableAttributedString {
    @discardableResult func style(text: String, font:UIFont, textColor:UIColor, spacing:Float, underline:Bool, lineHeight:CGFloat?, alignment:NSTextAlignment, lineBreakMode:NSLineBreakMode = .byTruncatingTail, strikethrough:Bool = false) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        if lineHeight != nil {
            paragraphStyle.lineSpacing = lineHeight! - font.pointSize
        }
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        
        
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        if underline == true {
            attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        attrs[.kern] = spacing
        attrs[.foregroundColor] = textColor
        attrs[.paragraphStyle] = paragraphStyle
        
        if strikethrough == true {
            attrs[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            attrs[.strikethroughColor] = textColor
        }
        
        
        let attributedText = NSMutableAttributedString(string:text, attributes: attrs)
        append(attributedText)
        return self
    }
}
