//
//  SecurityBaseController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 21/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class SecurityBaseController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var gnrFetchResultController: NSFetchedResultsController!
    var pspFetchResultController: NSFetchedResultsController!
    
    var currentViewController = UIViewController()
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    @IBAction func barButtonItem(sender: UIBarButtonItem) {
        var nextViewController = UIViewController()
        barButtonItem.enabled = false
        if (currentViewController === childViewControllers.first!) {
            nextViewController = childViewControllers.last!
        } else if (currentViewController === childViewControllers.last!) {
            nextViewController = childViewControllers.first!
        }
        
        transitionFromViewController(currentViewController, toViewController: nextViewController, duration: NSTimeInterval.abs(1), options: .TransitionFlipFromRight, animations: nil, completion: { (finished) in
            if finished {
                self.currentViewController = nextViewController
                self.barButtonItem.enabled = true
            }
        })
        
    }
    
    override func viewDidLoad() {
        let mapViewController = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        let securityTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SecurityTableViewController") as! SecurityTableViewController
        
        let gnrFetchRequest = NSFetchRequest(entityName: "Gnr")
        gnrFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        gnrFetchResultController = NSFetchedResultsController(fetchRequest: gnrFetchRequest, managedObjectContext: Fetcher.sharedMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        try! gnrFetchResultController.performFetch()
        gnrFetchResultController.delegate = self
        
        securityTableViewController.gnr = gnrFetchResultController.fetchedObjects as! [Gnr]
        
        let pspFetchRequest = NSFetchRequest(entityName: "Psp")
        pspFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        pspFetchResultController = NSFetchedResultsController(fetchRequest: pspFetchRequest, managedObjectContext: Fetcher.sharedMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        try! pspFetchResultController.performFetch()
        pspFetchResultController.delegate = self
        
        securityTableViewController.psp = pspFetchResultController.fetchedObjects as! [Psp]
        
        currentViewController = mapViewController
        addChildViewController(mapViewController)
        addChildViewController(securityTableViewController)
        view.addSubview(mapViewController.view)
        mapViewController.didMoveToParentViewController(self)
        
    }
    
    
    
}
