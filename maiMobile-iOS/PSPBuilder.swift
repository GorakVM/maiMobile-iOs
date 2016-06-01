//
//  PSPBuilder.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 22/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData

class PspBuilder {
    
    func pspFromArray(object: [AnyObject], inContext context: NSManagedObjectContext) {
        
        for data in object {
            
            let request = NSFetchRequest(entityName: "Psp")
            request.predicate = NSPredicate(format: "remoteId == %d", data["ObjectId"] as! Int)
            
            let matches = try! context.executeFetchRequest(request)
            
            if matches.count > 1 {
                //handle error
            } else if matches.count == 1 {
                setPspManagedObject(matches.first as! Psp, dictionary: data as! [String : AnyObject])
            } else  {
                let psp = NSEntityDescription.insertNewObjectForEntityForName("Psp", inManagedObjectContext: context) as! Psp
                setPspManagedObject(psp, dictionary: data as! [String : AnyObject])
            }
            
        }
        
    }
    
    func setPspManagedObject(pspManagedObject: Psp, dictionary: [String : AnyObject]) {
        pspManagedObject.remoteId = dictionary["ObjectId"] as! Int
        pspManagedObject.email = (dictionary["Email"] as! String)
        pspManagedObject.desc = (dictionary["Descricao"] as! String)
        pspManagedObject.latitude = dictionary["Lat"] as! Double
        pspManagedObject.longitude = dictionary["Long"] as! Double
        pspManagedObject.address = dictionary["Morada"] as! String
        pspManagedObject.name = (dictionary["Nome"] as! String)
        pspManagedObject.phone = dictionary["Telefone"] as! String
        pspManagedObject.forceType = Force.ForceType.Psp.rawValue
    }
    
}