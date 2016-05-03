//
//  PSP.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 22/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData


extension Psp {
    
    @NSManaged var address: String?
    @NSManaged var desc: String?
    @NSManaged var district: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var remoteId: NSNumber?
    @NSManaged var township: String?
    @NSManaged var comand: String?
    @NSManaged var postalCode: String?
    @NSManaged var abbreviation: String?
    
}


class Psp: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}
