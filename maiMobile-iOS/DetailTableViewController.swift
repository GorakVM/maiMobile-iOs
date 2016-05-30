//
//  DetailTableViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 02/05/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {
    
    var force: Force!
    let titles = ["Descrição", "Endereço", "Telephone", "E-mail"]
    let images = ["","directions","phone","mail"]
    
    let descriptionIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    let addressIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    let phoneIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    let emailIndexPath = NSIndexPath(forRow: 3, inSection: 0)
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        var subtitle = ""
        switch indexPath {
        case descriptionIndexPath:
            force.forceType == "psp" ? (subtitle = (force as! Psp).desc!) : (subtitle = "")
        case addressIndexPath:
            subtitle = force.address
        case phoneIndexPath:
            subtitle = force.phone
        case emailIndexPath:
            break
        default: break
        }
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.subtitleLabel.text = subtitle
        cell.detailImageView.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == addressIndexPath {
            let coordinates = CLLocationCoordinate2D(latitude: force.latitude, longitude: force.longitude)
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = force.name
            let regionTeste = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 10000, 10000)
            mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsMapCenterKey : NSValue(MKCoordinate: regionTeste.center),MKLaunchOptionsMapSpanKey : NSValue(MKCoordinateSpan: regionTeste.span)])
        }
    }
    
}
