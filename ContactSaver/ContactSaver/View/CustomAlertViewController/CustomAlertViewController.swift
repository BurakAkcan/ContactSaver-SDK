//
//  CustomAlertViewController.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit

final class CustomAlertViewController: UIAlertController {

    typealias CompletionHandler = () -> Void

    private var completionHandler: CompletionHandler?

    convenience init(title: String?, message: String?, buttonText: String?, completionHandler: CompletionHandler? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.completionHandler = completionHandler

        let action = UIAlertAction(title: buttonText, style: .default) { _ in
            self.completionHandler?()
        }
        addAction(action)
    }
    
    func addAction(title: String, style: UIAlertAction.Style, handler: (() -> Void)? = nil) {
            let action = UIAlertAction(title: title, style: style) { _ in
                handler?()
            }
            addAction(action)
        }
}
