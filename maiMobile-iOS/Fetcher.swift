//
//  Fetcher.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 13/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData

class Fetcher {
    
    let sharedMainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CoreDataStack.sharedPersistentCoordinator()
        return mainContext
    }()
    
    let sharedPrivateContext: NSManagedObjectContext = {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = CoreDataStack.sharedPersistentCoordinator()
        return privateContext
    }()
    
    init() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(contextDidSave(_:)),
            name: NSManagedObjectContextDidSaveNotification,
            object: nil
        )
    }
    
    @objc func contextDidSave(notification: NSNotification) {
        sharedMainContext.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    class func privateManagedObjectContext() -> NSManagedObjectContext {
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = CoreDataStack.sharedPersistentCoordinator()
        return privateManagedObjectContext
    }
    
    func loadServicesToCoreData() {
        let privateContext = Fetcher.privateManagedObjectContext()
        MaiAPI().getServices { (servicesArray) in
            ServiceBuilder().servicesFromArray(servicesArray, inContext: privateContext)
            privateContext.performBlock({
                self.saveContext(privateContext)
            })
        }
    }
    
    func loadGnrToCoreData() {
        let privateContext = Fetcher.privateManagedObjectContext()
        MaiAPI().getGnr { (gnrArray) in
            GnrBuilder().gnrFromArray(gnrArray, inContext: privateContext)
            privateContext.performBlock({
                self.saveContext(privateContext)
            })
        }
    }
    
    func loadPspToCoreData() {
        let privateContext = Fetcher.privateManagedObjectContext()
        MaiAPI().getPsp { (pspArray) in
            PspBuilder().pspFromArray(pspArray, inContext: privateContext)
            privateContext.performBlock({
                self.saveContext(privateContext)
            })
        }
    }
    
    func saveContext(managedContext: NSManagedObjectContext) {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
}