//
//  MapViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 22/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchResultController: NSFetchedResultsController!
    let fetcher = Fetcher()
    
    var mapDidZoomToRegion: Bool = false
    
    class CustomPointAnnotation: MKPointAnnotation {
        enum Action {
            case load
            case remove
        }
        
        var force: Force!
        var image: UIImage!
    }
    
    let locationManager = CLLocationManager()
    let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    var forceAnnotations = [CustomPointAnnotation]()
    
    let fetchAllForces = NSFetchRequest(entityName: "Force")
    let fetchAllGnr = NSFetchRequest(entityName: "Gnr")
    let fetchAllPsp = NSFetchRequest(entityName: "Psp")
    
    let operationQueue = NSOperationQueue()
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        setFetchRequestFromSelectedSegment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Selected)
        fetchForces(fetchAllForces)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if let userLocation = mapView.userLocation.location {
            setZoomToRegion(userLocation)
        } else {
            //Set Region To Lisbon
            setZoomToRegion(CLLocation(latitude: 38.7222524, longitude: -9.1393366))
        }
        
        setAnnotationsForVisibleRectInMap()
    }// end viewdidload
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        operationQueue.cancelAllOperations()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //This method is called whenever the user changes the status of the location service of his device
        
        //the purpose of this code is, in the case that the user didn't have the location services On at the time
        //that the view was created, the request to enable the location services allowing the app to access the user's location is going to be made here
        if isLocationServicesEnabled == false {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        //        setAnnotationsForVisibleRectInMap()
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        setZoomToRegion(userLocation.location!)
        //        setAnnotationsForVisibleRectInMap()
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleAnnotations = mapView.annotations
        mapView.removeAnnotations(visibleAnnotations)
        setAnnotationsForVisibleRectInMap()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reusableIdentifier = "annotation"
        var reusableAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusableIdentifier)
        
        if let annotationView = reusableAnnotationView {
            annotationView.annotation = annotation
            
        } else {
            reusableAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        }
        
        let rightButton = UIButton(type: .DetailDisclosure)
        reusableAnnotationView?.rightCalloutAccessoryView = rightButton
        // this verification is because the user's location is an annotation too and we don't want to customize its annotation
        if !(annotation is MKUserLocation) {
            let customPointAnnotation = annotation as! CustomPointAnnotation
            reusableAnnotationView?.image = customPointAnnotation.image
            reusableAnnotationView?.canShowCallout = true
            return reusableAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? CustomPointAnnotation {
                let detailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
                detailTableViewController.force = annotation.force
                navigationController?.pushViewController(detailTableViewController, animated: true)
            }
        }
        
    }
    
    // MARK: - Custom Methods
    
    func setZoomToRegion(location: CLLocation) {
        if !mapDidZoomToRegion {
            let span = MKCoordinateSpanMake(0.10, 0.10)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            mapDidZoomToRegion = true
        }
        
    }
    
    private func setFetchRequestFromSelectedSegment () {
        operationQueue.cancelAllOperations()
        let visibleAnnotations = mapView.annotations
        mapView.removeAnnotations(visibleAnnotations)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchForces(fetchAllForces)
        case 1:
            fetchForces(fetchAllGnr)
        case 2:
            fetchForces(fetchAllPsp)
        default: break
        }
    }
    
    private func fetchForces(fetchRequest: NSFetchRequest) {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetcher.sharedMainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        try! fetchResultController.performFetch()
        setAnnotationsForVisibleRectInMap()
    }
    
    private func setAnnotationsForVisibleRectInMap() {
        print("fetchResultController fetchedObjects count: \(fetchResultController.fetchedObjects?.count)")
        let operation = NSBlockOperation()
        weak var weakOperation = operation
        operation.addExecutionBlock {
            for force in self.fetchResultController.fetchedObjects as! [Force] {
                if weakOperation!.cancelled {
                    print("operation Canceled")
                    break}
                let annotation = self.setCustomAnnotation(force)
                if self.isAnnotationVisibleInMapRect(annotation) {
                    self.manageAnnotationToMap(annotation, action: .load)
                } else {
                    self.manageAnnotationToMap(annotation, action: .remove)
                    
                }
                self.forceAnnotations.append(annotation)
                
            }
            
        }
        
        operationQueue.addOperation(operation)
        
    }
    
    private func setCustomAnnotation(force: Force) -> CustomPointAnnotation {
        let customAnnotation = CustomPointAnnotation()
        customAnnotation.force = force
        customAnnotation.coordinate = CLLocationCoordinate2D(latitude: force.latitude, longitude: force.longitude)
        customAnnotation.title = force.name
        
        switch force.forceType {
        case Force.ForceType.Gnr.rawValue:
            customAnnotation.image = UIImage(named: "gnr")
        case Force.ForceType.Psp.rawValue:
            let psp = (force as! Psp)
            customAnnotation.subtitle = psp.desc
            customAnnotation.image = UIImage(named: "psp")
        default:
            break
        }
        return customAnnotation
    }
    
    private func isAnnotationVisibleInMapRect(annotation: CustomPointAnnotation) -> Bool {
        let mapRect = mapView.visibleMapRect
        let pointForAnnotation = MKMapPointForCoordinate(annotation.coordinate)
        return MKMapRectContainsPoint(mapRect, pointForAnnotation)
    }
    
    private func manageAnnotationToMap(annotation: CustomPointAnnotation, action: CustomPointAnnotation.Action) {

        
        
        if !mapView.annotations.contains({ (annotationToCompare) -> Bool in
            return annotationToCompare === annotation
        }) {
            switch action {
            case .load:
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.mapView.addAnnotation(annotation)
                })
            case .remove:
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.mapView.removeAnnotation(annotation)
                })
                
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        setAnnotationsForVisibleRectInMap()
    }
    
}
