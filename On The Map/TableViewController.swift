//
//  TableViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(loadingIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        loadStudentLocations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        hideLoadingIndicator()
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
        // TODO:
    }
    
    func loadStudentLocations() {
        showLoadingIndicator()
        ParseClient.sharedInstance().getStudentLocations { success, error -> Void in
            print("SUCCESS: \(success)")
            print("Locations Count: \(ParseClient.sharedInstance().ParseStudentLocations.count)")
            dispatch_async(dispatch_get_main_queue()) {
                self.hideLoadingIndicator()
                self.tableView.reloadData()
            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationCell"
        let location = ParseClient.sharedInstance().ParseStudentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(location.FirstName) \(location.LastName)"
        cell.detailTextLabel!.text = location.MediaURL
        cell.imageView!.image = UIImage(named: "pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().ParseStudentLocations.count
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        /* Push the movie detail view */
//        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[indexPath.row]
//        self.navigationController!.pushViewController(controller, animated: true)
//    }
}

extension TableViewController {
    
    
    
    // MARK: Show and Hide loading activity indicator
    func showLoadingIndicator() {
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
    }
}