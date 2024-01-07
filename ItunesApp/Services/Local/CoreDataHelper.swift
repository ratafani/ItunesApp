//
//  Repository.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 06/01/24.
//

import CoreData
import UIKit
import Combine

protocol CoreDataHelperProtocol {
    func create<T:NSManagedObject>(type: T.Type, completion: @escaping ((T) -> Void))
    func fetch<T>(type: T.Type, predicate: NSPredicate?, completion: @escaping (([T]?) -> Void))
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping (([T]?) -> Void))
    func fetchCount<T>(type: T.Type, predicate: NSPredicate, completion: @escaping ((Int) -> Void))
    func update<T: NSManagedObject>(object: T, updateBlock: @escaping ((T) -> Void), completion: @escaping (() -> Void))
    func delete<T: NSManagedObject>(object: T, completion: @escaping ((Bool) -> Void))
}


class CoreDataHelper:CoreDataHelperProtocol{
    
    static let shared = CoreDataHelper()
    private init() {
        // Private initializer to enforce singleton pattern
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movies") // Replace with your data model name
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func getContext()->NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    func create<T:NSManagedObject>(type: T.Type, completion: @escaping ((T) -> Void)) {
        persistentContainer.performBackgroundTask { context in
            let newObject = T(entity: T.entity(), insertInto: context)
            completion(newObject)
            try? context.save()
        }
    }
    
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, completion: @escaping (([T]?) -> Void)) {
        persistentContainer.performBackgroundTask { managedObjectContext in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
            if let predicate = predicate {
                request.predicate = predicate
            }
            do {
                let result = try managedObjectContext.fetch(request)
                completion(result as? [T])
            } catch {
                completion(nil)
            }
        }
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping (([T]?) -> Void)) {
        persistentContainer.performBackgroundTask { managedObjectContext in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
            if let predicate = predicate {
                request.predicate = predicate
            }
            if let sortDescriptors = sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }
            
            do {
                let result = try managedObjectContext.fetch(request)
                completion(result as? [T])
            } catch {
                completion(nil)
            }
        }
    }
    
    func fetchCount<T>(type: T.Type, predicate: NSPredicate, completion: @escaping ((Int) -> Void)) {
        persistentContainer.performBackgroundTask { managedObjectContext in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
            do {
                let result = try managedObjectContext.fetch(request)
                completion(result.count)
            } catch {
                completion(0)
            }
        }
    }
    
    func update<T: NSManagedObject>(object: T, updateBlock: @escaping ((T) -> Void), completion: @escaping (() -> Void)){
        object.managedObjectContext?.perform {
            updateBlock(object)
            do {
                try object.managedObjectContext?.save()
                completion()
            } catch {
                print("Error updating managed object: \(error)")
                completion()
            }
        }
    }
    
    func delete<T: NSManagedObject>(object: T, completion: @escaping ((Bool) -> Void)) {
        guard let managedObjectContext = object.managedObjectContext else {
            print("Error: Managed object context is nil.")
            completion(false)
            return
        }
        managedObjectContext.perform {
            managedObjectContext.delete(object)
            do {
                try managedObjectContext.save()
                completion(true)
            } catch {
                print("Error deleting managed object: \(error)")
                completion(false)
            }
        }
    }
}
