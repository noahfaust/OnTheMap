//
//  TableViewController.swift
//  On The Map
//
//  Created by Alexandre Gonzalo on 5/12/2015.
//  Copyright © 2015 Agito Cloud. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudentLocations()
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
        ParseClient.sharedInstance().getStudentLocations { error -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
}

extension TableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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