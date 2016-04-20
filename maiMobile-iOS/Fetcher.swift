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
    
    func loadServicesToCoreData() {
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = CoreDataStack.sharedPersistentCoordinator()
        
        MaiAPI().getServices { (servicesArray) in
            
            privateManagedObjectContext.performBlock({
                ServiceBuilder().servicesFromArray(servicesArray, inContext: privateManagedObjectContext)
                do {
                    try privateManagedObjectContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            })
        }
        
    }
    
    
}