//
//  ServicesAPIService.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 12/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation

class ServicesAPIService {
    
    private let baseURLString = ""
    
    func request(completion: (NSData) -> Void) {
        let url = NSURL(string: baseURLString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            guard let httpResponse = response as? NSHTTPURLResponse, xmlData = data else {
                return
            }
            if httpResponse.statusCode == 200 {
                completion(xmlData)
            } else {
                print("servicesAPIService statusCode: \(httpResponse.statusCode)")
                print("data: \(xmlData)")
            }
            
        }
        task.resume()
    }
    
}