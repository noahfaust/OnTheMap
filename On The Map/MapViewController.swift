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
import SafariServices

class MapViewController: CustomViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blockingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        // if the user just checked in a new location, the last 100 locations are downloaded and the map reloads the 100 pins
        if appData.needDataRefresh() {
            loadStudentLocations()
        } else {
            // else the map just reload the pins
            reloadPins()
        }
    }
    
    
    @IBAction func refreshButtonTouchUp(sender: AnyObject) {
        loadStudentLocations()
    }
    
    @IBAction func logoutButtonTouchUp(sender: AnyObject) {
        
        parentViewController?.dismissViewControllerAnimated(true) {
            UdacityClient.sharedInstance().deleteSession() { success, errorString in
                if UdacityClient.sharedInstance().facebookToken != nil {
                    FacebookHelper.logout()
                }
            }
        }
    }
    
    func loadStudentLocations() {
        showLoadingIndicator()
        ParseClient.sharedInstance().getStudentLocations { success, error -> Void in
            if success {
                self.reloadPins()
            } else {
                self.hideLoadingIndicator()
                self.promtAlert(error!)
            }
        }
    }
    
    private func reloadPins() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for studentInfo in appData.studentLocations {

            if let annotation = studentInfo.getMapViewAnnotation() {
                annotations.append(annotation)
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            // First remove all existing pins
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
            
            // Hide the loading activity indicator
            self.hideLoadingIndicator()
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.blueColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // Get the url from the pin subtitle
            if let urlString = view.annotation!.subtitle! {
                // Get a valid url string
                if let validUrlString = validateURL(urlString) {
                    if let url = NSURL(string: validUrlString) {
                        let svc = SFSafariViewController(URL: url)
                        self.presentViewController(svc, animated: true, completion: nil)
                    }else {
                        promtAlert("The shared link is invalid")
                    }
                } else {
                    promtAlert("The shared link is invalid")
                }
            }
        }
    }
}

extension MapViewController {
    
    // MARK: Show and Hide loading activity indicator
    func showLoadingIndicator() {
        self.view.bringSubviewToFront(blockingView)
        blockingView.hidden = false
        
        self.view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        blockingView.hidden = true
        
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
    }
}