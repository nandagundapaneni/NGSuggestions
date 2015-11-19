//
//  ViewController.swift
//  NGSuggestions
//
//  Created by Nanda Gundapaneni on 11/18/15.
//  Copyright © 2015 NandaKG. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var locationCoordinatesLabel: UILabel!
    
    var suggestions:NSArray = []
    var suggestionsCount:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let location = CLLocationCoordinate2DMake(40.024227, -105.220264);
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.activityIndicator.startAnimating()
        DataController.sharedInstance.getSuggestionForCurrentLocation(location, radius: 0,maxResults: 0) { (result,resultCount, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            self.locationCoordinatesLabel.text = "ORIGIN:\(location.latitude),\(location.longitude)"
            
            if error != nil{
            
                let alertController = UIAlertController(title: "Error in getting suggestions", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { action in
                    self.dismissViewControllerAnimated(true, completion: nil)
                });
                
                alertController.addAction(cancel)
                self.presentViewController(alertController, animated: true, completion: nil);
                
                return
            }
            
            self.suggestions = result!
            self.suggestionsCount = resultCount
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "suggestionCellIdentifier"
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
        let suggestion:Suggestion = (self.suggestions[indexPath.row] as? Suggestion)!
        cell.textLabel?.text = suggestion.name!
        cell.detailTextLabel?.text = suggestion.group!
        
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let suggestion:Suggestion = (self.suggestions[indexPath.row] as? Suggestion)!
        
        let alertController = UIAlertController(title:suggestion.name!, message: suggestion.getInfo(), preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        });
        
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil);

        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

