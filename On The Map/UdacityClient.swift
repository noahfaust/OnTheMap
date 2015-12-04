//
//  UdacityClient.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 4/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation

class UdacityClient: GenericClient {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication Info */
    var sessionId : String? = nil
    var userId : String? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
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
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
                if statusCode < 200 || statusCode > 299 {
                    if statusCode == 403 {
                        print("Login error: Invalid Email or Password")
                        let userInfo = [NSLocalizedDescriptionKey : "Invalid Email or Password"]
                        completionHandler(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
                    } else if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                    } else {
                        print("Your request returned an invalid response!")
                    }
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            /* 5. Parse the data - Part 1 */
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