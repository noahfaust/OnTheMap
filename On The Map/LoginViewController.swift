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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        self.addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
    }
    
    
    @IBAction func loginButtonTouchUp(sender: UIButton?) {
        guard let emailText = emailTextField.text where !emailText.isEmpty else {
            promtAlert("Please provide your email and password")
            return
        }
        
        guard let passwordText = passwordTextField.text where !passwordText.isEmpty else {
            promtAlert("Please provide your email and password")
            return
        }
        
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
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func loginCompletionHandler(success: Bool, errorString: String?) {

        if success {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("LoginValidated", sender: self)
            }
        } else {
            var message = "Login failed"
            if let errorString = errorString {
                message = errorString
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.promtAlert(message)
            }
        }
    }
    
    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        let svc = SFSafariViewController(URL: NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    func promtAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isKindOfClass(CustomTextField) {
            if let nextField = (textField as! CustomTextField).nextTextField {
                nextField.becomeFirstResponder()
                return false
            } else {
                loginButtonTouchUp(nil)
            }
        }
        return true
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

