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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blockingView: UIView!
    
    var stage: InformationPostingStage = .Find
    var address: String = ""
    var location: CLLocation? = nil
    var mediaURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextBox.delegate = self
        hideLoadingIndicator()
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
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func bottomButtonTouchUp(sender: UIButton) {
        if stage == .Find {
            let address = inputTextBox.getTrimmedText()
            guard !inputTextBox.getTrimmedText().unicodeScalars.isEmpty else {
                promtAlert("Please enter your location")
                return
            }
            findAddress(address)
        } else {
            let urlString = inputTextBox.getTrimmedText()
            guard  !urlString.unicodeScalars.isEmpty else {
                promtAlert("Please enter a link to share")
                return
            }
            submitLocation(urlString)
        }
    }
    
    private func submitLocation(urlString: String) {
        
        guard let validURL = validateURL(urlString) else {
            promtAlert("The link your entered is invalid, please refine your link")
            return
        }
        mediaURL = validURL
        
        appDelegate.userInfo!.setLocation(location!, mapString: address, mediaURL: mediaURL)
        
        if let userInfo = appDelegate.userInfo {
            if userInfo.objectId == nil {
                ParseClient.sharedInstance().postStudentLocation(submitCompletionHandler)
            } else {
                ParseClient.sharedInstance().putStudentLocation(submitCompletionHandler)
            }
        }
    }
    
    private func submitCompletionHandler(success: Bool, errorString: String?) {
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
    
    private func findAddress(address: String) {
        showLoadingIndicator()
        geocode(address) { location -> Void in
            guard let location = location else {
                self.promtAlert("The location you entered could not be geocoded, please refine your location")
                return
            }
            
            self.address = address
            self.location = location
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1))), animated: true)
                self.setStageToSubmit()
            }
        }
    }
    
    private func geocode(address: String, completion: (location: CLLocation?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error -> Void in
            
            guard let place = placemarks?.first else {
                completion(location: nil)
                return
            }
            
            completion(location: place.location)
        }
    }
    
    func setStageToSubmit() {
        stage = .Submit
        bottomButton.setStageToSubmit()
        inputTextBox.setStageToSubmit()
        titleView.hidden = true
        mapView.hidden = false
        hideLoadingIndicator()
    }
}

extension CheckInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        bottomButtonTouchUp(bottomButton)
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension CheckInViewController {
    
    // MARK: Show and Hide loading activity indicator
    func showLoadingIndicator() {
        view.bringSubviewToFront(blockingView)
        blockingView.hidden = false
        
        view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        blockingView.hidden = true
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
    }
}
