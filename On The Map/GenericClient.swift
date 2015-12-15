//
//  GenericClient.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 4/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation

class GenericClient: NSObject {
    
    /* Shared session */
    var session: NSURLSession
    var appDelegate: AppDelegate!
    
    override init() {
        session = NSURLSession.sharedSession()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        super.init()
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    func parseJSON(data: NSData, completion: (result: AnyObject!, error: ClientError?) -> Void) {
        
        /* 5. Parse the data - Part 1 */
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            completion(result: nil, error: .JSONNotConverted)
        }
        
        completion(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String {
        return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
    }
    
}

// MARK: Client Error Types
extension GenericClient {
    
    enum ClientError: ErrorType {
        case ErrorReturned
        case InvalidResponse
        case InvalidCredentials
        case InvalidData
        case JSONNotConverted
        case JSONNotParsed
    }
}