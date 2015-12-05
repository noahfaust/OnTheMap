//
//  ParseConstantsExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        
        // MARK: Udacity info
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let BaseURLSecure = "https://api.parse.com/1/classes/"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        static let StudentLocation = "StudentLocation"
        static let StudentLocationObjectId = "StudentLocation/{objectId}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: URL Keys
    struct ParameterKeys {
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        
    }
    
    // MARK: HTTP Header Fields
    struct httpHeaderFields {
        
        static let AppId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Results = "results"
        
        // MARK: StudentLovation
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
        
    }
    
    
}
