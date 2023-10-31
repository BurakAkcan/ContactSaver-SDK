//
//  Constants.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import Foundation

struct Constants {
    static let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    
    // Detail properties
    static let saveButtonText: String = "Save"
    static let cancelButtonText: String = "Cancel"
    static let editAlertTitle: String = "Edit Contact"
    static let alertTitle: String = "Warning"
    static let mailWarningMessage: String = "Please check your e-mail address"
    static let phoneNumberCountWarning: String = "Please enter your 10-digit telephone number without 0 at the beginning"
    static let nameWarningMessage: String = "Please fill in the name and surname field"
    static let emailUniqueWarningMessage: String = "You do not register with a previously registered mail"
    static let fillAllFieldWarning: String = "Please fill in all fields"
    static let alertButtonTitle: String = "Ok"

}
