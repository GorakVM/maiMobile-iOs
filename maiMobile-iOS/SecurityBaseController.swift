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
        barButtonItem.image = nil
        if (currentViewController === childViewControllers.first!) {
            nextViewController = childViewControllers.last!
            barButtonItem.image = UIImage(named: "mapBarButtonItem")
        } else if (currentViewController === childViewControllers.last!) {
            nextViewController = childViewControllers.first!
            barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
        }
        
        transitionFromViewController(currentViewController, toViewController: nextViewController, duration: NSTimeInterval.abs(1), options: .TransitionFlipFromRight, animations: nil, completion: { (finished) in
            if finished {
                self.currentViewController = nextViewController
                self.barButtonItem.enabled = true
            }
        })
        
    }
    
    override func viewDidLoad() {
        let titleString = NSAttributedString(string: "Segurança", attributes:
            [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 15)!])
        title = titleString.string
        let mapViewController = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        let securityTableViewController = storyboard!.instantiateViewControllerWithIdentifier("SecurityTableViewController") as! SecurityTableViewController
        barButtonItem.image = UIImage(named: "bulletListBarButtonItem")
        currentViewController = mapViewController
        addChildViewController(mapViewController)
        addChildViewController(securityTableViewController)
        view.addSubview(mapViewController.view)
        mapViewController.didMoveToParentViewController(self)
        
    }
    
}
