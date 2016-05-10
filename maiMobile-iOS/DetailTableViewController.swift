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
    
    var psp: Psp!
    let titles = ["Endereço", "Telefone", "Website", "E-mail"]
    
    let addressIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    let phoneIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    let websiteIndexPath = NSIndexPath(forRow: 2, inSection: 0)
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
        cell.titleLabel.text = titles[indexPath.row]
        cell.subtitleLabel.text = getContentToDisplay(indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == addressIndexPath {
            let coordinates = CLLocationCoordinate2D(latitude: psp.latitude, longitude: psp.longitude)
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = psp.name
            let regionTeste = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 10000, 10000)
            mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsMapCenterKey : NSValue(MKCoordinate: regionTeste.center),MKLaunchOptionsMapSpanKey : NSValue(MKCoordinateSpan: regionTeste.span)])
        }
    }
    
    func getContentToDisplay(indexPath: NSIndexPath) -> String {
        switch indexPath {
        case addressIndexPath:
            if let address = psp.address {
                return address
            } else {
                return ""
            }
        case phoneIndexPath:
            if let phone = psp.phone {
                return phone
            }
        case websiteIndexPath:
            return " no website link from the webservices for now"
        case emailIndexPath:
            return " no website link from the webservices for now"
        default:
            break
        }
        
        return ""
    }
    
}
