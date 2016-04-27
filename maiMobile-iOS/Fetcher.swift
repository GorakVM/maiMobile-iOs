//
//  Fetcher.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 13/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class Fetcher {
    
    class func sharedMainContext() -> NSManagedObjectContext {
        let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CoreDataStack.sharedPersistentCoordinator()
        return mainContext
    }
    
    func privateManagedObjectContext() -> NSManagedObjectContext {
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = CoreDataStack.sharedPersistentCoordinator()
        return privateManagedObjectContext
    }
    
    func loadServicesToCoreData() {
        let privateContext = privateManagedObjectContext()
        MaiAPI().getServices { (servicesArray) in
            privateContext.performBlock({
                ServiceBuilder().servicesFromArray(servicesArray, inContext: privateContext)
                self.saveContext(privateContext)
            })
        }
        
    }
    
    func loadGnrToCoreData() {
        let privateContext = privateManagedObjectContext()
        MaiAPI().getGnr { (gnrArray) in
            GnrBuilder().gnrFromArray(gnrArray, inContext: privateContext)
            self.saveContext(privateContext)
        }
    }
    
    
    func saveContext(managedContext: NSManagedObjectContext) {
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
}