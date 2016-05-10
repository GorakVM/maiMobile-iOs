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

class SecurityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var forcesFetchResultController: NSFetchedResultsController!
    var gnrFetchResultController: NSFetchedResultsController!
    var pspFetchResultController: NSFetchedResultsController!
    
    private var pspList = [Psp]()
    private var gnrList = [Gnr]()
    private var forces = [Force]()
    
    var count = 0
    
    var selectedForceType = Force.ForceType.All.rawValue
    let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    
    let fetcher = Fetcher()
    
    @IBOutlet weak var securityTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func barButtonItem(sender: UISegmentedControl) {
        setSelectedForceType()
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        let forceFetchRequest = NSFetchRequest(entityName: "Force")
        let gnrFetchRequest = NSFetchRequest(entityName: "Gnr")
        let pspFetchRequest = NSFetchRequest(entityName: "Psp")
        let orderByName = [NSSortDescriptor(key: "name", ascending: true)]
        forceFetchRequest.sortDescriptors = orderByName
        gnrFetchRequest.sortDescriptors = orderByName
        pspFetchRequest.sortDescriptors = orderByName
        
        let mainContext = fetcher.sharedMainContext
        forcesFetchResultController = NSFetchedResultsController(fetchRequest: forceFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        try! forcesFetchResultController.performFetch()
        
        gnrFetchResultController = NSFetchedResultsController(fetchRequest: gnrFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        try! gnrFetchResultController.performFetch()
        
        pspFetchResultController = NSFetchedResultsController(fetchRequest: pspFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        try! pspFetchResultController.performFetch()
        
        forces = forcesFetchResultController.fetchedObjects as! [Force]
        gnrList = gnrFetchResultController.fetchedObjects as! [Gnr]
        pspList = pspFetchResultController.fetchedObjects as! [Psp]
        
        if isLocationServicesEnabled {
            locationManager.startUpdatingLocation()
            
            for value in forces {
                let forceLocation = CLLocation(latitude: value.latitude, longitude: value.longitude)
                value.distance = distanceBetweenLocations(forceLocation)
            }
            
            for gnr in gnrList {
                let gnrLocation = CLLocation(latitude: gnr.latitude, longitude: gnr.longitude)
                gnr.distance = distanceBetweenLocations(gnrLocation)
            }
            
            for psp in pspList {
                let psplocation = CLLocation(latitude: psp.latitude, longitude: psp.longitude)
                psp.distance = distanceBetweenLocations(psplocation)
            }
            
            if isLocationServicesEnabled {
                forces.sortInPlace({ $0.0.distance < $0.1.distance })
                gnrList.sortInPlace({ $0.0.distance < $0.1.distance })
                pspList.sortInPlace({ $0.0.distance < $0.1.distance })
            }
        }
        
        setSelectedForceType()
    }// End viewDidLoad
    
    func distanceBetweenLocations(location: CLLocation) -> Double {
        let userLocation = locationManager.location!
        let distanceBetweenLocations = userLocation.distanceFromLocation(location)
        return Double(distanceBetweenLocations)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let (name, distance) = getDisplayableInformation(indexPath)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = distance
        return cell
    }
    
    private func getDisplayableInformation(indexPath: NSIndexPath) -> (String, String) {
        var distance = ""
        var force: Force!
        var roundedNumber: Double = 0
        
        switch selectedForceType {
        case Force.ForceType.All.rawValue:
            force = forces[indexPath.row]
        case Force.ForceType.Gnr.rawValue:
            force = gnrList[indexPath.row]
        case Force.ForceType.Psp.rawValue:
            force = pspList[indexPath.row]
        default:
            break
        }
        
        if isLocationServicesEnabled {
            if force.distance < 1000 {
                roundedNumber = Double(round(force.distance))
                distance = String(Int(round(roundedNumber))) + " m"
            } else if force.distance >= 1000 {
                roundedNumber = Double(round(force.distance)/1000)
                distance = String(Int(round(roundedNumber))) + " km"
            } else {
                distance = ""
            }
        }
        return (force.name, distance)
    }
    
    func setSelectedForceType() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedForceType = Force.ForceType.All.rawValue
            count = forcesFetchResultController.fetchedObjects?.count ?? 0
        case 1:
            selectedForceType = Force.ForceType.Gnr.rawValue
            count = gnrFetchResultController.fetchedObjects?.count ?? 0
        case 2:
            selectedForceType = Force.ForceType.Psp.rawValue
            count = pspFetchResultController.fetchedObjects?.count ?? 0
        default:
            break
        }
        
        securityTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailTableviewController = storyboard?.instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
        switch selectedForceType {
        case Force.ForceType.All.rawValue:
            if forces[indexPath.row] is Psp {
                detailTableviewController.psp = forces[indexPath.row] as! Psp
            }
            navigationController?.pushViewController(detailTableviewController, animated: true)
        case Force.ForceType.Gnr.rawValue:
            break
        case Force.ForceType.Psp.rawValue:
            detailTableviewController.psp = pspList[indexPath.row]
            navigationController?.pushViewController(detailTableviewController, animated: true)
        default:
            break
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        securityTableView.reloadData()
    }
    
}
