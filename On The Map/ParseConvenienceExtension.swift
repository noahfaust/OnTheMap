//
//  ParseConvenienceExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension ParseClient {
    
    func getStudentLocations(completionHandler: (error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String : AnyObject] = [ParameterKeys.Limit: 100, ParameterKeys.Order: "-\(JSONResponseKeys.UpdatedAt)"]
        let method = Methods.StudentLocation
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(error: error)
            } else {
                
                if let results = JSONResult[JSONResponseKeys.Results] as? [[String : AnyObject]] {
                    print("JSONResult: \(JSONResult)")
                    
                    self.ParseStudentLocations = ParseStudentInformation.studentinfoFromResults(results)
                    completionHandler(error: nil)
                } else {
                    completionHandler(error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
}
