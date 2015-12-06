//
//  ParseConvenienceExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension ParseClient {
    
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String : AnyObject] = [ParameterKeys.Limit: 100, ParameterKeys.Order: "-\(JSONResponseKeys.UpdatedAt)"]
        let method = Methods.StudentLocation
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, errorString: "The student locations couldn't be loaded")
                return
            }
            
            if let results = JSONResult![JSONResponseKeys.Results] as? [[String : AnyObject]] {
                
                self.ParseStudentLocations = ParseStudentInformation.studentinfoFromResults(results)
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "The student locations couldn't be loaded")
            }
        }
    }
}
