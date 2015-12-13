//
//  CheckInViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 7/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CheckInViewController: CustomViewController {
    
    @IBOutlet weak var inputTextBox: InformationPostingTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomButton: InformationPostingButton!
    @IBOutlet weak var titleView: UIView!
    
    var stage: InformationPostingStage = .Find
    
    @IBAction func CancelButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextBox.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications when the view appears
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unsubscribe to keyboard notifications when the view disappears
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func bottomButtonTouchUp(sender: UIButton) {
        if stage == .Find {
            guard let address = inputTextBox.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) where !inputTextBox.text!.unicodeScalars.isEmpty else {
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
                        
                        self.appDelegate.userInfo!.setLocation(location, mapString: address)
                        
                        var annotations = [MKPointAnnotation]()
                        annotations.append(self.appDelegate.userInfo!.getMapViewAnnotation()!)
                        
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
            //print("START SUBMIT")
            var urlString = inputTextBox.getTrimmedText()
            guard  !urlString.unicodeScalars.isEmpty else {
                promtAlert("Please enter a link to share")
                return
            }
            
            guard let mediaURL = validateURL(urlString) else {
                promtAlert("The link your entered is invalid, please refine your link")
                return
            }
            
            appDelegate.userInfo!.mediaURL = mediaURL
            
            print("ObjectId: \(appDelegate.userInfo!.objectId) | Latitude: \(appDelegate.userInfo!.latitude) | Longitude: \(appDelegate.userInfo!.longitude)")
            
            if let userInfo = appDelegate.userInfo {
                if userInfo.objectId == nil || userInfo.latitude == nil || userInfo.longitude == nil {
                    print("START POST INFO")
                    ParseClient.sharedInstance().postStudentLocation() { success, errorString -> Void in
                        print("Success: \(success)")
                        if success {
                            ParseClient.sharedInstance().newCheckInSinceLastRefresh = true
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.promtAlert(errorString!)
                            }
                        }
                    }
                } else {
                    print("START PUT INFO")
                    ParseClient.sharedInstance().putStudentLocation() { success, errorString -> Void in
                        print("Success: \(success)")
                        if success {
                            ParseClient.sharedInstance().newCheckInSinceLastRefresh = true
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.promtAlert(errorString!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func switchStage() {
        stage = .Submit
        bottomButton.setStageToSubmit()
        inputTextBox.setStageToSubmit()
    }
}

extension CheckInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        bottomButtonTouchUp(bottomButton)
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
