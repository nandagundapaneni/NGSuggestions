//
//  DataController.swift
//  NGSuggestions
//
//  Created by Nanda Gundapaneni on 11/18/15.
//  Copyright © 2015 NandaKG. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class DataController: NSObject {
    static let API_KEY = "8ToaeIoIOGxRGCPUCgh2of8uTMM3wRmV"
    static let BaseURLString = "http://www.mapquestapi.com/search/v2/radius?key="
    static let Origin = "&origin="
    static let resultsFilter = "&maxMatches="
    static let Default_Radius = 3200.00
    static let DefaultMaxMatches = 100
    
    static let sharedInstance = DataController();
    
    override init() {
        
    }
    
    func getSuggestionForCurrentLocation(origin:CLLocationCoordinate2D, radius:Double, maxResults:Int, onCompletion:(result:NSArray?,resultCount:Int?,error:NSError?) -> Void)
    {
        var  radiusOpt = radius
        if radiusOpt<=0{
            radiusOpt = DataController.Default_Radius
        }
        var maxResultsOpt = maxResults
        if maxResultsOpt<=0{
            maxResultsOpt = DataController.DefaultMaxMatches
        }
        
        let coordinates = "\(origin.latitude),\(origin.longitude)"
        let urlString = DataController.BaseURLString + DataController.API_KEY + DataController.resultsFilter + "\(maxResultsOpt)" + DataController.Origin + coordinates
        
        print(urlString)
        
        Alamofire.request(.GET, urlString).responseJSON { response in
            switch response.result{
            case .Success(let data):
                let json = JSON(data).dictionaryObject
                let resultCount = json?[Suggestion.kResultsCount] as? Int
                let jsonArray = json?[Suggestion.kSearchresults] as? NSArray
                let sugesstionsArray:NSMutableArray = NSMutableArray(capacity: (jsonArray?.count)!)
                
                
                for dict in jsonArray!{
                    let dictionary = dict as? NSDictionary
                    let suggestion:Suggestion = Suggestion(dictionary: dictionary,origin: origin)

                    sugesstionsArray.addObject(suggestion)
                }
                
                onCompletion(result: sugesstionsArray, resultCount: resultCount, error: nil)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                onCompletion(result: nil, resultCount: nil  , error: error)
            }
            
        }
    }
}
