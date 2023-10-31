//
//  SaveContactsVC.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit
import AddPersonSDK

// MARK: -Protocols

protocol NavigatePushable {
    func pushToViewController(_ viewController: UIViewController, animated: Bool)
}

protocol PreviousViewNavigatable {
    func popToView(animated: Bool)
}

extension NavigatePushable where Self: UIViewController {
    func pushToViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

extension PreviousViewNavigatable where Self: UIViewController {
    func popToView(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}

protocol SaveContactVCProtocol: AnyObject, NavigatePushable {
    func setUI()
    func setHeaderView()
    func setTextFields()
    func setButtons()
    func setIcons()
    func clearTextFields()
    func applyRoundedBottom()
    func showAlert(title: String, message: String, buttonText: String, completionHandler: @escaping ()->Void)
    func showActivityIndicator()
    func hideActivityIndicator()
}

// MARK: -Class
final class SaveContactsVC: UIViewController {
    
    // MARK: -Outputs
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameIconImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var mailImageView: UIImageView!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var showPersonButton: UIButton!
    
    // MARK: -Properties
    let saveBttnTitle: String = "Save Contact"
    let showBttnTitle: String = "Show Contacts"
    let nameTxtFieldPlaceHolder: String = "Name and surname"
    let phoneTxtFieldPlaceHolder: String = "Phone"
    let mailTxtFieldPlaceHolder: String = "E-mail"
    let titleLabelText: String = "Save Contact"
    
    private lazy var viewModel = SaveContactViewModel()
    private lazy var activityIndicator = CustomActivityIndicator()
    
    // Context SDK
    let context = PersonalDataManager.shared.persistentContainer.viewContext
    var items: [Person]?
    
    // MARK: -View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    func applyRoundedBottom() {
        let maskPath = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        headerView.layer.mask = maskLayer
    }
    
    // MARK: -Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        viewModel.saveContact()
    }
    
    @IBAction func showButtonTapped(_ sender: UIButton) {
        viewModel.navigate()
    }
}

// MARK: -Extensions
extension SaveContactsVC: SaveContactVCProtocol {
    func setUI() {
        self.hideKeyboardWhenTappedAround()
        setHeaderView()
        setButtons()
        setTextFields()
        setIcons()
    }
    
    func setHeaderView() {
        headerView.backgroundColor = .systemYellow
        if let image = UIImage(named: "ic_logo_100") {
            logoImageView.image = image
        }
        titleLabel.numberOfLines = 0
        titleLabel.text = titleLabelText
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
    }
    
    func setButtons() {
        saveButton.backgroundColor = .systemYellow
        saveButton.setAttributedTitle(text: saveBttnTitle, font: .boldSystemFont(ofSize: 18), color: .black, size: 18, textAlignment: .center)
        saveButton.layer.cornerRadius = 12
        
        showPersonButton.backgroundColor = .systemYellow
        showPersonButton.setAttributedTitle(text: showBttnTitle, font: .boldSystemFont(ofSize: 18), color: .black, size: 18, textAlignment: .center)
        showPersonButton.layer.cornerRadius = 12
    }
    
    func setTextFields() {
        let textFields: [UITextField] = [nameTextField, phoneTextField, mailTextField]
        
        nameTextField.placeholder = nameTxtFieldPlaceHolder
        phoneTextField.placeholder = phoneTxtFieldPlaceHolder
        mailTextField.placeholder = mailTxtFieldPlaceHolder
        
        textFields.forEach {
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.cornerRadius = 4
            $0.clearButtonMode = .whileEditing
        }
    }
    
    func clearTextFields() {
        nameTextField.text = ""
        phoneTextField.text = ""
        mailTextField.text = ""
    }
    
    func setIcons() {
        let imageViews: [UIImageView] = [nameIconImageView, phoneImageView, mailImageView]
        imageViews.forEach {
            $0.contentMode = .scaleAspectFit
        }
        
        if let nameIcon = UIImage(named: "person"),
           let phoneIcon = UIImage(named: "phone"),
           let mailIcon = UIImage(named: "mail") {
            
            nameIconImageView.image = nameIcon
            phoneImageView.image = phoneIcon
            mailImageView.image = mailIcon
        }
    }
    
    func showAlert(title: String, message: String, buttonText: String, completionHandler: @escaping () -> Void) {
        let alert = CustomAlertViewController(title: title, message: message, buttonText: buttonText){
            completionHandler()
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

extension SaveContactsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.nameText = textField.text?.removingTrailingSpaces() ?? ""
        } else if textField == mailTextField {
            viewModel.mailText = textField.text?.removingTrailingSpaces() ?? ""
        } else if textField == phoneTextField {
            viewModel.phoneText = textField.text?.removingTrailingSpaces() ?? ""
        }
    }
}
