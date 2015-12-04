//
//  LoginViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 2/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTouchUp(sender: UIButton) {
        UdacityClient.sharedInstance().postNewSession(emailTextField.text!, password: passwordTextField.text!) { success, errorString -> Void in
            self.loginCompletionHandler(success, errorString: errorString)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            // Process error
        } else {
            print("User Logged In")
            if result.isCancelled {
                // Handle cancellations
            } else {
                UdacityClient.sharedInstance().postNewSessionWithFacebook(result.token.tokenString) { success, errorString -> Void in
                    self.loginCompletionHandler(success, errorString: errorString)
                }
            }
        }
    }
    
    func loginCompletionHandler(success: Bool, errorString: String?) {

        if success {
            /* 6. Use the data! */
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("LoginValidated", sender: self)
            }
        } else {
            var message: String? = nil
            if let errorString = errorString {
                message = errorString
            } else {
                message = "Login failed"
            }
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style:.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

}

