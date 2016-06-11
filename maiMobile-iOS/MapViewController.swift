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
    
    var forcesFetchResultController: NSFetchedResultsController!
    let fetcher = Fetcher()
    
    var mapDidZoomToRegion: Bool = false
    
    class CustomPointAnnotation: MKPointAnnotation {
        var force: Force!
        var image: UIImage!
    }
    
    let locationManager = CLLocationManager()
    let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    var forceAnnotation = [CustomPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        let fetchAllForces = NSFetchRequest(entityName: "Force")
        fetchAllForces.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        forcesFetchResultController = NSFetchedResultsController(fetchRequest: fetchAllForces, managedObjectContext: fetcher.sharedMainContext, sectionNameKeyPath: nil, cacheName: nil)
        forcesFetchResultController.delegate = self
        try! forcesFetchResultController.performFetch()
        updateAnnotationsToMap()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if isLocationServicesEnabled {
            if let userLocation = mapView.userLocation.location {
                setZoomToRegion(userLocation)
            }
        }
        
        setAnnotationsForVisibleRectInMap()
    }// end viewdidload
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //This method is called whenever the user changes the status of the location service of his device
        
        //the purpose of this code is, in the case that the user didn't have the location services On at the time
        //that the view was created, the request to enable the location services allowing the app to access the user's location is going to be made here
        if isLocationServicesEnabled == false {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        setAnnotationsForVisibleRectInMap()
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        setZoomToRegion(userLocation.location!)
        setAnnotationsForVisibleRectInMap()
    }
    
    func setZoomToRegion(location: CLLocation) {
        if !mapDidZoomToRegion {
            let span = MKCoordinateSpanMake(0.25, 0.25)
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
            mapDidZoomToRegion = true
        }
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(forceAnnotation)
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
    
    func setAnnotationsForVisibleRectInMap() {
        let mapRect = mapView.visibleMapRect
        
        for annotation in forceAnnotation {
            let pointForAnnotation = MKMapPointForCoordinate(annotation.coordinate)
            let isAnnotationInVisibleRect = MKMapRectContainsPoint(mapRect, pointForAnnotation)
            if isAnnotationInVisibleRect {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.mapView.addAnnotation(annotation)
                })
            }
        }
    }
    
    func updateAnnotationsToMap() {
        for force in forcesFetchResultController.fetchedObjects as! [Force] {
            let annotation = CustomPointAnnotation()
            annotation.force = force
            annotation.coordinate = CLLocationCoordinate2D(latitude: force.latitude, longitude: force.longitude)
            annotation.title = force.name
            switch force.forceType {
            case Force.ForceType.Gnr.rawValue:
                annotation.image = UIImage(named: "gnr")
            case Force.ForceType.Psp.rawValue:
                let psp = (force as! Psp)
                annotation.subtitle = psp.desc
                annotation.image = UIImage(named: "psp")
            default:
                break
            }
            forceAnnotation.append(annotation)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        updateAnnotationsToMap()
        setAnnotationsForVisibleRectInMap()
    }
    
}
