//
//  JSONParser.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 20/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

class JSONParser {
    
    init (data: NSData, handler: ([AnyObject]) -> Void) {
        var jsonData = [AnyObject]()
        do {
            jsonData = try [NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)]
        } catch {
            
        }
        
        handler(jsonData)
    }
    
}