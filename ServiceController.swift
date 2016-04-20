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
    var result = [Service]()
    var services = [Service]()
    var featuredServices = [Service]()
    
    let cellNibIdentifier = "serviceCell"
    
    override func viewDidLoad() {
        tableView.rowHeight = CGFloat(103)
        tableView.registerNib(UINib(nibName: "ServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "serviceCell")
        let fetchRequest = NSFetchRequest(entityName: "Service")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Fetcher.sharedMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        try! fetchResultController.performFetch()
        fetchResultController.delegate = self
        result = fetchResultController.fetchedObjects as! [Service]
        
        for service in result {
            if service.highlight {
                featuredServices.append(service)
            } else {
                services.append(service)
            }
        }
        
    }
    
}
