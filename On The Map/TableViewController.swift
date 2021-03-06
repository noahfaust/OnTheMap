//
//  TableViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class TableViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if appData.needDataRefresh() {
            // if the user just checked in a new location, the last 100 locations are downloaded and the map reloads the 100 cells
            loadStudentLocations()
        } else {
            // else the map just reload the cells
            hideLoadingIndicator()
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideLoadingIndicator()
    }
    
    @IBAction func refreshButtonTouchUp(sender: AnyObject) {
        loadStudentLocations()
    }
    
    @IBAction func logoutButtonTouchUp(sender: AnyObject) {
        parentViewController?.dismissViewControllerAnimated(true) {
            UdacityClient.sharedInstance().deleteSession() { success, errorString in
                if UdacityClient.sharedInstance().facebookToken != nil {
                    FacebookHelper.logout()
                }
            }
        }
    }
    
    func loadStudentLocations() {
        showLoadingIndicator()
        ParseClient.sharedInstance().getStudentLocations { success, error -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.hideLoadingIndicator()
                    self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.hideLoadingIndicator()
                    self.promtAlert("The students locations could't be loaded")
                }
            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationCell"
        let location = appData.studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(location.firstName) \(location.lastName)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let mediaURL = location.mediaURL {
            cell.detailTextLabel!.text = mediaURL
        }
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appData.studentLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let location = appData.studentLocations[indexPath.row]
        
        guard let urlString = location.mediaURL else {
            // mediaURL is empty
            return
        }
        guard let validUrl = validateURL(urlString) else {
            promtAlert("This link is invalid, it cannot be opened")
            return
        }
        guard let url = NSURL(string: validUrl) else {
            promtAlert("This link is invalid, it cannot be opened")
            return
        }
        
        let svc = SFSafariViewController(URL: url)
        self.presentViewController(svc, animated: true, completion: nil)
        
    }
}

extension TableViewController {
    
    // MARK: Show and Hide loading activity indicator
    func showLoadingIndicator() {
        view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
    }
}