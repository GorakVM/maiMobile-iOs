//
//  Force.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 30/05/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData

extension Force {
    
    @NSManaged var address: String
    @NSManaged var distance: Double
    @NSManaged var forceType: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var remoteId: Int
    @NSManaged var email: String
    
}


class Force: NSManagedObject {
    
    enum ForceType: String {
        case All = "all"
        case Gnr = "gnr"
        case Psp = "psp"
    }
    
}
