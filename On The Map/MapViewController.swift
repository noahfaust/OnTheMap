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
        // TODO: reload data
        if ParseClient.sharedInstance().needRefresh() {
            loadStudentLocations()
        }
        else {
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
            self.reloadPins()
        }
    }
    
    private func reloadPins() {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for studentInfo in ParseClient.sharedInstance().studentLocations {

            if let annotation = studentInfo.getMapViewAnnotation() {
                annotations.append(annotation)
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            // When the array is complete, we add the annotations to the map.
            // TODO:remove existing annotations : self.mapView.
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            self.mapView.addAnnotations(annotations)
            
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
            if let urlString = view.annotation!.subtitle! {
                print("urlString: \(urlString)")
                if let url = NSURL(string: urlString) {
                    print("url: \(url.absoluteString)")
                    //let svc = SFSafariViewController(URL: NSURL(string: toOpen)!)
                    let svc = SFSafariViewController(URL: url)
                    self.presentViewController(svc, animated: true, completion: nil)
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