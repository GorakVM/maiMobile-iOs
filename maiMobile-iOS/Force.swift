//
//  Force.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 10/05/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData


extension Force {
    
   
    
    @NSManaged var forceType: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String
    @NSManaged var remoteId: Int
    
}

class Force: NSManagedObject {
    // Insert code here to add functionality to your managed object subclass
   
    enum ForceType: String {
        case All = "all"
        case Gnr = "gnr"
        case Psp = "psp"
    }
    
    var distance: Double!
    
}
