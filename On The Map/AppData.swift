//
//  AppData.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 17/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation

class AppData {
    
    
    /* The current user StudentInformation struct */
    var userInfo: StudentInformation? = nil
    
    /* The users StudentInformation array */
    var studentLocations: [StudentInformation] = [StudentInformation]()
    var newCheckInSinceLastRefresh = false
    
    func needDataRefresh() -> Bool {
        return studentLocations.isEmpty || newCheckInSinceLastRefresh
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> AppData {
        
        struct Singleton {
            static var sharedInstance = AppData()
        }
        
        return Singleton.sharedInstance
    }
}