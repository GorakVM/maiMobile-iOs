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
    
    func gnrFromArray(object: AnyObject, inContext context: NSManagedObjectContext) {
        
        let jsonArray = object as! [[String : AnyObject]]
        for data in jsonArray {
            let gnrDataList = data["features"] as! [[String : AnyObject]]
            for values in gnrDataList {
                var attributes = [String : AnyObject]()
                var coordinates = [String : AnyObject]()
                for value in values {
                    if value.0 == "attributes" {
                        attributes = value.1 as! [String : AnyObject]
                    } else if value.0 == "geometry" {
                        coordinates = value.1 as! [String : AnyObject]
                    }
                }
                let dictionary = NSMutableDictionary(dictionary: attributes)
                dictionary.addEntriesFromDictionary(coordinates)
                
                let request = NSFetchRequest(entityName: "Gnr")
                let id = (attributes["OBJECTID"] as! Int)
                request.predicate = NSPredicate(format: "remoteId == %d", id)
                
                let matches = try! context.executeFetchRequest(request)
                
                if matches.count > 1 {
                    //handle error
                } else if matches.count == 1 {
                    setGNRManagedObject(matches.first as! Gnr, dictionary: dictionary)
                } else  {
                    let gnr = NSEntityDescription.insertNewObjectForEntityForName("Gnr", inManagedObjectContext: context) as! Gnr
                    setGNRManagedObject(gnr, dictionary: dictionary)
                }
            }
            
        }
        
        
    }
    
    func setGNRManagedObject(gnrManagedObject: Gnr, dictionary: NSMutableDictionary) {
        gnrManagedObject.remoteId = dictionary["OBJECTID"] as! Int
        gnrManagedObject.name = (dictionary["Nome"] as! String)
        gnrManagedObject.type = dictionary["Hierarquia"] as! String
        gnrManagedObject.longitude = dictionary["x"] as! Double
        gnrManagedObject.latitude = dictionary["y"] as! Double
        gnrManagedObject.forceType = Force.ForceType.Gnr.rawValue
    }
    
}