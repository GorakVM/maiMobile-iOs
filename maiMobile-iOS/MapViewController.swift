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
    var locationManager = CLLocationManager()
    
    class CustomPointAnnotation: MKPointAnnotation {
        var force: Force!
        var image: UIImage!
    }
    
    var forceAnnotation = [CustomPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchAllForces = NSFetchRequest(entityName: "Force")
        fetchAllForces.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        forcesFetchResultController = NSFetchedResultsController(fetchRequest: fetchAllForces, managedObjectContext: fetcher.sharedMainContext, sectionNameKeyPath: nil, cacheName: nil)
        forcesFetchResultController.delegate = self
        try! forcesFetchResultController.performFetch()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.distanceFilter = 500
        
        let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
        
        if isLocationServicesEnabled {
            locationManager.startUpdatingLocation()
        }
        
        for force in forcesFetchResultController.fetchedObjects as! [Force] {
            let annotation = CustomPointAnnotation()
            annotation.force = force
            annotation.coordinate = CLLocationCoordinate2D(latitude: force.latitude, longitude: force.longitude)
            annotation.title = force.name
            switch force.forceType {
            case Force.ForceType.Gnr.rawValue:
                annotation.image = UIImage.setImageToAnnotation((force as! Gnr).type)
            case Force.ForceType.Psp.rawValue:
                let psp = (force as! Psp)
                annotation.subtitle = psp.desc!
                annotation.image = UIImage(named: "psp")
            default:
                break
            }
            forceAnnotation.append(annotation)
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        setAnnotationsForVisibleRectInMap()
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("userLocation: \(userLocation)")
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
                guard annotation.force.forceType != Force.ForceType.Gnr.rawValue else {
                    let coordinates = CLLocationCoordinate2D(latitude: annotation.force.latitude, longitude: annotation.force.longitude)
                    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = annotation.title!
                    let regionTeste = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 10000, 10000)
                    mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsMapCenterKey : NSValue(MKCoordinate: regionTeste.center),MKLaunchOptionsMapSpanKey : NSValue(MKCoordinateSpan: regionTeste.span)])
                    return
                }
                let detailTableViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
                detailTableViewController.psp = annotation.force as! Psp
                navigationController?.pushViewController(detailTableViewController, animated: true)
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func setAnnotationsForVisibleRectInMap() {
        let mapRect = mapView.visibleMapRect
        
        for annotation in forceAnnotation {
            let pointForAnnotation = MKMapPointForCoordinate(annotation.coordinate)
            let isAnnotationInVisibleRect = MKMapRectContainsPoint(mapRect, pointForAnnotation)
            if isAnnotationInVisibleRect {
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        setAnnotationsForVisibleRectInMap()
    }
    
}
