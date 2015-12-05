//
//  LoginViewExtension.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

extension LoginViewController {
    
    /* Extension with UI merthods: Tap Recognition and Text field delegation */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isKindOfClass(CustomTextField) {
            
            if let nextField = (textField as! CustomTextField).nextTextField {
                
                // If current field if Email, then it has a Next field (using Custom Text Field class)
                // On hitting Return, the Password field become the first responder
                nextField.becomeFirstResponder()
                return false
                
            } else {
                
                // If current field if Password, the login process is launched on hitting Return
                loginButtonTouchUp(nil)
            }
        }
        return true
    }
    
    // MARK: 3 methods to dismiss the keyboard if the user taps outside of the Email & Password text fields
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
