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
    
    func pspFromArray(object: AnyObject, inContext context: NSManagedObjectContext) {
        let jsonArray = object as! [[String : AnyObject]]
        
        for data in jsonArray {
            let features = data["features"] as! [[String : AnyObject]]
            var attributes = [String : AnyObject]()
            var coordinates = [String : AnyObject]()
            let dictionary = NSMutableDictionary()
            for values in features {
                attributes = values["attributes"] as! [String : AnyObject]
                coordinates = values["geometry"] as! [String : AnyObject]
                
                dictionary.addEntriesFromDictionary(attributes)
                dictionary.addEntriesFromDictionary(coordinates)
                
                let request = NSFetchRequest(entityName: "Psp")
                let id = (attributes["OBJECTID"] as! Int)
                request.predicate = NSPredicate(format: "remoteId == %d", id)
                
                let matches = try! context.executeFetchRequest(request)
                
                if matches.count > 1 {
                    //handle error
                } else if matches.count == 1 {
                    setPspManagedObject(matches.first as! Psp, dictionary: dictionary)
                } else  {
                    let psp = NSEntityDescription.insertNewObjectForEntityForName("Psp", inManagedObjectContext: context) as! Psp
                    setPspManagedObject(psp, dictionary: dictionary)
                }
                
            }
        }
        
    }
    
    func setPspManagedObject(pspManagedObject: Psp, dictionary: NSMutableDictionary) {
        pspManagedObject.remoteId = dictionary["OBJECTID"] as! Int
        pspManagedObject.name = (dictionary["NOME"] as! String)
        pspManagedObject.desc = (dictionary["DESCRICAO"] as! String)
        
        if let phone = dictionary["TELEFONE"] as? Int,
            address = dictionary["MORADA"] as? String,
            township = dictionary["CONCELHO"] as? String,
            district = dictionary["DISTRITO"] as? String,
            postalCode = dictionary["CP7"] as? String,
            abbreviation = dictionary["ABREV"] as? String,
            comand = dictionary["COMANDO"] as? String {
            
            pspManagedObject.phone =  String(phone)
            pspManagedObject.postalCode = postalCode
            pspManagedObject.address = address
            pspManagedObject.township = township
            pspManagedObject.district = district
            pspManagedObject.comand = comand
            pspManagedObject.abbreviation = abbreviation
            
        }
        pspManagedObject.longitude = dictionary["x"] as! Double
        pspManagedObject.latitude = dictionary["y"] as! Double
        
        
    }
    
}