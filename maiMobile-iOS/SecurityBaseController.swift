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
    var mapViewController: MapViewController!
    var securityTableViewController: SecurityTableViewController!
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    @IBAction func barButtonItem(sender: UIBarButtonItem) {
        var nextViewController: UIViewController! = nil
        view.willRemoveSubview(currentViewController.view)
        barButtonItem.enabled = false
        barButtonItem.image = nil
        if (currentViewController === mapViewController) {
            nextViewController = securityTableViewController
            barButtonItem.image = UIImage(named: "mapBarButtonItem")
            
        } else if (currentViewController === securityTableViewController) {
            nextViewController = mapViewController
            barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
        }
        
        addChildViewController(nextViewController)
        nextViewController.view.frame = view.bounds
        currentViewController.willMoveToParentViewController(nil)
        
        transitionFromViewController(currentViewController, toViewController: nextViewController, duration: NSTimeInterval.abs(1), options: .TransitionFlipFromRight, animations: nil, completion: { (finished) in
            self.currentViewController.view.removeFromSuperview()
            self.view.addSubview(nextViewController.view)
            if finished {
                self.currentViewController.removeFromParentViewController()
                nextViewController.didMoveToParentViewController(self)
                self.currentViewController = nextViewController
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
        currentViewController = mapViewController
        addChildViewController(currentViewController)
        currentViewController.view.frame = view.bounds
        view.addSubview(mapViewController.view)
        mapViewController.didMoveToParentViewController(self)
        
    }
    
}
