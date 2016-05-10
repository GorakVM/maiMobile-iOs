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
    
    var currentViewController = UIViewController()
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    @IBAction func barButtonItem(sender: UIBarButtonItem) {
        var nextViewController = UIViewController()
        barButtonItem.enabled = false
        if (currentViewController === childViewControllers.first!) {
            nextViewController = childViewControllers.last!
        } else if (currentViewController === childViewControllers.last!) {
            nextViewController = childViewControllers.first!
        }
        
        transitionFromViewController(currentViewController, toViewController: nextViewController, duration: NSTimeInterval.abs(1), options: .TransitionFlipFromRight, animations: nil, completion: { (finished) in
            if finished {
                self.currentViewController = nextViewController
                self.barButtonItem.enabled = true
            }
        })
        
    }
    
    override func viewDidLoad() {
        let mapViewController = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        let securityTableViewController = storyboard!.instantiateViewControllerWithIdentifier("SecurityTableViewController") as! SecurityTableViewController
        
        currentViewController = mapViewController
        addChildViewController(mapViewController)
        addChildViewController(securityTableViewController)
        view.addSubview(mapViewController.view)
        mapViewController.didMoveToParentViewController(self)
        
    }
    
}
