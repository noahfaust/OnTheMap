//
//  UdacityConstantsExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 4/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        
        // MARK: URLs
        static let BaseURLSecure = "https://www.udacity.com/api/"
    
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "session"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        // MARK: Udacity Login
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // MARK: Facebook Login
        static let FacebookLogin = "facebook_mobile"
        static let AccessToken = "access_token"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Session
        static let Account = "account"
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionId = "id"
        static let SessionExpiration = "expiration"
        
        // MARK: Error
        static let Status = "status"
        static let Error = "error"
        
    }
    
}