//
//  ServicesTableViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class ServicesTableViewController: ServiceController, NSFetchedResultsControllerDelegate {
    
    var serviceFetchResultController: NSFetchedResultsController!
    
    let fetcher = Fetcher()
    
    override func viewDidLoad() {
        
        tableView.rowHeight = 103
        tableView.registerNib(UINib(nibName: "ServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "serviceCell")
        
        let fetchRequest = NSFetchRequest(entityName: "Service")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "featured == %@", false)
        serviceFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetcher.sharedMainContext, sectionNameKeyPath: nil, cacheName: nil)
        serviceFetchResultController.delegate = self
        try! serviceFetchResultController.performFetch()
    }
    
    //MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceFetchResultController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellNibIdentifier, forIndexPath: indexPath) as! ServicesTableViewCell
        cell.leftImageView.image = nil
        let service = serviceFetchResultController.objectAtIndexPath(indexPath) as! Service
        cell.titleLabel.text = service.title
        cell.noteLabel.text = service.note
        if let imageUrl = service.imageUrl {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                cell.leftImageView.image = UIImage(data: NSData(contentsOfURL: imageUrl)!)
            }
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let service = serviceFetchResultController.objectAtIndexPath(indexPath) as! Service
        let webViewController = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        if let url = service.url {
            webViewController.url = url
        }
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    //MARK: - NSFetchResultController
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Update:
            tableView.reloadRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
