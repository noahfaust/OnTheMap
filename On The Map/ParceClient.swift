//
//  ParceClient.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation

class ParseClient: GenericClient {
    
    /* Student Locations */
    var studentLocations: [StudentInformation] = [StudentInformation]()
    var newCheckInSinceLastRefresh = false
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completion: (result: AnyObject?, error: ClientError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters: No parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.AppId, forHTTPHeaderField: httpHeaderFields.AppId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: httpHeaderFields.ApiKey)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                print("There was an error with your request: \(error)")
                completion(result: nil, error: .ErrorReturned)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)")
                } else {
                    print("Your request returned an invalid response")
                }
                if let data = data {
                    print("Data: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
                }
                completion(result: nil, error: .InvalidResponse)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request")
                completion(result: nil, error: .InvalidData)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.parseJSON(data, completion: completion)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethod(method: String, jsonBody: [String : AnyObject], completion: (result: AnyObject?, error: ClientError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters: No parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(Constants.AppId, forHTTPHeaderField: httpHeaderFields.AppId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: httpHeaderFields.ApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                print("There was an error with your request: \(error)")
                completion(result: nil, error: .ErrorReturned)
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
                    if let data = data {
                        print("Data: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
                    }
                    completion(result: nil, error: .InvalidResponse)
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request")
                completion(result: nil, error: .InvalidData)
                return
            }
            
            /* 5. Parse the data - Part 1: convert the JSON in a Foundation Object */
            self.parseJSON(data, completion: completion)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForPUTMethod(method: String, jsonBody: [String : AnyObject], completion: (result: AnyObject?, error: ClientError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters: No parameters */
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(Constants.AppId, forHTTPHeaderField: httpHeaderFields.AppId)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: httpHeaderFields.ApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                print("There was an error with your request: \(error)")
                completion(result: nil, error: .ErrorReturned)
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
                    if let data = data {
                        print("Data: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
                    }
                    completion(result: nil, error: .InvalidResponse)
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request")
                completion(result: nil, error: .InvalidData)
                return
            }
            
            /* 5. Parse the data - Part 1: convert the JSON in a Foundation Object */
            self.parseJSON(data, completion: completion)

        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}