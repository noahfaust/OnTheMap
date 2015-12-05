//
//  ParseStudentInformation.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

struct ParseStudentInformation {
    
    // MARK: Properties
    
    var ObjectId: String
    var UniqueKey: String
    var FirstName: String
    var LastName: String
    var MapString: String
    var MediaURL: String
    var Latitude: Double
    var Longitude: Double
    
    // MARK: Initializers
    
    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        ObjectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        UniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        FirstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        LastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        MapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        MediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        ObjectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        Latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        Longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func studentinfoFromResults(results: [[String : AnyObject]]) -> [ParseStudentInformation] {
        var movies = [ParseStudentInformation]()
        
        for result in results {
            movies.append(ParseStudentInformation(dictionary: result))
        }
        
        return movies
    }

}
