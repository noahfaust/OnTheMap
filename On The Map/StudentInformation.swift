//
//  StudentInformation.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import MapKit

struct StudentInformation {
    
    // MARK: Properties
    
    var objectId: String?
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Initializers
    
    /* Construct a StudentInformation from a dictionary: used when loading the 100 last locations */
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONKeys.ObjectId] as? String
        uniqueKey = dictionary[ParseClient.JSONKeys.UniqueKey] as! String
        if let first = dictionary[ParseClient.JSONKeys.FirstName] as? String {
            firstName = first
        } else {
            firstName = ""
        }
        if let last = dictionary[ParseClient.JSONKeys.LastName] as? String {
            lastName = last
        } else {
            lastName = ""
        }
        mapString = dictionary[ParseClient.JSONKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONKeys.Longitude] as? Double
    }
    
    /* Construct a StudentInformation with Udacity parameters (first name, last name and user Id): used when the user logs in */
    init(userId: String, firstName: String?, lastName: String?) {
        uniqueKey = userId
        if let firstName = firstName {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        if let lastName = lastName {
            self.lastName = lastName
        } else {
             self.lastName = ""
        }
    }
    
    /* Return the annotation point for the given user: used to display the last 100 locations */
    func getMapViewAnnotation() -> MKPointAnnotation? {
        guard let latitude = latitude else {
            return nil
        }
        guard let longitude = longitude else {
            return nil
        }
        
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName) \(lastName)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let mediaURL = mediaURL {
            annotation.subtitle = mediaURL
        }
        return annotation
    }
    
    /* Update user location: used by check in screen */
    mutating func setLocation(location: CLLocation, mapString: String, mediaURL: String) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    
    /* Update user location at login if Parse return an existing location */
    mutating func setLocation(dictionary: [String : AnyObject]) {
        
        if let objectId = dictionary[ParseClient.JSONKeys.ObjectId] as? String {
            self.objectId = objectId
        }
        
        // uniqueKey, firstName, lastName are already set by Udacity getUserInfo
        
        if let mapString = dictionary[ParseClient.JSONKeys.MapString] as? String {
            self.mapString = mapString
        }
        
        if let mediaURL = dictionary[ParseClient.JSONKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        }
        
        if let latitude = dictionary[ParseClient.JSONKeys.Latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary[ParseClient.JSONKeys.Longitude] as? Double {
            self.longitude = longitude
        }
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func studentinfoFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var movies = [StudentInformation]()
        
        for result in results {
            movies.append(StudentInformation(dictionary: result))
        }
        
        return movies
    }
    
    

}
