//
//  GenericClient.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 4/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation

class GenericClient {
    
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        /* 5. Parse the data - Part 1 */
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    
}