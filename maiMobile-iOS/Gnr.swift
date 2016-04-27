//
//  GNR.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 21/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation
import CoreData

extension Gnr {
    
    @NSManaged var remoteId: NSNumber
    @NSManaged var name: String?
    @NSManaged var type: String
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    
}


class Gnr: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}
