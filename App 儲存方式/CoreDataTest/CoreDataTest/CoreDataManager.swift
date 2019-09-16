//
//  CoreDataManager.swift
//  CoreDataTest
//
//  Created by Uran on 2018/1/24.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Foundation
import CoreData
typealias SaveComplete = (_ success:Bool) -> Void

class CoreDataManager<itemType>: NSObject,NSFetchedResultsControllerDelegate {
//    private var managedObjectContext : NSManagedObjectContext!
//    private var managedObjectModel : NSManagedObjectModel!
//    private var persistentStoreCoordinator : NSPersistentContainer!
    
    private var saveComplete : SaveComplete?
    
    private var targetModelName : String!
    private var targetDBFileName : String!
    private var targetDBPathURL : URL?
    private var targetSortKey : String!
    private var targetEntityName : String!
    
    init(modelName: String ,dbFileName:String ,dbPathURL:URL? ,sortKey:String ,entityName:String) {
        super.init()
        targetModelName = modelName;
        targetDBFileName = dbFileName;
        targetDBPathURL = dbPathURL;
        targetSortKey = sortKey;
        targetEntityName = entityName;
        
        if dbPathURL == nil {
            targetDBPathURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        }
    }
    //MARK: - Core Data stack
    private var managedObjectModel : NSManagedObjectModel? {
        get{
            guard let modelURL = Bundle.main.url(forResource: targetModelName, withExtension: "momd") else {
                NSLog("modelURL Error : Path is nil")
                return nil
            }
            
            guard let model = NSManagedObjectModel.init(contentsOf: modelURL) else{
                NSLog("managedObjectModel error : managedObjectModel is nil")
                return nil
            }
            
            
            return model
        }
    }
    private var persistentStoreCoordinator : NSPersistentStoreCoordinator? {
        get{
            guard let model = managedObjectModel else {
                return nil
            }
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            let storeUrl = targetDBPathURL?.appendingPathComponent(targetDBFileName)
            let failureReason = "There was an error creating or loading the application's saved data."
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
            } catch  {
                var nserror = error as NSError
                var dict : [String : Any] = [String : Any]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = nserror;
                nserror = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            return self.persistentStoreCoordinator
        }
    }
    private var managedObjectContext : NSManagedObjectContext? {
        get{
            guard let coordinator = self.persistentStoreCoordinator else{
                return nil
            }
            let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            
            return context
        }
    }
    
//MARK: - Core Data Saving support
    func saveContext(completion : @escaping SaveComplete) {
        guard let context = managedObjectContext else {
            completion(false)
            return
        }
        saveComplete = completion
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
                saveComplete = nil
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

//============================Core Data Kernel ===========================
    //MARK: - Fetched results controller
    private var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?{
        
        get{
            guard let context = managedObjectContext else {
                return nil
            }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entity = NSEntityDescription.entity(forEntityName: targetEntityName, in: context)
            fetchRequest.entity = entity
            // 每次可以批次處理的數量
            fetchRequest.fetchBatchSize = 20
            // 搜尋關鍵字，正排序：true,反排序：false
            let sortDescriptor = NSSortDescriptor(key: targetSortKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let aFetchedResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: targetEntityName)
            aFetchedResultsController.delegate = self
            
            do {
                try aFetchedResultsController.performFetch()
            } catch  {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            return aFetchedResultsController
        }
    }
    
    private func controllerDidChangeContent(controller : NSFetchedResultsController<NSFetchRequestResult>){
        if saveComplete != nil {
            saveComplete!(true)
            saveComplete = nil
        }
    }
//MARK: - Insert Delete GetItem Search GetCount
    func createItem()->NSManagedObject?{
        guard let context = managedObjectContext else {
            return nil
        }
        let newItem = NSEntityDescription.insertNewObject(forEntityName: targetEntityName, into: context)
        return newItem
    }
    func deleteItem(item : NSManagedObject) {
        managedObjectContext?.delete(item)
    }
    func itemWithIndex(index:Int)->NSManagedObject?{
        let indexPath = IndexPath(row: index, section: 0)
        if let object = fetchedResultsController?.object(at: indexPath) as? NSManagedObject {
            return object
        }else{
            return nil
        }
    }
    func itemCount()->Int{
        print("itemCount")
        guard let sectionInfo = fetchedResultsController?.sections?.first else{
            return 0
        }
        print("sectionInfo itemCount")
        return sectionInfo.numberOfObjects
    }
    func searchAt(field:NSString,keyWord:NSString)-> NSPersistentStoreResult?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: targetEntityName)
        let format = "\(field) contains[cd] %%@"
        let predicate = NSPredicate(format: format, keyWord)
        NSLog("predicate")
        request.predicate = predicate
        
        do {
            let results = try managedObjectContext?.execute(request)
            return results
        } catch  {
            NSLog("searcherror:\(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    
}
