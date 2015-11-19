//
//  ViewController.swift
//  NGSuggestions
//
//  Created by Nanda Gundapaneni on 11/18/15.
//  Copyright © 2015 NandaKG. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet weak var locationCoordinatesLabel: UILabel!
    
    var suggestions:NSArray = []
    var suggestionsVisible:NSMutableArray = NSMutableArray()
    var suggestionsCount:Int?
    var currentQuadDirection:Suggestion.HeadingQuadrant?
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.layoutMargins = UIEdgeInsetsZero

        // Default location -- Mainly for testing or for running on a simulator
        self.getDataForLocation(Suggestion.Default_Location)
        
        
        // Setup location manager
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10.0
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.locationManager.headingFilter = 5
        self.locationManager.startUpdatingHeading()
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func directionButtonTapped(sender: AnyObject) {
        
        let alertController = UIAlertController(title:"How to use?", message: "Keep pointing your phone in different directions to use the magnetic heading of the phone to show the places in that direction. This is just a prototype so the calculations may not be accurate!", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        });
        
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil);
    
    }
    
    
    func getDataForLocation(location:CLLocationCoordinate2D){
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
            self.suggestionsVisible.addObjectsFromArray(self.suggestions as! [Suggestion])
            self.suggestionsCount = resultCount
            self.tableView.reloadData()
        }

    }

    //MARK: CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case CLAuthorizationStatus.Authorized:
            fallthrough
        case CLAuthorizationStatus.AuthorizedAlways:
            fallthrough
            
        case CLAuthorizationStatus.AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        default:
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.currentLocation = newLocation
        
        self.getDataForLocation((self.currentLocation?.coordinate)!)
        
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (newHeading.headingAccuracy < 0)
        {return;}
        
        // Use the true heading if it is valid.
        let theHeading = ((newHeading.trueHeading > 0) ?
            newHeading.trueHeading : newHeading.magneticHeading);
        
        self.currentQuadDirection = Suggestion.headingQuad(theHeading);
        
        self.updateVisiblePlaces(self.currentQuadDirection!)
        
        self.directionButton.setTitle(Suggestion.getDirectionString(self.currentQuadDirection!), forState: UIControlState.Normal)
    }
    
    
    func updateVisiblePlaces(quad:Suggestion.HeadingQuadrant)
    {
        self.suggestionsVisible.removeAllObjects()
        
        for s in self.suggestions
        {
            let sug = s as! Suggestion
            
            if(self.currentQuadDirection == sug.headingQuadrant){
                self.suggestionsVisible.addObject(sug as Suggestion!)
            }
        }
        
        
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestionsVisible.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "suggestionCellIdentifier"
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
        let suggestion:Suggestion = (self.suggestionsVisible[indexPath.row] as? Suggestion)!
        cell.textLabel?.text = suggestion.name!
        cell.detailTextLabel?.text = suggestion.group!
        
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let suggestion:Suggestion = (self.suggestionsVisible[indexPath.row] as? Suggestion)!
        
        let alertController = UIAlertController(title:suggestion.name!, message: suggestion.getInfo(), preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        });
        
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil);

        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

