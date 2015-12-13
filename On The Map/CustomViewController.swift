//
//  CustomViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 6/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func validateURL(string: String) -> String? {
        print("ValidateURL string: \(string)")
        let datadetector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)
        let range = NSMakeRange(0, string.unicodeScalars.count)
        
        guard let result = datadetector.firstMatchInString(string, options: .Anchored, range: range) else {
            return nil
        }
        
        print("ValidateURL result.URL: \(result.URL?.absoluteString)")
        print("NSEqualRanges: \(NSEqualRanges(range, result.range))")
        guard let url = result.URL?.absoluteString where NSEqualRanges(range, result.range) else {
            return nil
        }
        return url
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
    
    // Helper: to display errors to the user, prompt alert with a given message
    func promtAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
