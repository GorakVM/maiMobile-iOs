//
//  SegurançaTableViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 21/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SecurityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {

    var fetchedResultsController: NSFetchedResultsController!
    
    enum Entity: String {
        case Force = "Force"
        case Gnr = "Gnr"
        case Psp = "Psp"
    }
    
    enum CellIdentifier: String {
        case Gnr = "gnrCell"
        case Psp = "pspCell"
    }
    
//    var count = 0
    
    var selectedForceType = Force.ForceType.All
    let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    
    let fetcher = Fetcher()
    
    @IBOutlet weak var securityTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func barButtonItem(sender: UISegmentedControl) {
        setSelectedForceType()
    }
    
    let locationManager = CLLocationManager()
    
    let forceFetchRequest = NSFetchRequest(entityName: Entity.Force.rawValue)
    let gnrFetchRequest = NSFetchRequest(entityName: Entity.Gnr.rawValue)
    let pspFetchRequest = NSFetchRequest(entityName: Entity.Psp.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        securityTableView.rowHeight = CGFloat(80)
        securityTableView.registerNib(UINib(nibName: "GnrTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.Gnr.rawValue)
        securityTableView.registerNib(UINib(nibName: "PspTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.Psp.rawValue)
        
        segmentedControl.tintColor = UIColor.whiteColor()
        
        updateFetchRequest()
        
    }
    
    private func updateFetchRequest() {
        let fetchRequest = makeFetchRequest()
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: fetcher.sharedMainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        
        securityTableView.reloadData()
    }
    
    private func makeFetchRequest() -> NSFetchRequest {
        
        let entityName: String
        switch selectedForceType {
        case .All:
            entityName = "Force"
        case .Gnr:
            entityName = "Gnr"
        case .Psp:
            entityName = "Psp"
        }
        
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.fetchBatchSize = 12
        
        return request
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        let force = fetchedResultsController.objectAtIndexPath(indexPath) as! Force
        if force.forceType == "gnr" {
            cell = getCellForGnrTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: force)
        } else {
            cell = getCellForPspTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: force)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailTableviewController = storyboard?.instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
        
        let selectedForce = fetchedResultsController.objectAtIndexPath(indexPath) as! Force
        detailTableviewController.force = selectedForce
        
        if selectedForce is Psp {
            detailTableviewController.title = "Psp"
        } else if selectedForce is Gnr {
            detailTableviewController.title = "Gnr"
        }
        
        showViewController(detailTableviewController, sender: self)
        
    }
    
    func getCellForGnrTypeAtIndexPathWithForceObject(tableView: UITableView, indexPath: NSIndexPath, force: Force) -> GnrTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Gnr.rawValue, forIndexPath: indexPath) as! GnrTableViewCell
        let gnr = force as! Gnr
        cell.imageView?.image = nil
        cell.imageView?.image = UIImage(named: "gnr")
        cell.textLabel?.text = gnr.name
        cell.detailTextLabel?.text = String(gnr.distance)
        return cell
    }
    
    func getCellForPspTypeAtIndexPathWithForceObject(tableView: UITableView, indexPath: NSIndexPath, force: Force) -> PspTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Psp.rawValue, forIndexPath: indexPath) as! PspTableViewCell
        let psp = force as! Psp
        cell.imageView?.image = nil
        cell.imageView?.image = UIImage(named: "psp")
        cell.titleLabel.text = psp.name
        cell.subtitleLabel.text = psp.desc
        cell.rightDetailLabel.text = String(psp.distance)
        return cell
    }
    
    func setSelectedForceType() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedForceType = Force.ForceType.All
        case 1:
            selectedForceType = Force.ForceType.Gnr
        case 2:
            selectedForceType = Force.ForceType.Psp
        default:
            break
        }
        
        updateFetchRequest()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestUserLocation = locations.last!
        setDistanceToManagedObjects(latestUserLocation)
        manager.stopUpdatingLocation()
    }
    
    func setDistanceToManagedObjects(userLocation: CLLocation) {
        let privateContext = fetcher.sharedPrivateContext
        let request = NSFetchRequest(entityName: "Force")
        let arrayForceObjects = try! privateContext.executeFetchRequest(request)
        
        privateContext.performBlock {
            for forceObject in arrayForceObjects {
                let force = forceObject as! Force
                let forceObjectLocation = CLLocation(latitude: force.latitude, longitude: force.longitude)
                let distanceBetweenLocations = userLocation.distanceFromLocation(forceObjectLocation)
                force.distance = Double(distanceBetweenLocations)
            }
            do {
                try privateContext.save()
            } catch {
                print("error saving context: \(error)")
            }
            
        }
        
        let orderByDistanceDescriptor = NSSortDescriptor(key: "distance", ascending: true)
        forceFetchRequest.sortDescriptors = [orderByDistanceDescriptor]
        gnrFetchRequest.sortDescriptors = [orderByDistanceDescriptor]
        pspFetchRequest.sortDescriptors = [orderByDistanceDescriptor]
                
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        securityTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            securityTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            securityTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            securityTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            securityTableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        securityTableView.endUpdates()
    }
    
}
