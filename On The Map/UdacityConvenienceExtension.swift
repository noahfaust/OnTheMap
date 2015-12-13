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
        
        taskForPOSTMethod(method, jsonBody: jsonBody) { result, error in
            
            self.parseUdacityNewSessionResult(result, error: error) { success, errorString in
                
                self.completeAuthentication(success, errorString: errorString, completionHandler: completionHandler)
            }
        }
    }
    
    func postNewSession(facebookToken: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters (none), method, and HTTP body */
        let method : String = Methods.Session
        let jsonBody : [String: AnyObject] = [
            JSONBodyKeys.FacebookLogin: [JSONBodyKeys.AccessToken : facebookToken] as [String: AnyObject]
        ]
        
        taskForPOSTMethod(method, jsonBody: jsonBody) { result, error in

            self.parseUdacityNewSessionResult(result, error: error) { success, errorString in
                
                self.completeAuthentication(success, errorString: errorString, completionHandler: completionHandler)
            }
            
        }
    }
    
    // Helper: Parse the foundation object got from the response JSON */
    private func parseUdacityNewSessionResult(result: AnyObject?, error: ClientError?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        guard error == nil else {
            if error == .InvalidCredentials {
                completionHandler(success: false, errorString: "Invalid Email or Password")
            } else {
                completionHandler(success: false, errorString: "Login Failed")
            }
            return
        }
        
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
            
        }
    }
    
    private func completeAuthentication(success: Bool, errorString: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if success {
            self.getUserInfo() { success, errorString -> Void in
                if success {
                    ParseClient.sharedInstance().getCurrentLocation(self.userId!) { success, errorString -> Void in
                        completionHandler (success: true, errorString: nil)
                    }
                } else {
                    completionHandler(success: false, errorString: errorString)
                }
            }
        } else {
            completionHandler(success: false, errorString: errorString)
        }
    }
    
    func deleteSession() {
        
        /* 1. Specify parameters (none), method, and HTTP body */
        let method : String = Methods.Session
        
        taskForDELETEMethod(method) { result, error in
            
            // Set SessionId and UserId to nil whatever the method suceeded or not
            UdacityClient.sharedInstance().sessionId = nil
            UdacityClient.sharedInstance().userId = nil
        }
    }
    
    func getUserInfo(completionHandler: (success: Bool, errorString: String?) -> Void) {
        /* 1. Specify parameters (none), method, and HTTP body */
        var mutableMethod = Methods.UserInfo
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: URLKeys.UserId, value: userId!)
        
        taskForGETMethod(mutableMethod) { result, error in
            
            guard error == nil else {
                completionHandler(success: false, errorString: "Login Failed")
                return
            }
            
            /* 5. Parse the data - Part 2 */
            if let result = result {
                
                guard let userDictionnary = result[JSONResponseKeys.User] as? [String: AnyObject] else {
                    print("Could not find key 'user' in  parsedResult: \(result)")
                    completionHandler(success: false, errorString: "Login Failed")
                    return
                }
                
                /* 6. Use the data! */
                let firstName = userDictionnary[JSONResponseKeys.FirstName] as? String
                let lastName = userDictionnary[JSONResponseKeys.LastName] as? String
                self.appDelegate.userInfo = StudentInformation(userId: self.userId!, firstName: firstName, lastName: lastName)
                
                completionHandler(success: true, errorString: nil)
            }
        }
        
    }
    
}
