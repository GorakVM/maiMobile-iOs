//
//  SecurityHelper.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 19/06/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

class SecurityHelper {
    
    enum Entity: String {
        case Force = "Force"
        case Gnr = "Gnr"
        case Psp = "Psp"
    }
    
    enum CellIdentifier: String {
        case Gnr = "gnrCell"
        case Psp = "pspCell"
    }
    
    class func cellRowHeight() -> CGFloat {
        return CGFloat(80)
    }
    
    
    class func getCellForGnrTypeAtIndexPathWithForceObject(tableView: UITableView, indexPath: NSIndexPath, force: Force) -> GnrTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Gnr.rawValue) as! GnrTableViewCell
        let gnr = force as! Gnr
        cell.textLabel!.text = gnr.name
        cell.detailTextLabel?.text = String(gnr.distance)
        return cell
    }
    
    class func getCellForPspTypeAtIndexPathWithForceObject(tableView: UITableView, indexPath: NSIndexPath, force: Force) -> PspTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Psp.rawValue) as! PspTableViewCell
        let psp = force as! Psp
        cell.titleLabel.text = psp.name
        cell.subtitleLabel.text = psp.desc
        cell.rightDetailLabel.text = String(psp.distance)
        return cell
    }
    
}
