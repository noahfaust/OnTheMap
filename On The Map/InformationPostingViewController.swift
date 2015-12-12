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
        if stage == .Find {
            guard let address = inputTextBox.text where !inputTextBox.text!.unicodeScalars.isEmpty else {
                return
            }
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { placemarks, error -> Void in
                
                guard let places = placemarks where places.count == 1 else {
                    self.promtAlert("The location you entered could not be geocoded, please refine your location")
                    return
                }
                
                if let place = places.first {
                    
                    if let location = place.location {
                        
                        UdacityClient.sharedInstance().userInfo!.setLocation(location, mapString: address)
                        var annotations = [MKPointAnnotation]()
                        annotations.append(UdacityClient.sharedInstance().userInfo!.getMapViewAnnotation()!)
                        
                        dispatch_async(dispatch_get_main_queue()) {self.mapView.hidden = false
                            self.titleView.hidden = true
                            self.mapView.addAnnotations(annotations)
                            self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1))), animated: true)
                            self.switchStage()
                        }
                    }
                }
            }
        } else {
            print("START SUBMIT")
            if let urlString = inputTextBox.text where !urlString.unicodeScalars.isEmpty {
                let url = NSURL(string: urlString)
                guard UIApplication.sharedApplication().canOpenURL(url!) else {
                    promtAlert("The link your entered is invalid, please refine your link")
                    return
                }
                
                UdacityClient.sharedInstance().userInfo!.mediaURL = urlString
            }
        }
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func switchStage() {
        stage = .Submit
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
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
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
