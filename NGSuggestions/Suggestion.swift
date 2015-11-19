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
    
    enum HeadingQuadrant:Int{
        
        case UNKNOWN
        case NE
        case NW
        case SE
        case SW
    }
    
    enum Magnetic:Int
    {
        case North
        case East
        case South
        case West
    }
    
    struct Magnetic_Direction {
        static let North = 0.00
        static let East = 90.00
        static let South = 180.00
        static let West = 270.00
    }
    
    static let Default_Location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(39.750847, -104.999750);
    
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
    var magneticLatDirection:Magnetic = Magnetic.North
    var magneticLngDirection:Magnetic = Magnetic.East
    var headingQuadrant:HeadingQuadrant = HeadingQuadrant.NE
    var originLocation:CLLocationCoordinate2D?
    
    init(dictionary: NSDictionary?,origin:CLLocationCoordinate2D?) {
        
        super.init()
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
        self.originLocation = origin
        
        self.fillDirectionsFromLatLng();
    }
    
    func fillFromDictionary(dictionary:NSDictionary?,origin:CLLocationCoordinate2D?){
        
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
        self.originLocation = origin
        
        self.fillDirectionsFromLatLng();
    }
    
    func fillDirectionsFromLatLng(){
        self.magneticLatDirection = (self.latitude! >= 0) ? Magnetic.North:Magnetic.South
        self.magneticLngDirection = (self.longitude! >= 0) ? Magnetic.East:Magnetic.West
        
        let coordinates = CLLocationCoordinate2DMake(latitude!, longitude!)
        
        self.directionToTarget(coordinates)
    }
    
    func degreesToRadians(degrees:Double) -> Double{
        return (degrees)/(180 * M_PI)
    }
    
    func radiansToDegrees(radians:Double) -> Double{
        return (radians)*(180 / M_PI)
    }
    
    func directionToTarget(target:CLLocationCoordinate2D)
    {
        let dLon = self.degreesToRadians(target.longitude - (self.originLocation?.longitude)!)
        let lat1 = degreesToRadians(target.latitude)
        let lat2 = degreesToRadians((self.originLocation?.latitude)!)
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1)*sin(lat2) -
            sin(lat1)*cos(lat2)*cos(dLon);
        
        var brng = radiansToDegrees(atan2(y, x));
        
        if(brng<0) {
            brng=360-fabs(brng);
        }
        
        self.headingQuadFromHeading(brng)

    }
    
    func headingQuadFromHeading(heading:Double){
        if (heading < Magnetic_Direction.North) {
            self.headingQuadrant = HeadingQuadrant.UNKNOWN;
            return;
        }
        
        if (heading >= Magnetic_Direction.North && heading <= Magnetic_Direction.East) {
            self.headingQuadrant = HeadingQuadrant.NE;
            return;
        }
        
        if (heading >= Magnetic_Direction.East && heading <= Magnetic_Direction.South) {
            self.headingQuadrant = HeadingQuadrant.SE;
            return;
        }
        
        if (heading >= Magnetic_Direction.South && heading <= Magnetic_Direction.West) {
            self.headingQuadrant = HeadingQuadrant.SW;
            return;
        }
        
        if (heading >= Magnetic_Direction.West) {
            self.headingQuadrant = HeadingQuadrant.NW;
            return;
        }

    }
    
    class func headingQuad(heading:Double) -> HeadingQuadrant{
        
        var headingQuad:HeadingQuadrant = HeadingQuadrant.NE
        
        if (heading < Magnetic_Direction.North) {
            headingQuad = HeadingQuadrant.UNKNOWN;
            
            return headingQuad
        }
        
        if (heading >= Magnetic_Direction.North && heading <= Magnetic_Direction.East) {
            headingQuad = HeadingQuadrant.NE;
            
            return headingQuad

        }
        
        if (heading >= Magnetic_Direction.East && heading <= Magnetic_Direction.South) {
            headingQuad = HeadingQuadrant.SE;
            
            return headingQuad

        }
        
        if (heading >= Magnetic_Direction.South && heading <= Magnetic_Direction.West) {
            headingQuad = HeadingQuadrant.SW;
            
            return headingQuad

        }
        
        if (heading >= Magnetic_Direction.West) {
            headingQuad = HeadingQuadrant.NW;
            
            return headingQuad

        }
        
        return HeadingQuadrant.UNKNOWN
        
    }

    
    class func getDirectionString(quad:HeadingQuadrant) -> String
    {
        var quadrantName = "UNKNOWN"
        
        switch quad{
        case HeadingQuadrant.NE:
            quadrantName = "North-East"
        case HeadingQuadrant.NW:
            quadrantName = "North-West"
            
        case HeadingQuadrant.SE:
            quadrantName = "South-East"
            
        case HeadingQuadrant.SW:
            quadrantName = "South-West"
            
        default:
            quadrantName = "Unknown Quadrant"
            
        }
        
        return quadrantName
    }

    func getInfo() -> String?
    {
        let infoString:String = "Name: \(self.name!) \n Group:\(self.group!) \n \(self.address!),\n\(self.city!),\(self.state!),\(self.country!)-\(self.pCode!), \n Distnace: \(self.distance!) \(self.distanceUnit!)"
        
        return infoString
    }
}
