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
    
    var forcesFetchResultController: NSFetchedResultsController!
    var gnrFetchResultController: NSFetchedResultsController!
    var pspFetchResultController: NSFetchedResultsController!
    
    enum Entity: String {
        case Force = "Force"
        case Gnr = "Gnr"
        case Psp = "Psp"
    }
    
    enum CellIdentifier: String {
        case Gnr = "gnrCell"
        case Psp = "pspCell"
    }
    
    var count = 0
    
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
        
        let mainContext = fetcher.sharedMainContext
        
        // SortDescriptors
        let orderByNameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        let fetchBatchSizeLimit = 12
        forceFetchRequest.fetchBatchSize = fetchBatchSizeLimit
        gnrFetchRequest.fetchBatchSize = fetchBatchSizeLimit
        pspFetchRequest.fetchBatchSize = fetchBatchSizeLimit
        
        forceFetchRequest.sortDescriptors = [orderByNameDescriptor]
        gnrFetchRequest.sortDescriptors = [orderByNameDescriptor]
        pspFetchRequest.sortDescriptors = [orderByNameDescriptor]
        
        //Initializations
        forcesFetchResultController = NSFetchedResultsController(fetchRequest: forceFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        gnrFetchResultController = NSFetchedResultsController(fetchRequest: gnrFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        pspFetchResultController = NSFetchedResultsController(fetchRequest: pspFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //Delegates
        forcesFetchResultController.delegate = self
        gnrFetchResultController.delegate = self
        pspFetchResultController.delegate = self
        
        if let userLocation = locationManager.location {
            setDistanceToManagedObjects(userLocation)
        } else {
            try! forcesFetchResultController.performFetch()
            try! gnrFetchResultController.performFetch()
            try! pspFetchResultController.performFetch()
        } 
        
        setSelectedForceType()
    }// End viewDidLoad
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = nil
        switch selectedForceType {
        case .All:
            let force = forcesFetchResultController.objectAtIndexPath(indexPath) as! Force
            if force.forceType == "gnr" {
                return getCellForGnrTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: force)
            } else if force.forceType == "psp" {
                return getCellForPspTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: force)
            }
        case .Gnr:
            return getCellForGnrTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: gnrFetchResultController.objectAtIndexPath(indexPath) as! Gnr)
            
        case .Psp:
            return getCellForPspTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: pspFetchResultController.objectAtIndexPath(indexPath) as! Psp)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailTableviewController = storyboard?.instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
        let selectedForce = forcesFetchResultController.objectAtIndexPath(indexPath)
        switch selectedForceType {
        case .All:
            if selectedForce is Psp {
                detailTableviewController.force = forcesFetchResultController.objectAtIndexPath(indexPath) as! Force
                detailTableviewController.title = "Psp"
            } else if selectedForce is Gnr{
                detailTableviewController.force = forcesFetchResultController.objectAtIndexPath(indexPath) as! Force
                detailTableviewController.title = "Gnr"
            }
        case .Gnr:
            detailTableviewController.force = gnrFetchResultController.objectAtIndexPath(indexPath) as! Force
            detailTableviewController.title = "Gnr"
        case .Psp:
            detailTableviewController.force = pspFetchResultController.objectAtIndexPath(indexPath) as! Force
            detailTableviewController.title = "Psp"
        }
        navigationController?.pushViewController(detailTableviewController, animated: true)
        
    }
    
    func getCellForGnrTypeAtIndexPathWithForceObject(tableView: UITableView, indexPath: NSIndexPath, force: Force) -> GnrTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Gnr.rawValue) as! GnrTableViewCell
        let gnr = force as! Gnr
        cell.imageView?.image = nil
        cell.imageView?.image = UIImage(named: "gnr")
        cell.textLabel?.text = gnr.name
        cell.detailTextLabel?.text = String(gnr.distance)
        return cell
    }
    
    func getCellForPspTypeAtIndexPathWithForceObject(tableView: UITableView, indexPath: NSIndexPath, force: Force) -> PspTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Psp.rawValue) as! PspTableViewCell
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
            count = forcesFetchResultController.fetchedObjects?.count ?? 0
        case 1:
            selectedForceType = Force.ForceType.Gnr
            count = gnrFetchResultController.fetchedObjects?.count ?? 0
        case 2:
            selectedForceType = Force.ForceType.Psp
            count = pspFetchResultController.fetchedObjects?.count ?? 0
        default:
            break
        }
        
        securityTableView.reloadData()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        if let userLocation = locationManager.location {
            setDistanceToManagedObjects(userLocation)
        } else {
            let orderByNameDescriptor = NSSortDescriptor(key: "name", ascending: true)
            forceFetchRequest.sortDescriptors = [orderByNameDescriptor]
            gnrFetchRequest.sortDescriptors = [orderByNameDescriptor]
            pspFetchRequest.sortDescriptors = [orderByNameDescriptor]
            try! forcesFetchResultController.performFetch()
            try! gnrFetchResultController.performFetch()
            try! pspFetchResultController.performFetch()
            setSelectedForceType()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestUserLocation = locations.last!
        setDistanceToManagedObjects(latestUserLocation)
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
                forceObject.setValue(Double(distanceBetweenLocations), forKey: "distance")
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
        
        try! forcesFetchResultController.performFetch()
        try! gnrFetchResultController.performFetch()
        try! pspFetchResultController.performFetch()
        
        setSelectedForceType()
        securityTableView.reloadData()
        
    }
    
}
