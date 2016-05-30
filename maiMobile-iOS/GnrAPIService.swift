//
//  GnrAPIService.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 20/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation

class GnrApiService{
    
    private let baseUrlString = "https://api.myjson.com/bins/3nx9i"
    
    private func request() -> NSMutableURLRequest {
        let url = NSURL(string: baseUrlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        return request
    }
    
    func getDictionaryFromData(completion: ([AnyObject]) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request()) { (data, response, error) in
            guard let httpResponse = response as? NSHTTPURLResponse, jsonData = data else {
                print("ServicesAPIService response: \(response) error: \(error)")
                return
            }
            if httpResponse.statusCode == 200 {
                let parser = JSONParser(data: jsonData, handler: { (objectArray) in
                    completion(objectArray)
                })
            } else {
                print("GnrAPIService statusCode: \(httpResponse.statusCode)")
                print("data: \(jsonData)")
            }
        }
        task.resume()
    }//end func
    
}