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
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    @IBAction func barButtonItem(sender: UIBarButtonItem) {
        var nextViewController: UIViewController! = nil
        let childViewcontroller = childViewControllers.first!
        barButtonItem.enabled = false
        barButtonItem.image = nil
        
        if (childViewcontroller === mapViewController) {
            nextViewController = securityTableViewController
            barButtonItem.image = UIImage(named: "mapBarButtonItem")
            
        } else if (childViewcontroller === securityTableViewController) {
            nextViewController = mapViewController
            barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
        }
        
        childViewcontroller.willMoveToParentViewController(nil)
        addChildViewController(nextViewController)
        
        print("childViewControllers.first!.parentViewController: \(childViewControllers.first!.parentViewController!)")
        print("nextViewController.parentViewController: \(nextViewController.parentViewController!)")
        
        transitionFromViewController(childViewcontroller, toViewController: nextViewController, duration: NSTimeInterval.abs(1), options: .TransitionFlipFromRight, animations: {}, completion: { (finished) in
            childViewcontroller.removeFromParentViewController()
            nextViewController.didMoveToParentViewController(self)
            if finished {
                nextViewController = nil
                self.barButtonItem.enabled = true
            }
        })
        
    }
    
    override func viewDidLoad() {
        let titleString = NSAttributedString(string: "Segurança", attributes:
            [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 15)!])
        title = titleString.string
        mapViewController = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        securityTableViewController = storyboard!.instantiateViewControllerWithIdentifier("SecurityTableViewController") as! SecurityTableViewController
        barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
        addChildViewController(mapViewController)
        view.insertSubview(mapViewController.view, atIndex: 0)
        mapViewController.didMoveToParentViewController(self)
        
    }
    
}
