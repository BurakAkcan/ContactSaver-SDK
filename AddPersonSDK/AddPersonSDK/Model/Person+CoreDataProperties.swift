//
//  Person+CoreDataProperties.swift
//  AddPersonSDK
//
//  Created by Burak AKCAN on 25.10.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var mail: String?

}
