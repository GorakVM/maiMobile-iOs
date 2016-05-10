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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.distanceFilter = 500
        
        let isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
        
        if isLocationServicesEnabled {
            locationManager.startUpdatingLocation()
        }
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("userLocation: \(userLocation)")
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        return nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
}
