//
//  Helper.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 25.10.2023.
//

import UIKit

final class Helper {
    static func createAttributedString(_ localizedString: String, _ Font: UIFont,
                                       _ Size: CGFloat, _ Color: UIColor, _ Spacing: Float,
                                       _ Underline: Bool, _ LineHeight:CGFloat, _ TextAlinment: NSTextAlignment) -> NSMutableAttributedString {
        
        let attrStr = NSMutableAttributedString()
        
        return attrStr.style(text: NSLocalizedString("\(localizedString)", comment: ""),
                             font: Font,
                             textColor: Color,
                             spacing: Spacing,
                             underline: Underline,
                             lineHeight: LineHeight,
                             alignment: TextAlinment)
        
    }
}
