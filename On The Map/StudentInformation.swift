//
//  StudentInformation.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import MapKit

class StudentInformation {
    
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
    
    /* Construct a StudentInformation from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        if let first = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String {
            firstName = first
        } else {
            firstName = ""
        }
        if let last = dictionary[ParseClient.JSONResponseKeys.LastName] as? String {
            lastName = last
        } else {
            lastName = ""
        }
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
    }
    
    /* Construct a StudentInformation with parameter */
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
    
//    func setMediaURL(mediaURL: String) {
//        self.mediaURL = mediaURL
//    }
    
    func setLocation(location: CLLocation, mapString: String) {
        //self.latitude = latitude
        //self.longitude = longitude
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.mapString = mapString
        
        print("Latitude: \(self.latitude) Longitude: \(self.longitude)")
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
