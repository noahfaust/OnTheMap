//
//  ParseConvenienceExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension ParseClient {
    
    func getStudentLocations(completion: (success: Bool, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters: [String : AnyObject] = [ParameterKeys.Limit: 100, ParameterKeys.Order: "-\(JSONKeys.UpdatedAt)"]
        let method = Methods.StudentLocation
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: parameters) { result, error in
            
            guard error == nil else {
                completion(success: false, errorString: "The student locations couldn't be loaded")
                return
            }
            
            guard let result = result else {
                completion(success: false, errorString: "The student locations couldn't be loaded")
                return
            }
            
            guard let results = result[JSONKeys.Results] as? [[String : AnyObject]] else {
                print("Could not find key 'results' in  parsedResult: \(result)")
                completion(success: false, errorString: "The student locations couldn't be loaded")
                return
            }
            
            self.appData.studentLocations = StudentInformation.studentinfoFromResults(results)
            self.appData.newCheckInSinceLastRefresh = false
            completion(success: true, errorString: nil)
        }
    }
    
    func getCurrentLocation(userId: String, completion: (success: Bool, errorString: String?) -> Void) {
        /* 1. Specify parameters, method, and HTTP body */
        
        let whereParameter: [String : String] = [JSONKeys.UniqueKey: userId]
        var whereParameterJSON: NSString = ""
        do {
            whereParameterJSON = try! NSString(data: NSJSONSerialization.dataWithJSONObject(whereParameter, options: .PrettyPrinted), encoding: NSUTF8StringEncoding)!
        }
        
        let parameters: [String : AnyObject] = [ParameterKeys.Where: whereParameterJSON]
        let method : String = Methods.StudentLocation
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: parameters) { result, error in
            
            guard error == nil else {
                completion(success: false, errorString: "Current location not retrieved")
                return
            }
            
            guard let result = result else {
                completion(success: false, errorString: "Current location not retrieved")
                return
            }
        
            guard let results = result[JSONKeys.Results] as? [[String : AnyObject]] else {
                print("Could not find key 'results' in  parsedResult: \(result)")
                completion(success: false, errorString: "Current location not retrieved")
                return
            }
            
            guard let current = results.first else {
                print("No result found in results: \(results)")
                completion(success: false, errorString: "Current location not retrieved")
                return
            }
            self.appData.userInfo?.setLocation(current)
            
            completion(success: true, errorString: nil)
        }
    }
    
    func postStudentLocation(completion: (success: Bool, errorString: String?) -> Void) {
        /* 1. Specify parameters (none), method, and HTTP body */
        let method = Methods.StudentLocation
        if let userInfo = self.appData.userInfo {
            let jsonBody : [String:AnyObject] = [
                JSONKeys.UniqueKey: userInfo.uniqueKey,
                JSONKeys.FirstName: userInfo.firstName,
                JSONKeys.LastName: userInfo.lastName,
                JSONKeys.MapString: userInfo.mapString!,
                JSONKeys.Latitude: userInfo.latitude!,
                JSONKeys.Longitude: userInfo.longitude!,
                JSONKeys.MediaURL: userInfo.mediaURL!]
            
            taskForPOSTMethod(method, jsonBody: jsonBody) { result, error in
                
                /* 3. Send the desired value(s) to completion handler */
                guard error == nil else {
                    completion(success: false, errorString: "Check in failed")
                    return
                }
                
                guard let result = result else {
                    completion(success: false, errorString: "Current location not retrieved")
                    return
                }

                guard let objectId = result[JSONKeys.ObjectId] as? String else {
                    print("Could not find key 'objectId' in  result: \(result)")
                    completion(success: false, errorString: "Check in failed")
                    return
                }
                
                self.appData.userInfo?.objectId = objectId
                
            }
        }
    }
    
    func putStudentLocation(completion: (success: Bool, errorString: String?) -> Void) {
        var mutableMethod = Methods.StudentLocationObjectId
        mutableMethod = subtituteKeyInMethod(mutableMethod, key: URLKeys.ObjectId, value: self.appData.userInfo!.objectId!)
        
        if let userInfo = appData.userInfo {
            let jsonBody : [String:AnyObject] = [
                JSONKeys.UniqueKey: userInfo.uniqueKey,
                JSONKeys.FirstName: userInfo.firstName,
                JSONKeys.LastName: userInfo.lastName,
                JSONKeys.MapString: userInfo.mapString!,
                JSONKeys.Latitude: userInfo.latitude!,
                JSONKeys.Longitude: userInfo.longitude!,
                JSONKeys.MediaURL: userInfo.mediaURL!]
            
            taskForPUTMethod(mutableMethod, jsonBody: jsonBody) { result, error in
                
                /* 3. Send the desired value(s) to completion handler */
                guard error == nil else {
                    completion(success: false, errorString: "Check in failed")
                    return
                }
                
                guard let result = result else {
                    completion(success: false, errorString: "Check in failed")
                    return
                }
                
                guard let _ = result[JSONKeys.UpdatedAt] as? String else {
                    print("Could not find key 'updatedAt' in  result: \(result)")
                    completion(success: false, errorString: "Check in failed")
                    return
                }
                
                completion(success: true, errorString: nil)
            }
        }

    }
}
