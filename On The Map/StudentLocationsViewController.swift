//
//  StudentLocationsViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 6/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import UIKit

class StudentLocationsViewController: UIViewController {
    
    
    
}

extension UIViewController {
    
    // Helper: to display errors to the user, prompt alert with a given message
    func promtAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style:.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
