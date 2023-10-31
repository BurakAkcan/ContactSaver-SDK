//
//  DetailContactVC.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit
import AddPersonSDK

// MARK: -Protocols
protocol DetailContactVCProtocol: AnyObject, NavigatePushable {
    func setUI()
    func reloadTableView()
    func registerCell()
    func showActivityIndicator()
    func hideActivityIndicator()
    func setActivityIndicator()
    func showAlert(title: String, message: String, buttonText: String, completionHandler: @escaping ()->Void)
}

// MARK: -Class
final class DetailContactVC: UIViewController {

    // MARK: -Outputs
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -Properties
    private lazy var viewModel = DetailContactViewModel()
    private lazy var activityIndicator = CustomActivityIndicator()
    
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
}

// MARK: -Extensions
extension DetailContactVC: DetailContactVCProtocol {
    
    func setUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        registerCell()
        setActivityIndicator()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func registerCell() {
        tableView.register(DetailContactCell.register(), forCellReuseIdentifier: DetailContactCell.identifier)
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func setActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showAlert(title: String, message: String, buttonText: String, completionHandler: @escaping ()->Void) {
        
        let alert = CustomAlertViewController(title: title, message: message, buttonText: buttonText){
            completionHandler()
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension DetailContactVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailContactCell.identifier, for: indexPath) as? DetailContactCell else {
            return UITableViewCell()
        }
        if let person = viewModel.getPerson(at: indexPath) {
            cell.setUpCell(model: person)
        }
        return cell
    }
}

extension DetailContactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            
            guard let self = self else { return }
            self.viewModel.removePerson(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let alert = UIAlertController(title: viewModel.alertTitle, message: nil, preferredStyle: .alert)
        for _ in 1...3 {
            alert.addTextField()
        }
        
        let textFieldName = alert.textFields?[0]
        let textFieldPhone = alert.textFields?[1]
        let textFieldMail = alert.textFields?[2]
        
        textFieldPhone?.maxLength = viewModel.maxPhoneTextFieldLenght
        let updatedPerson = viewModel.getPerson(at: indexPath)
        
        textFieldName?.text = updatedPerson?.name
        textFieldPhone?.text = updatedPerson?.phone
        textFieldMail?.text = updatedPerson?.mail
        
        let previousName = updatedPerson?.name
        let previousPhone = updatedPerson?.phone
        let previousMail = updatedPerson?.mail

        let saveButton = UIAlertAction(title: viewModel.saveButtonText, style: .default) { [weak self] (action) in
            updatedPerson?.name = textFieldName?.text
            updatedPerson?.phone = textFieldPhone?.text
            updatedPerson?.mail = textFieldMail?.text
            self?.viewModel.updatePerson(nameText: textFieldName?.text, phoneText: textFieldPhone?.text, mailText: textFieldMail?.text, indexPath: indexPath, previousName: previousName!, previousPhone: previousPhone!, previousMail: previousMail!)
        }

        let cancelButton = UIAlertAction(title: viewModel.cancelButtonText, style: .cancel)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}
