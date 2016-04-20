//
//  FeaturedTableViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

class FeaturedTableViewController: ServiceController {

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return featuredServices.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellNibIdentifier, forIndexPath: indexPath) as! ServicesTableViewCell
        cell.titleLabel.text = featuredServices[indexPath.section].title
        cell.noteLabel.text = featuredServices[indexPath.section].note
        return cell
    }
    
   
    
}
