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

class LoginViewController: CustomViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        facebookLoginButton.delegate = self
        
        // When the facebook authentication has been used before in the app, the login screen appear with a facebook logout button
        FacebookHelper.logout()
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
        hideLoadingIndicator()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
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
            self.hideLoadingIndicator()
            promtAlert("There was an error with your facebook login")
            return
        }
        
        guard !result.isCancelled  else {
            self.hideLoadingIndicator()
            promtAlert("Your request has been cancelled")
            return
        }
        
        // Request a new session using Udacity API with the facebook token,
        UdacityClient.sharedInstance().postNewSession(result.token.tokenString) { success, errorString -> Void in
            self.loginCompletionHandler(success, errorString: errorString)
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        self.showLoadingIndicator()
        return true
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
            self.hideLoadingIndicator()
            self.performSegueWithIdentifier("OpenApp", sender: self)
        }
    }
    
    // On sign up, open Udacity sign up in safari view controller
    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        let svc = SFSafariViewController(URL: NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }

}

