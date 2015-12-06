//
//  LoginViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 2/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FacebookHelper.logout()
        
        hideLoadingIndicator()
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideLoadingIndicator()
        removeKeyboardDismissRecognizer()
    }
    
    
    @IBAction func loginButtonTouchUp(sender: UIButton?) {
        // Check Email and Password fields are not empty
        guard let emailText = emailTextField.text where !emailText.isEmpty else {
            promtAlert("Please provide your email and password")
            return
        }
        guard let passwordText = passwordTextField.text where !passwordText.isEmpty else {
            promtAlert("Please provide your email and password")
            return
        }
        
        showLoadingIndicator()
        
        // Request a new session using Udacity API with Email and Password
        UdacityClient.sharedInstance().postNewSession(emailTextField.text!, password: passwordTextField.text!) { success, errorString -> Void in
            self.loginCompletionHandler(success, errorString: errorString)
        }
    }
    
    // Required method to implemenent the facebook login button
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        guard error == nil else {
            promtAlert("There was an error with your facebook login")
            return
        }
        guard !result.isCancelled  else {
            promtAlert("Your request has been cancelled")
            return
        }
        
        showLoadingIndicator()
        
        // Request a new session using Udacity API with the facebook token,
        UdacityClient.sharedInstance().postNewSessionWithFacebook(result.token.tokenString) { success, errorString -> Void in
            self.loginCompletionHandler(success, errorString: errorString)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out from Facebook")
    }
    
    // Helper: if login (though Udacity or Facebook) is validated then perform the segue else prompt an error message
    func loginCompletionHandler(success: Bool, errorString: String?) {
        
        guard success else {
            var message = "Login failed"
            if let errorString = errorString {
                message = errorString
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.hideLoadingIndicator()
                self.promtAlert(message)
            }
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            //self.hideLoadingIndicator()
            self.performSegueWithIdentifier("OpenApp", sender: self)
        }
    }
    
    // On sign up, open Udacity sign up in safari view controller
    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        let svc = SFSafariViewController(URL: NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    // Helper: to display errors to the user, prompt alert with a given message
    func promtAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

