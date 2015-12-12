//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 7/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var inputTextBox: InformationPostingTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomButton: InformationPostingButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var stage: InformationPostingStage = .Find
    
    @IBAction func CancelButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        inputTextBox.delegate = self
        
        //bottomButton.bringSubviewToFront(bottomButton.superview!)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Subscribe to keyboard notifications when the view appears
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // Unsubscribe to keyboard notifications when the view disappears
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func bottomButtonTouchUp(sender: UIButton) {
        guard let address = inputTextBox.text where !inputTextBox.text!.unicodeScalars.isEmpty else {
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error -> Void in
            
            guard let places = placemarks where places.count == 1 else {
                print("placemarks: \(placemarks) | count: \(placemarks?.count)")
                self.promtAlert("The location you entered could not be geocoded, please refine your location")
                return
            }
            
            if let mark = places.first {
            
                print("Longitude: \(mark.location?.coordinate.longitude) | Latitude: \(mark.location?.coordinate.latitude)")
                
                print("Country: \(mark.country) | Region: \(mark.region)")
                if let location = mark.location {
                    
                    self.loadingPin(location)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.switchStage()
                    }
                }
            }
        }
    }
    
    func loadingPin(location: CLLocation) {
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        //let locations = ParseClient.sharedInstance().ParseStudentLocations
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
            
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        //let lat = CLLocationDegrees(location.Latitude)
        //let long = CLLocationDegrees(location.Longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        //let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        //let first = location.FirstName
        //let last = location.LastName
        //let mediaURL = location.MediaURL
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        //annotation.title = "\(first) \(last)"
        //annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        dispatch_async(dispatch_get_main_queue()) {
            // When the array is complete, we add the annotations to the map.
            self.mapView.hidden = false
            self.titleView.hidden = true
            self.mapView.addAnnotations(annotations)
            //self.mapView.setCenterCoordinate(location.coordinate, animated: true)
            self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1))), animated: true)
            //self.hideLoadingIndicator()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func switchStage() {
        bottomButton.setStageToSubmit()
        inputTextBox.setStageToSubmit()
    }
}

extension InformationPostingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        bottomButtonTouchUp(bottomButton)
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // if the bottom text field displays the keyboard, move the frame up so the bottom can be seen while being edited
//        label1.font = UIFont(name: label1.font.fontName, size: 20)
//        label2.font = UIFont(name: label2.font.fontName, size: 20)
//        label3.font = UIFont(name: label3.font.fontName, size: 20)
//        view.frame = CGRectMake(0 , 0, view.frame.width, view.frame.height - getKeyboardHeight(notification))
        view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // When keyboard hides, bring the frame back to its orginal place
//        label1.font = UIFont(name: label1.font.fontName, size: 40)
//        label2.font = UIFont(name: label2.font.fontName, size: 40)
//        label3.font = UIFont(name: label3.font.fontName, size: 40)
//        view.frame = CGRectMake(0 , 0, view.frame.width, view.frame.height + getKeyboardHeight(notification))
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        // Subscribe to Keyboard duisplay and dismiss
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // Unsubscribe to Keyboard duisplay and dismiss
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}
