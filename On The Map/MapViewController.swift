//
//  MapViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        
        ParseClient.sharedInstance().getStudentLocations { success, error -> Void in
            
            // The "locations" array is an array of dictionary objects that are similar to the JSON
            // data that you can download from parse.
            let locations = ParseClient.sharedInstance().ParseStudentLocations
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
            var annotations = [MKPointAnnotation]()
            
            // The "locations" array is loaded with the sample data below. We are using the dictionaries
            // to create map annotations. This would be more stylish if the dictionaries were being
            // used to create custom structs. Perhaps StudentLocation structs.
            
            for location in locations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(location.Latitude)
                let long = CLLocationDegrees(location.Longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = location.FirstName
                let last = location.LastName
                let mediaURL = location.MediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            dispatch_async(dispatch_get_main_queue()) {
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
                
                self.hideLoadingIndicator()
            }
        }

        
        
        
    }
    
}

extension MapViewController {
    
    // MARK: Show and Hide loading activity indicator
    func showLoadingIndicator() {
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
    }
}