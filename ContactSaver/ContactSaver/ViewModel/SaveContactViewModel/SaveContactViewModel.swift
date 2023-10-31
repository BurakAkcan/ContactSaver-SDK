//
//  SaveContactViewModel.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import Foundation
import AddPersonSDK

// MARK: -Protocols
protocol SaveContactViewModelProtocol {
    func viewDidload()
    func viewWillAppear()
    func viewDidLayoutSubviews()
    func saveContact()
    func navigate()
    func isEmailUnique(mail: String) -> Bool
    
    var items: [Person]? { get set }
    var nameText: String { get set }
    var phoneText: String { get set }
    var mailText: String { get set }
}

final class SaveContactViewModel {
    weak var delegate: SaveContactVCProtocol?
    
    var items: [Person]?
    var nameText: String = ""
    var phoneText: String = ""
    var mailText: String = ""
    
    // Alert properties
    let alertTitle: String = "Warning"
    let mailWarningMessage: String = "Please check your e-mail address"
    let phoneNumberCountWarning: String = "Please enter your 10-digit telephone number without 0 at the beginning"
    let nameWarningMessage: String = "Please fill in the name and surname field"
    let emailUniqueWarningMessage: String = "You do not register with a previously registered mail"
    let alertButtonTitle: String = "Ok"
}

// MARK: -Extensions
extension SaveContactViewModel: SaveContactViewModelProtocol {
    
    func viewDidload() {
        delegate?.setUI()
    }
    
    func viewWillAppear() {
        delegate?.clearTextFields()
    }
    
    func viewDidLayoutSubviews() {
        delegate?.applyRoundedBottom()
    }
    
    func saveContact() {
        guard mailText.isValidEmail else {
            delegate?.showAlert(title: alertTitle, message: mailWarningMessage, buttonText: alertButtonTitle, completionHandler: {})
            return
        }
        
        guard phoneText.count >= 10 else {
            delegate?.showAlert(title: alertTitle, message: phoneNumberCountWarning, buttonText: alertButtonTitle, completionHandler: {})
            return
        }
        
        guard nameText != "" else {
            delegate?.showAlert(title: alertTitle, message: nameWarningMessage, buttonText: alertButtonTitle, completionHandler: {})
            return
        }
        
        let isMailUnique = isEmailUnique(mail: mailText)
        if isMailUnique {
            delegate?.showActivityIndicator()
            PersonalDataManager.shared.savePerson(name: nameText, phone: phoneText, mail: mailText)
            delegate?.hideActivityIndicator()
        }else {
            delegate?.showAlert(title: alertTitle, message: emailUniqueWarningMessage, buttonText: alertButtonTitle, completionHandler: {})
        }
    }
    
    func isEmailUnique(mail: String) -> Bool {
        let fetchRequest = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mail == %@", mail)
        
        do {
            let context = PersonalDataManager.shared.persistentContainer.viewContext
            let existingPersons = try context.fetch(fetchRequest)
            return existingPersons.isEmpty
        } catch {
            print("Error: \(error)")
            return false
        }
    }
    
    func navigate() {
        let detailContacts = DetailContactVC(nibName: "DetailContactVC", bundle: nil)
        delegate?.pushToViewController(detailContacts, animated: true)
    }
}
