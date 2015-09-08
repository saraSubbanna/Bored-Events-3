//

//  Event.swift

//  TemplateProject

//

//  Created by XCode-do not delete on 7/31/15.

//  Copyright (c) 2015 Make School. All rights reserved.

//



import CoreLocation
import Foundation
import UIKit
import MapKit
import Foundation
import SwiftHTTP
import SwiftyJSON
typealias UIUpdate = (UIImage)->Void

class Event {
    
    var title: String
    var summary: String
    var location: String?
    var coordinates: CLLocationCoordinate2D?
    var timeRange: String
    var logo: UIImage?
    var logoId: String!
    var venueId: String!
    var count = 0;
    
    init(gtitle: String, gsummary: String, glocation: String?, gvenueId: String?, gtimeRange: String, gcoordinates: CLLocationCoordinate2D?, glogo: UIImage?, glogoId: String?) {
        
        self.title = gtitle
        self.summary = gsummary
        self.location = glocation
        self.timeRange = gtimeRange
        self.coordinates = gcoordinates
        self.logo = glogo
        self.logoId = glogoId
        self.venueId = gvenueId
        
        // super.init()
    }
    
    func beingDisplayed(updateUI:UIUpdate) {
        
        var check = false
        var check2 = false
        
        var reqUrl = "https://www.eventbriteapi.com/v3/venues/10584840/?token=CG4UGPP3K64F5ERBP6"
        reqUrl = "https://www.eventbriteapi.com/v3/venues/"
        reqUrl = reqUrl + venueId! + "/?token=PXG7KJFVKLEEYDRIH3"
        
        //println(venueId!)
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Bearer HAMN4635LP26YWCD2NNP"
        
        request.GET(reqUrl, parameters: nil, completionHandler: {(request: HTTPResponse) in
            
            if let err = request.error {
                println("error: \(err.localizedDescription)")
                self.location = "Uavaliable"
                self.logo = nil
                self.coordinates = CLLocationCoordinate2D(latitude: 37.3382, longitude: 121.8863)
            }
            
            if var data = request.responseObject as? NSData {
                let json = JSON(data: data)
                //println(json["name"])
                let subJson = json["address"]["address_1"]
                let subJson2 =  json["address"]["address_2"]
                self.location = subJson.stringValue + subJson2.stringValue
                var locLat = json["latitude"].stringValue
                var locLong = json["longitude"].stringValue
                self.coordinates = CLLocationCoordinate2D(latitude: (locLat as NSString).doubleValue, longitude: (locLong as NSString).doubleValue)
                println("\(locLat as NSString): latitude, \(locLong as NSString): longitude")
                if (self.coordinates != nil){
                    println("exists")
                }
                check = true
            }
        })
        
        var request2 = HTTPTask()
        request2.requestSerializer = HTTPRequestSerializer()
        request2.requestSerializer.headers["Authorization"] = "Bearer HAMN4635LP26YWCD2NNP"
        if logoId != nil && logoId != "" {
            var reqUrl = "https://www.eventbriteapi.com/v3/media/" + logoId + "/?token=PXG7KJFVKLEEYDRIH3"
            //println(reqUrl)
            //println()
            
            request2.GET(reqUrl, parameters: nil, completionHandler: {(request: HTTPResponse) in
                
                if let err = request.error {
                    println("error: \(err.localizedDescription)")
                }
                
                if var data = request.responseObject as? NSData {
                    
                    let json = JSON(data: data)
                    
                    var imageURL = json["url"].stringValue
                    
                    if let url = NSURL(string: imageURL){
                        if let data = NSData(contentsOfURL: url){
                            self.logo = UIImage(data: data)
                            updateUI(self.logo!)
                        }
                    }
                }
                var check2 = true
            })
        }
        
    }
}