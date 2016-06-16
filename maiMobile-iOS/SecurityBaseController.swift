//
//  SecurityBaseController.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 21/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class SecurityBaseController: UIViewController {
    
    var mapViewController: UIViewController!
    var securityTableViewController: UIViewController!
    var currentController: UIViewController!
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func barButtonItem(sender: UIBarButtonItem) {
        var nextView: UIView!
        var containerSubViews = containerView.subviews
        barButtonItem.enabled = false
        barButtonItem.image = nil
        if (currentController === mapViewController) {
            nextView = securityTableViewController.view
            barButtonItem.image = UIImage(named: "mapBarButtonItem")
            currentController = securityTableViewController
        } else if (currentController === securityTableViewController) {
            nextView = mapViewController.view
            barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
            currentController = mapViewController
        }
        UIView.transitionWithView(containerView, duration: NSTimeInterval.abs(1), options: UIViewAnimationOptions.TransitionFlipFromRight, animations: {
            containerSubViews.removeAll()
            self.containerView.addSubview(nextView)
        }) { (finished) in
            self.barButtonItem.enabled = true
        }
        
    }
    
    override func viewDidLoad() {
        let titleString = NSAttributedString(string: "Segurança", attributes:
            [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 15)!])
        title = titleString.string
        mapViewController = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        securityTableViewController = storyboard!.instantiateViewControllerWithIdentifier("SecurityTableViewController") as! SecurityTableViewController
        barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
        
        let topInset = topLayoutGuide.length
        let bottomInset = bottomLayoutGuide.length
        currentController = mapViewController
        containerView.frame = CGRectMake(0, topInset, view.frame.width, view.frame.height - topInset - bottomInset)
        containerView.insertSubview(mapViewController.view, atIndex: 0)
        
    }
    
}
