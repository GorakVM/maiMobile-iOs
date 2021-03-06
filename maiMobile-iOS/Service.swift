//
//  Service.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 18/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Service {
    
    @NSManaged var featured: Bool
    @NSManaged var imageUrl: NSURL?
    @NSManaged var note: String?
    @NSManaged var position: Int
    @NSManaged var remoteId: Int
    @NSManaged var title: String?
    @NSManaged var url: NSURL?
    
}

class Service: NSManagedObject {
    
}


