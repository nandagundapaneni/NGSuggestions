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
    static let kState = "state"
    static let kPCode = "postal_code"
    static let kCountry = "country"
    static let kSideOfStreet = "side_of_street"
    static let kDistance = "distance"
    static let kDistanceUnit = "distanceUnit"
    static let kResultNumber = "resultNumber"
    static let kLatitude = "lat"
    static let kLongitude = "lng"
    
    var name:NSString?
    var group:NSString?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var address:NSString?
    var state:NSString?
    var pCode:NSString?
    var country:NSString?
    var sideOfStreet:SideOfStreet = SideOfStreet.None
    var distance:Double?
    var distanceUnit:NSString?
    var resultIndex:Int?
    
    override init() {

    }
    
    init(dictionary: NSDictionary?) {
        
        self.name = dictionary?[Suggestion.kName] as? NSString
        self.group = dictionary?[Suggestion.kGroup] as? NSString
        self.latitude = dictionary?[Suggestion.kLatitude] as? Double
        self.longitude = dictionary?[Suggestion.kLongitude] as? Double
        self.address = dictionary?[Suggestion.kAddress] as? NSString
        self.state = dictionary?[Suggestion.kState] as? NSString
        self.pCode = dictionary?[Suggestion.kPCode] as? NSString
        self.country = dictionary?[Suggestion.kCountry] as? NSString
        self.distance = dictionary?[Suggestion.kDistance] as? Double
        self.distanceUnit = dictionary?[Suggestion.kDistanceUnit] as? NSString
        self.resultIndex = dictionary?[Suggestion.kResultNumber] as? Int
    }
    
    func fillFromDictionary(dictionary:NSDictionary?){
        
        self.name = dictionary?[Suggestion.kName] as? NSString
        self.group = dictionary?[Suggestion.kGroup] as? NSString
        self.latitude = dictionary?[Suggestion.kLatitude] as? Double
        self.longitude = dictionary?[Suggestion.kLongitude] as? Double
        self.address = dictionary?[Suggestion.kAddress] as? NSString
        self.state = dictionary?[Suggestion.kState] as? NSString
        self.pCode = dictionary?[Suggestion.kPCode] as? NSString
        self.country = dictionary?[Suggestion.kCountry] as? NSString
        self.distance = dictionary?[Suggestion.kDistance] as? Double
        self.distanceUnit = dictionary?[Suggestion.kDistanceUnit] as? NSString
        self.resultIndex = dictionary?[Suggestion.kResultNumber] as? Int
    }
}
