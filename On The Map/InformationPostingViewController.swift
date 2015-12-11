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
    
    @IBOutlet weak var inputTextBox: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    
    @IBAction func CancelButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        inputTextBox.delegate = self
        inputTextBox.attributedPlaceholder = NSAttributedString(string:"Enter your location here",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        bottomButton.layer.cornerRadius = 10
        bottomButton.layer.borderWidth = 10
        bottomButton.layer.borderColor = UIColor.whiteColor().CGColor
        bottomButton.bringSubviewToFront(bottomButton.superview!)
        
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
        
    }
}

extension InformationPostingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //bottomButtonTouchUp(bottomButton)
        view.endEditing(true)
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
