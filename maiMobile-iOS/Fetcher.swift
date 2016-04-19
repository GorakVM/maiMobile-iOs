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
        mainContext.persistentStoreCoordinator = AppDelegate().persistentStoreCoordinator
        return mainContext
    }
    
    
   
    
}