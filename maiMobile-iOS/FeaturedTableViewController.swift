//
//  FeaturedTableViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class FeaturedTableViewController: ServiceController, NSFetchedResultsControllerDelegate {
    
    var featuredFetchResultController: NSFetchedResultsController!
    
    let fetcher = Fetcher()
    
    override func viewDidLoad() {
        tableView.rowHeight = 103
        tableView.registerNib(UINib(nibName: "ServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "serviceCell")
        
        let fetchRequest = NSFetchRequest(entityName: "Service")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "featured == %@", true)
        featuredFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetcher.sharedMainContext, sectionNameKeyPath: nil, cacheName: nil)
        featuredFetchResultController.delegate = self
        try! featuredFetchResultController.performFetch()
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuredFetchResultController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellNibIdentifier, forIndexPath: indexPath) as! ServicesTableViewCell
        let featuredService = featuredFetchResultController.objectAtIndexPath(indexPath) as! Service
        cell.titleLabel.text = featuredService.title
        cell.noteLabel.text = featuredService.note
        if let imageUrl = featuredService.imageUrl as? NSURL {
            cell.imageview.image = UIImage(data: NSData(contentsOfURL: imageUrl)!)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let featuredService = featuredFetchResultController.objectAtIndexPath(indexPath) as! Service
        var nextViewController: UIViewController!
        if featuredService.position == 1 {
            let towTruckViewcontroller = storyboard?.instantiateViewControllerWithIdentifier("TowTruckViewController") as! TowTruckViewController
            towTruckViewcontroller.title = "Programa SMS Reboques"
            nextViewController = towTruckViewcontroller
        } else {
            let webViewController = storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            webViewController.url = featuredService.url
            nextViewController = webViewController
        }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //Mark: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
}
