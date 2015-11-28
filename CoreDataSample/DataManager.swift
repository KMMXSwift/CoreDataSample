//
//  DataManager.swift
//  CoreDataSample
//
//  Created by Ricardo Michel Reyes Martínez on 11/28/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject
{
    var managedObjectContext: NSManagedObjectContext
    
    override init()
    {
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else
        {
            fatalError("Error loading model")
        }
        
        guard let model = NSManagedObjectModel(contentsOfURL: modelURL) else
        {
            fatalError("Error initializing model")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            
            do
            {
                let url = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false).URLByAppendingPathComponent("users.sqlite")
                
                do
                {
                    try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
                }
                
                catch
                {
                    print("Couldn't link persistent store coordinator")
                }
            }
            
            catch
            {
                print("Documents directory not found")
            }
        }
    }
    
    func fetch(entity: String, predicate: NSPredicate, completionHandler: (results: [AnyObject]) -> ())
    {
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            completionHandler(results: results)
        }
        
        catch
        {
            print("Couldn't complete fetch: \(entity)")
        }
    }
    
    func insertEntity(entity: String) -> NSManagedObject
    {
        return NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: managedObjectContext)
    }
    
    func save()
    {
        do
        {
             try managedObjectContext.save()
        }
        
        catch
        {
            print("Couldn't save context")
        }
    }
    
    func deleteObject(managedObject: NSManagedObject)
    {
        managedObjectContext.deleteObject(managedObject)
        save()
    }
}