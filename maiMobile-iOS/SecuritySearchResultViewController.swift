//
//  SecuritySearchResultViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 26/05/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData

class SecuritySearchResultViewController: UITableViewController, UISearchResultsUpdating {
    
    var forces = [Force]()
    var filteredForces = [Force]()
    
    override func viewDidLoad() {
        print("view.frame.origin: \(view.frame.origin)")
        tableView.rowHeight = CGFloat(80)
        tableView.registerNib(UINib(nibName: "GnrTableViewCell", bundle: nil), forCellReuseIdentifier: "gnrCell")
        tableView.registerNib(UINib(nibName: "PspTableViewCell", bundle: nil), forCellReuseIdentifier: "pspCell")
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredForces.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gnrCell") as! GnrTableViewCell
        let filteredForce = filteredForces[indexPath.row]
        switch filteredForce.forceType {
        case "gnr": return SecurityHelper.getCellForGnrTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: filteredForce)
        case "psp": return SecurityHelper.getCellForPspTypeAtIndexPathWithForceObject(tableView, indexPath: indexPath, force: filteredForce)
        default: break
        }
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let filter = forces.filter { $0.name.localizedCaseInsensitiveContainsString(searchController.searchBar.text!)
        }
        filteredForces = filter
        tableView.reloadData()
        
    }
    
    
    
}