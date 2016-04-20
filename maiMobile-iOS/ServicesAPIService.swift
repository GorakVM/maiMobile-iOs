//
//  ServicesAPIService.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 12/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation

class ServicesAPIService {
    
    private let baseURLString = "https://freedatagenerator.s3.amazonaws.com/bPYySe1W2rbA.xml"
    
    // for protection in case that the parser gets called multiple times
    private var parsers = [XMLParser]()
    
    private func request() -> NSMutableURLRequest {
        let url = NSURL(string: baseURLString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        return request
    }
    
    func getDictionaryFromData(completion: (AnyObject) -> Void)  {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request()) { (data, response, error) in
            guard let httpResponse = response as? NSHTTPURLResponse, xmlData = data else {
                print("ServicesAPIService response: \(response) error: \(error)")
                return
            }
            
            if httpResponse.statusCode == 200 {
                let parser = XMLParser(data: xmlData, handler: { (objectArray) in
                    completion(objectArray)
                })
                self.parsers.append(parser)
                
            } else {
                print("servicesAPIService statusCode: \(httpResponse.statusCode)")
                print("data: \(xmlData)")
            }
            
        }
        task.resume()
    }
    
}