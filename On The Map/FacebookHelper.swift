//
//  FacebookHelper.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 6/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookHelper {
    
    class func logout() {
        let manager = FBSDKLoginManager()
        manager.logOut()
    }
    
}
