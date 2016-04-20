//
//  CoreDataStack.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 20/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    let modelName = "maiMobile_iOS"
    
    private static let singletonCoreDataStack = CoreDataStack()
    
    lazy var documentDirectory: NSURL = {
        let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return url.first!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = NSBundle.mainBundle().URLForResource("maiMobile_iOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelUrl)!
    }()
    
    lazy var persistenCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.documentDirectory.URLByAppendingPathComponent("maiMobile_iOS.sqlite")
        print("CoreData database location: \(url)")
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            
        }
        return coordinator
    }()
    
    class func sharedPersistentCoordinator() -> NSPersistentStoreCoordinator {
        return singletonCoreDataStack.persistenCoordinator
    }
    
}