//
//  SegurançaTableViewController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 21/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

class SecurityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum ForceType: String {
        case All = "All"
        case Gnr = "Gnr"
        case Psp = "Psp"
    }
    
    var gnr = [Gnr]()
    var psp = [Psp]()
    
    var count = 0
    
    var selectedForceType: ForceType!
    
    @IBOutlet weak var securityTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func barButtonItem(sender: UISegmentedControl) {
        setSelectedForceType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedForceType()
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
        cell.textLabel?.text = getDisplayableInformation(indexPath.row)
        return cell
    }
    
    func getDisplayableInformation(index: Int) -> String {
        switch selectedForceType! {
        case .All:
            return "to be developed"
        case .Gnr:
            return gnr[index].name!
        case .Psp:
            return psp[index].desc!
        }
    }
    
    func setSelectedForceType() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedForceType = ForceType.All
        case 1:
            selectedForceType = ForceType.Gnr
            count = gnr.count
        case 2:
            selectedForceType = ForceType.Psp
            count = psp.count
        default:
            break
        }
        securityTableView.reloadData()
    }
    
}
