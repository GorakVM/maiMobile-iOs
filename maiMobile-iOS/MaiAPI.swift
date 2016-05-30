//
//  MaiAPI.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 13/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation

class MaiAPI {
    
    func getServices(result: AnyObject -> Void) {
        ServicesAPIService().getDictionaryFromData { (objects) in
            result(objects)
        }
        
    }
    
    func getGnr(result: [AnyObject] -> Void) {
        GnrApiService().getDictionaryFromData { (objects) in
            result(objects)
            
        }
    }
    
    func getPsp(result: AnyObject -> Void) {
        PspApiService().getDictionaryFromData { (objects) in
            result(objects)
        }
    }
    
}