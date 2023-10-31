//
//  DetailContactViewModel.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit
import AddPersonSDK

// MARK: -Protocols

protocol DetailPersonViewModelProtocol {
    func viewDidload()
    func viewWillAppear()
    func getPersons()
    func removePerson(at indexPath: IndexPath)
    func getPerson(at indexPath: IndexPath) -> Person?
    func updatePerson(nameText: String?, phoneText: String?, mailText: String?, indexPath: IndexPath, previousName: String, previousPhone: String, previousMail: String)
    func isEmailUnique(mail: String) -> Bool
    
    var items: [Person]? { get set }
    var cancelButtonText: String { get set }
    var saveButtonText: String { get set }
    var editAlertTitle: String { get set }
    var heightForRowAt: CGFloat { get set }
    var isUpdate: Bool { get set }
    var maxPhoneTextFieldLenght: Int { get set }
}

// MARK: -Class
final class DetailContactViewModel {
    
    // MARK: -Properties
    weak var delegate: DetailContactVCProtocol?
    
    var items: [Person]?
    var saveButtonText: String = "Save"
    var cancelButtonText: String = "Cancel"
    var editAlertTitle: String = "Edit Contact"
    var heightForRowAt: CGFloat = 120
    var isUpdate: Bool = false
    var maxPhoneTextFieldLenght: Int = 10
    
    // Alert properties
    let alertTitle: String = "Warning"
    let mailWarningMessage: String = "Please check your e-mail address"
    let phoneNumberCountWarning: String = "Please enter your 10-digit telephone number without 0 at the beginning"
    let nameWarningMessage: String = "Please fill in the name and surname field"
    let emailUniqueWarningMessage: String = "You do not register with a previously registered mail"
    let fillAllFieldWarning: String = "Please fill in all fields"
    let alertButtonTitle: String = "Ok"
    
}

// MARK: -Extensions
extension DetailContactViewModel: DetailPersonViewModelProtocol {
    
    func viewDidload() {
        delegate?.setUI()
    }
    
    func viewWillAppear() {
        getPersons()
        isUpdate = false
    }
    
    func getPersons() {
        delegate?.showActivityIndicator()
        items = PersonalDataManager.shared.fetchPersons()
        delegate?.hideActivityIndicator()
    }
    
    func removePerson(at indexPath: IndexPath) {
        guard let personToRemove = items?[indexPath.row] else {
            return
        }
        let context = PersonalDataManager.shared.persistentContainer.viewContext
        context.delete(personToRemove)
        delegate?.showActivityIndicator()
        do {
            try context.save()
            delegate?.hideActivityIndicator()
        }
        catch let err {
            delegate?.hideActivityIndicator()
            print(err.localizedDescription)
        }
        getPersons()
        delegate?.reloadTableView()
    }
    
    func getPerson(at indexPath: IndexPath) -> Person? {
        guard let updatedPerson = items?[indexPath.row] else {
            return nil
        }
        return updatedPerson
    }
    
    func updatePerson(nameText: String?, phoneText: String?, mailText: String?, indexPath: IndexPath, previousName: String, previousPhone: String, previousMail: String) {
        
        let updatedContact = getPerson(at: indexPath)
        
        guard let nameText = nameText,
              let phoneText = phoneText,
              let mailText = mailText else {
            
            delegate?.showAlert(title: alertTitle, message: fillAllFieldWarning, buttonText: alertButtonTitle, completionHandler: {})
            
            updatedContact?.name = previousName
            updatedContact?.phone = previousPhone
            updatedContact?.mail = previousMail
            return
        }
        
        guard mailText.isValidEmail else {
            delegate?.showAlert(title: editAlertTitle, message: mailWarningMessage, buttonText: alertButtonTitle, completionHandler: {})
            
            updatedContact?.name = previousName
            updatedContact?.phone = previousPhone
            updatedContact?.mail = previousMail
            return
        }
        
        guard phoneText.count >= 10 else {
            delegate?.showAlert(title: editAlertTitle, message: phoneNumberCountWarning, buttonText: alertButtonTitle, completionHandler: {})
            
            updatedContact?.name = previousName
            updatedContact?.phone = previousPhone
            updatedContact?.mail = previousMail
            return
        }
        
        guard nameText != "" else {
            delegate?.showAlert(title: editAlertTitle, message: nameWarningMessage, buttonText: alertButtonTitle, completionHandler: {})
            
            updatedContact?.name = previousName
            updatedContact?.phone = previousPhone
            updatedContact?.mail = previousMail
            return
        }
        
        let isMailUnique = isEmailUnique(mail: mailText)
        if isMailUnique || updatedContact?.mail == mailText {
            let context = PersonalDataManager.shared.persistentContainer.viewContext
            do {
                try context.save()
                delegate?.reloadTableView()
                isUpdate = true
            }
            catch let err {
                print(err.localizedDescription)
            }
        }else {
            delegate?.showAlert(title: editAlertTitle, message: emailUniqueWarningMessage, buttonText: alertButtonTitle, completionHandler: {})
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
}
