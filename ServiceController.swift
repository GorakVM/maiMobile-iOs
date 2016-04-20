//
//  ServiceController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class ServiceController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController!
    var services = [Service]()
    var featuredServices = [Service]()
    
    override func viewDidLoad() {
        let fetchRequest = NSFetchRequest(entityName: "Service")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: false)]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Fetcher.sharedMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        try! fetchResultController.performFetch()
        fetchResultController.delegate = self
        services = fetchResultController.fetchedObjects as! [Service]
        
        for service in services {
            if service.highlight {
                featuredServices.append(service)
            }
        }
        
    }
    
}