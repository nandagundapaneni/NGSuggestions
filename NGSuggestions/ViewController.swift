//
//  ViewController.swift
//  NGSuggestions
//
//  Created by Nanda Gundapaneni on 11/18/15.
//  Copyright © 2015 NandaKG. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var suggestions:NSArray?
    var suggestionsCount:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let location = CLLocationCoordinate2DMake(40.024227, -105.220264);
        
        self.activityIndicator.startAnimating()
        DataController.sharedInstance.getSuggestionForCurrentLocation(location, radius: 0,maxResults: 0) { (result,resultCount, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            if error != nil{
            
                let alertController = UIAlertController(title: "Error in getting suggestions", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let cancel = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { action in
                    self.dismissViewControllerAnimated(true, completion: nil)
                });
                
                alertController.addAction(cancel)
                self.presentViewController(alertController, animated: true, completion: nil);
                
                return
            }
            
            self.suggestions = result
            self.suggestionsCount = resultCount
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

