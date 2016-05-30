//
//  GnrBuilder.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 21/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData

class GnrBuilder {
    
    func gnrFromArray(object: [AnyObject], inContext context: NSManagedObjectContext) {
        
        for data in object {
            let request = NSFetchRequest(entityName: "Gnr")
            request.predicate = NSPredicate(format: "remoteId == %d", data["ObjectId"] as! Int)
            
            let matches = try! context.executeFetchRequest(request)
            
            if matches.count > 1 {
                //handle error
            } else if matches.count == 1 {
                setGNRManagedObject(matches.first as! Gnr, dictionary: data as! [String : AnyObject])
            } else  {
                let gnr = NSEntityDescription.insertNewObjectForEntityForName("Gnr", inManagedObjectContext: context) as! Gnr
                setGNRManagedObject(gnr, dictionary: data as! [String : AnyObject])
            }
        }
        
    }
    
    func setGNRManagedObject(gnrManagedObject: Gnr, dictionary: [String : AnyObject]) {
        gnrManagedObject.remoteId = dictionary["ObjectId"] as! Int
//        gnrManagedObject.email = dictionary["Email"] as! String
        gnrManagedObject.latitude = dictionary["Lat"] as! Double
        gnrManagedObject.longitude = dictionary["Long"] as! Double
        gnrManagedObject.address = dictionary["Morada"] as! String
        gnrManagedObject.name = (dictionary["Nome"] as! String)
        gnrManagedObject.phone = dictionary["Telefone"] as! String
        gnrManagedObject.forceType = Force.ForceType.Gnr.rawValue
        
    }
    
}