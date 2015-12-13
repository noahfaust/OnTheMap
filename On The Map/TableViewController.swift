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
        
//        if ParseClient.sharedInstance().studentLocations.isEmpty {
//            loadStudentLocations()
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ParseClient.sharedInstance().needRefresh() {
            loadStudentLocations()
        } else {
        
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
    
    @IBAction func pinButtonTouchUp(sender: AnyObject) {
        // TODO:
    }
    
    @IBAction func logoutButtonTouchUp(sender: AnyObject) {
        
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        FacebookHelper.logout()
        
        UdacityClient.sharedInstance().deleteSession()
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
        let location = ParseClient.sharedInstance().studentLocations[indexPath.row]
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
        return ParseClient.sharedInstance().studentLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let location = ParseClient.sharedInstance().studentLocations[indexPath.row]
//        if let url = NSURL(string: location.mediaURL!) {
//            let svc = SFSafariViewController(URL: url)
//            self.presentViewController(svc, animated: true, completion: nil)
//        }
        
        if let urlString = location.mediaURL {
            print("urlString: \(urlString)")
            if let url = NSURL(string: urlString) {
                print("url: \(url.absoluteString)")
                //let svc = SFSafariViewController(URL: NSURL(string: toOpen)!)
                let svc = SFSafariViewController(URL: url)
                self.presentViewController(svc, animated: true, completion: nil)
            }
        }
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