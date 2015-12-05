//
//  UdacityConvenienceExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 4/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension UdacityClient {
    
    func postNewSession(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters (none), method, and HTTP body */
        let method : String = Methods.Session
        let jsonBody : [String: AnyObject] = [
            JSONBodyKeys.Udacity: [JSONBodyKeys.Username : username, JSONBodyKeys.Password : password] as [String: AnyObject]
        ]
        
        taskForPOSTMethod(method, jsonBody: jsonBody) { JSONResult, error in
            
            self.parseUdacitySessionResult(JSONResult, error: error, completionHandler: completionHandler)
        }
    }
    
    func postNewSessionWithFacebook(facebookToken: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters (none), method, and HTTP body */
        let method : String = Methods.Session
        let jsonBody : [String: AnyObject] = [
            JSONBodyKeys.FacebookLogin: [JSONBodyKeys.AccessToken : facebookToken] as [String: AnyObject]
        ]
        
        taskForPOSTMethod(method, jsonBody: jsonBody) { JSONResult, error in

            self.parseUdacitySessionResult(JSONResult, error: error, completionHandler: completionHandler)
            
        }
    }
    
    // Helper: Parse the foundation object got from the response JSON */
    func parseUdacitySessionResult(result: AnyObject?, error: NSError?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 5. Parse the data - Part 2 */
        if let result = result {
        
            guard let sessionInfo = result[JSONResponseKeys.Session] as? [String: AnyObject] else {
                print("Could not find key 'session_id' in  parsedResult: \(result)")
                completionHandler(success: false, errorString: "Login Failed")
                return
            }
            
            guard let sessionId = sessionInfo[JSONResponseKeys.SessionId] as? String else {
                print("Could not find key 'id' in sessionInfo: \(sessionInfo)")
                completionHandler(success: false, errorString: "Login Failed")
                return
            }
            
            /* 6. Use the data! */
            UdacityClient.sharedInstance().sessionId = sessionId
            
            guard let userInfo = result[JSONResponseKeys.Account] as? [String: AnyObject] else {
                print("Could not find key 'account' in  userInfo: \(result)")
                completionHandler(success: false, errorString: "Login Failed")
                return
            }
            
            guard let userId = userInfo[JSONResponseKeys.AccountKey] as? String else {
                print("Could not find key 'key' in userId: \(userInfo)")
                completionHandler(success: false, errorString: "Login Failed")
                return
            }
            
            /* 6. Use the data! */
            UdacityClient.sharedInstance().userId = userId
            
            completionHandler(success: true, errorString: nil)
            
        } else {
            
            if let error = error {
                if let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
                    completionHandler(success: false, errorString: errorString)
                    return
                }
            }
            print("Login failed with error: \(error)")
            completionHandler(success: false, errorString: "Login Failed")
        }
    }
    
}
