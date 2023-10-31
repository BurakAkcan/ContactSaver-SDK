//
//  CustomActivityIndicator.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit

final class CustomActivityIndicator: UIView {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator.color = .white
        activityIndicator.tintColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        addSubview(activityIndicator)
        containerView.backgroundColor = .darkGray
        containerView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.containerView.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.containerView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}
