//
//  PersonalManager.swift
//  AddPersonSDK
//
//  Created by Burak AKCAN on 26.10.2023.
//

import Foundation
import CoreData

public protocol PersonalDataManagerProtocol {
    func saveContext()
    var persistentContainer: NSPersistentContainer { get set }
    func fetchPersons() -> [Person]?
}

public class PersonalDataManager: PersonalDataManagerProtocol {
    
    public static let shared = PersonalDataManager()
    
    // MARK: -Properties
    let identifier: String = "com.AddPersonSDK"
    let model: String = "PersonModel"
    
    lazy public var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                fatalError("Loading of store failed:\(err)")
            }
        }
        
        return container
    }()
    
    // MARK: -Initialize
    private init() {}
    
    // MARK: -Methods
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func fetchPersons() -> [Person]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let persons = try context.fetch(fetchRequest)
            return persons
        } catch {
            print("Hata: Veri çekme işlemi başarısız oldu. Hata: \(error)")
            return nil
        }
    }
    
    public func savePerson(name: String, phone: String, mail: String) {
        let context = persistentContainer.viewContext
        let newPerson = Person(context: context)
        newPerson.name = name
        newPerson.phone = phone
        newPerson.mail = mail
        
        do {
            try context.save()
        }
        catch let err {
            print(err.localizedDescription)
        }
    }
}
