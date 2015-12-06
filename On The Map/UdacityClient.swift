//
//  UdacityClient.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 4/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation

class UdacityClient: GenericClient {
    
    /* Authentication Info */
    var sessionId: String? = nil
    var userId: String? = nil
    
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject?, error: ClientError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters: No parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: .ErrorReturned)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
                if statusCode < 200 || statusCode > 299 {
                    if statusCode == 403 {
                        // Udacity returns a 403 error in case login and password are invalid
                        completionHandler(result: nil, error: .InvalidCredentials)
                        return
                    } else if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)")
                    } else {
                        print("Your request returned an invalid response")
                    }
                    completionHandler(result: nil, error: .InvalidResponse)
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request")
                completionHandler(result: nil, error: .InvalidData)
                return
            }
            
            // Udacity requires to remove the 5 first characters of the data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 5. Parse the data - Part 1: convert the JSON in a Foundation Object */
            self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForDELETEMethod(method: String, completionHandler: (result: AnyObject?, error: ClientError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters: No parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        if let sharedCookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in sharedCookies {
                if cookie.name == "XSRF-TOKEN" {
                    request.setValue(cookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
                }
            }
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
                if statusCode < 200 || statusCode > 299 {
                    if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)")
                    } else {
                        print("Your request returned an invalid response")
                    }
                    completionHandler(result: nil, error: .InvalidResponse)
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error: .InvalidData)
                return
            }
            
            // Udacity requires to remove the 5 first characters of the data
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 5. Parse the data - Part 1: convert the JSON in a Foundation Object */
            self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}