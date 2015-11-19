//
//  Suggestion.swift
//  NGSuggestions
//
//  Created by Nanda Gundapaneni on 11/18/15.
//  Copyright © 2015 NandaKG. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class Suggestion: NSObject {

    enum SideOfStreet: Int{
        case Left
        case Right
        case None
    }
    
    // JSON keys
    static let kSearchresults = "searchResults"
    static let kResultsCount = "resultsCount"
    static let kFields = "fields"
    static let kName = "name"
    static let kGroup = "group_sic_code_name_ext"
    static let kCoordinates = "coordinates"
    static let kAddress = "address"
    static let kCity = "city"
    static let kState = "state"
    static let kPCode = "postal_code"
    static let kCountry = "country"
    static let kSideOfStreet = "side_of_street"
    static let kDistance = "distance"
    static let kDistanceUnit = "distanceUnit"
    static let kResultNumber = "resultNumber"
    static let kLatitude = "lat"
    static let kLongitude = "lng"
    
    var name:String?
    var group:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var address:String?
    var city:String?
    var state:String?
    var pCode:String?
    var country:String?
    var sideOfStreet:SideOfStreet = SideOfStreet.None
    var distance:Double?
    var distanceUnit:String?
    var resultIndex:Int?
    
    override init() {

    }
    
    init(dictionary: NSDictionary?) {
        
        self.name = dictionary?[Suggestion.kName] as? String
        
        let fieldDict: NSDictionary? = dictionary?[Suggestion.kFields] as? NSDictionary
        
        self.group = fieldDict?[Suggestion.kGroup] as? String
        self.latitude = fieldDict?[Suggestion.kLatitude] as? Double
        self.longitude = fieldDict?[Suggestion.kLongitude] as? Double
        self.address = fieldDict?[Suggestion.kAddress] as? String
        self.city = fieldDict?[Suggestion.kCity] as? String
        self.state = fieldDict?[Suggestion.kState] as? String
        self.pCode = fieldDict?[Suggestion.kPCode] as? String
        self.country = fieldDict?[Suggestion.kCountry] as? String
        self.distance = dictionary?[Suggestion.kDistance] as? Double
        self.distanceUnit = dictionary?[Suggestion.kDistanceUnit] as? String
        self.resultIndex = dictionary?[Suggestion.kResultNumber] as? Int
    }
    
    func fillFromDictionary(dictionary:NSDictionary?){
        
        self.name = dictionary?[Suggestion.kName] as? String
        let fieldDict: NSDictionary? = dictionary?[Suggestion.kFields] as? NSDictionary
        
        self.group = fieldDict?[Suggestion.kGroup] as? String
        self.latitude = fieldDict?[Suggestion.kLatitude] as? Double
        self.longitude = fieldDict?[Suggestion.kLongitude] as? Double
        self.address = fieldDict?[Suggestion.kAddress] as? String
        self.city = fieldDict?[Suggestion.kCity] as? String
        self.state = fieldDict?[Suggestion.kState] as? String
        self.pCode = fieldDict?[Suggestion.kPCode] as? String
        self.country = fieldDict?[Suggestion.kCountry] as? String

        self.distance = dictionary?[Suggestion.kDistance] as? Double
        self.distanceUnit = dictionary?[Suggestion.kDistanceUnit] as? String
        self.resultIndex = dictionary?[Suggestion.kResultNumber] as? Int
    }
    
    func getInfo() -> String?
    {
        let infoString:String = "Name: \(self.name!) \n Group:\(self.group!) \n \(self.address!),\n\(self.city!),\(self.state!),\(self.country!)-\(self.pCode!), \n Distnace: \(self.distance!) \(self.distanceUnit!)"
        
        return infoString
    }
}
