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
    
    func servicesFromArray(object: AnyObject, inContext context: NSManagedObjectContext) {
        
        let servicesArray = object as! [[String : AnyObject]]
        var xmlService = [String : AnyObject]()
        for values in servicesArray {
            
            if let description = values["Description"] as? String {
                xmlService["Description"] = description
            }
            
            if let title = values["Title"] as? String {
                xmlService["Title"] = title
            }
            
            if let highlight = values["Highlight"] as? String {
                xmlService["Highlight"] = highlight
            }
            
            if let position = values["Position"] as? String {
                xmlService["Position"] = position
            }
            
            if let serviceId = values["ServiceID"] as? String {
                xmlService["ServiceID"] = serviceId
            }
            
            if let urlString = values["Url"] as? String {
                if !urlString.isEmpty {
                    xmlService["Url"] = urlString
                }
            } else {
                xmlService["Url"] = ""
            }
            
            if let service = values["Service"] {
                
                let request = NSFetchRequest(entityName: "Service")
                let id = Int(xmlService["ServiceID"] as! String)!
                request.predicate = NSPredicate(format: "remoteId == %d", id)
                
                let matches = try! context.executeFetchRequest(request)
                
                if matches.count > 1 {
                    //handle error
                } else if matches.count == 1 {
                    setServiceManagedObject(matches.first as! Service, xmlService: xmlService)
                } else  {
                    let service = NSEntityDescription.insertNewObjectForEntityForName("Service", inManagedObjectContext: context) as! Service
                    setServiceManagedObject(service, xmlService: xmlService)
                    
                }
                
            }
            
        } //End for
        
    }
    
    func setServiceManagedObject(service: Service, xmlService: [String : AnyObject]) {
        service.remoteId = Int(xmlService["ServiceID"] as! String)!
        var boolValue = false
        if (xmlService["Highlight"] as! String) == "true" {
            boolValue = true
        }
        service.featured = boolValue
        service.position = Int(xmlService["Position"] as! String)!
        service.note = (xmlService["Description"] as! String)
        service.title = (xmlService["Title"] as! String)
        service.url = (xmlService["Url"] as! String)
        
    }
    
}