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
        self.barButtonItem.enabled = false
        self.barButtonItem.image = nil
        if (self.currentController === self.mapViewController) {
            nextView = self.securityTableViewController.view
            self.barButtonItem.image = UIImage(named: "mapBarButtonItem")
            self.currentController = self.securityTableViewController
        } else if (self.currentController === self.securityTableViewController) {
            nextView = self.mapViewController.view
            self.barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
            self.currentController = self.mapViewController
        }
        UIView.transitionWithView(containerView, duration: NSTimeInterval.abs(1), options: UIViewAnimationOptions.TransitionFlipFromRight, animations: {
            self.currentController.view.removeFromSuperview()
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
        //        mapViewController.didMoveToParentViewController(self)
        
    }
    
}
