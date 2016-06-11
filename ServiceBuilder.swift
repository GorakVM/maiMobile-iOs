//
//  ServiceBuilder.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 17/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData


class ServiceBuilder {
    
    func servicesFromArray(object: [AnyObject], inContext context: NSManagedObjectContext) {
        
        for serviceData in object {
            
            let request = NSFetchRequest(entityName: "Service")
            request.predicate = NSPredicate(format: "remoteId == %d", serviceData["ServiceID"] as! Int)
            
            let matches = try! context.executeFetchRequest(request)
            
            if matches.count > 1 {
                //handle error
            } else if matches.count == 1 { // If that id Exists update the data
                setServiceManagedObject(matches.first as! Service, dictionary: serviceData as! [String : AnyObject])
            } else  {// If the id doesn't exist create a new object
                let service = NSEntityDescription.insertNewObjectForEntityForName("Service", inManagedObjectContext: context) as! Service
                setServiceManagedObject(service, dictionary: serviceData as! [String : AnyObject])
            }
            
        } //End for
        
    }
    
    func setServiceManagedObject(service: Service, dictionary: [String : AnyObject]) {
        service.remoteId = dictionary["ServiceID"] as! Int
        service.featured = dictionary["Highlight"] as! Bool
        service.position = dictionary["Position"] as! Int
        service.note = (dictionary["Description"] as! String)
        service.title = (dictionary["Title"] as! String)
        if let imageUrlString = dictionary["Image"] as? String, imageUrl = NSURL(string: imageUrlString) {
            !imageUrlString.isEmpty ? (service.imageUrl = imageUrl) : (service.imageUrl = nil)
        } else {
            service.imageUrl = nil
        }
        if let urlString = dictionary["Url"] as? String, url = NSURL(string: urlString) {
            !urlString.isEmpty ? (service.url = url) : (service.url = nil)
        } else {
            service.url = nil
        }
    }
    
}