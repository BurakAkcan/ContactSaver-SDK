//
//  DetailContactCell.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit
import AddPersonSDK

final class DetailContactCell: UITableViewCell {
    
    // MARK: -Properties
   public static let identifier = String(describing: DetailContactCell.self)
    
    public static func register() -> UINib {
        UINib(nibName: "DetailContactCell", bundle: nil)
    }
    
    let nameTitle: String = "Name:"
    let phoneTitle: String = "Phone:"
    let mailTitle: String = "Mail:"
    
    // MARK: -Outputs
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var mailTitleLabel: UILabel!
    
    // MARK: -Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    // MARK: -Actions
    private func configCell() {
        backView.layer.cornerRadius = 8
        backView.backgroundColor = .systemYellow
        nameTitleLabel.text = nameTitle
        phoneTitleLabel.text = phoneTitle
        mailTitleLabel.text = mailTitle
        let contactLabels: [UILabel] = [nameLabel, phoneLabel, mailLabel]
        let titleLabels: [UILabel] = [nameTitleLabel, phoneTitleLabel, mailTitleLabel]
        titleLabels.forEach {
            $0.textColor = .darkGray.withAlphaComponent(0.9)
            $0.adjustsFontSizeToFitWidth = true
            $0.font = .italicSystemFont(ofSize: 14)
            $0.textAlignment = .center
        }
        
        contactLabels.forEach {
            $0.textAlignment = .left
            $0.adjustsFontSizeToFitWidth = true
            $0.font = .systemFont(ofSize: 16)
        }
        
        if let personImage = UIImage(named: "personal") {
            personImageView.image = personImage
        }
    }
    
    func setUpCell(model: Person) {
        nameLabel.text = model.name
        phoneLabel.text = model.phone
        mailLabel.text = model.mail
    }
}
