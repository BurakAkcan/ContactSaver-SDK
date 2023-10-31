//
//  UIButton+Extension.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 25.10.2023.
//

import UIKit

extension UIButton {
    func setAttributedTitle(text: String, font: UIFont, color: UIColor, size: CGFloat, textAlignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font.withSize(size),
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        setAttributedTitle(attributedText, for: .normal)
    }
}
