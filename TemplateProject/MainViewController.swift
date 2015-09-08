
//
//  ViewController.swift
//  TemplateProject
//
//  Created by Sara Subbanna on 7/9/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import MapKit
import SwiftHTTP
import SwiftyJSON
import CoreLocation // take out if necessary

class MainViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    

    @IBOutlet weak var eventsLoading: UIActivityIndicatorView!
    @IBOutlet weak var thisVIew: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var userLatitude: String!
    var userLongitude: String!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    let filter = CIFilter(name: "CIPhotoEffectTransfer")
    var extent: CGRect!

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 100000
    var dateFormatter = NSDateFormatter()
    var dontShowUsers = ["What", "No"]
    var nearbyEvents: [Event]! = []
    var nearbyParseEvents: [PFObject]! = []
    var count = 0
    var places: [Place] = []
    let locationRequest = MKLocalSearchRequest()
    var address: String!
    var scaleFactor: CGFloat!
    
    override func viewDidLoad() {
        
        //getEventful()
        eventsLoading.startAnimating()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //descriptionLabel.frame = CGRectMake(0 , 0, screenWidth, 233)
        
        super.viewDidLoad()
        scrollView.contentSize.height = 1000
        println(screenWidth)
        //scrollView.contentSize.width = screenWidth
        
        println(scrollView.contentSize.width)
        //self.thisVIew.frame = CGRectMake(0 , 0, screenWidth, 1070)
        println(thisVIew.frame.width)

        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        var farthestTimePoint = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.CalendarUnitHour,
            value: 36,
            toDate: NSDate(),
            options: NSCalendarOptions.WrapComponents)
        
        if nearbyEvents.count < 3{
            let query = PFQuery(className: "Post")
            query.orderByDescending("createdAt")
            //var geo = PFGeoPoint
            //query.whereKey("coordinatePoint", nearGeoPoint: PFGeoPoint, withinMiles: <#Double#>)
            query.whereKey("endTime", greaterThanOrEqualTo: NSDate()) //PUT THESE BACK IN LATER
            query.whereKey("startTime", lessThanOrEqualTo: farthestTimePoint!) //PUT THESE BACK IN LATER
            query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
                self.nearbyParseEvents = result as! [PFObject]
                println(self.nearbyParseEvents.count)
                println("count of nearbyEvents")
            
//                self.getParse()
//                self.getEventbrite()
//                self.displayScreenAlso()
                
            }
        }
        
        //println(self.nearbyParseEvents.count)
        //println("food")
        
    }
    
    func getReady () {
        self.getParse()
        self.getEventbrite()
        self.displayScreenAlso()
        println(self.nearbyEvents.count)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation: CLLocation = locations[0] as! CLLocation
        userLatitude = String(stringInterpolationSegment: userLocation.coordinate.latitude)
        userLongitude = String(stringInterpolationSegment: userLocation.coordinate.longitude)
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(2.5, 2.5)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        if nearbyEvents.count <= 0 {
            getReady()
        }
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        self.acivityIndicator.startAnimating()
        //println("count is \(count) and the number of events is \(self.nearbyEvents.count)")
        if count < nearbyEvents.count - 1 {
            count++
        }
        else {
            count = 0
        }
        self.displayScreenAlso()
        self.locationLabel.text = ""
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error \(error.localizedDescription)")
    }
    
    
    
    func displayScreenAlso() {
        
        if eventsLoading.isAnimating() == true {
            eventsLoading.stopAnimating()
        }
        var finished = 0
        while nearbyEvents.count == 0 {
            //println(nearbyEvents.count)
        }
        let currentObject = self.nearbyEvents[count]
        descriptionLabel.text = currentObject.summary
        titleLabel.text = currentObject.title
        startTime.text = currentObject.timeRange
        
        if currentObject.location == nil {

            currentObject.beingDisplayed(){ image in
                if self.eventImage.image != nil {
                    self.eventImage.image = image
//                    var context = CIContext(options: nil)
//                    self.scaleFactor = UIScreen.mainScreen().scale
//                    self.extent = CGRectApplyAffineTransform(UIScreen.mainScreen().bounds, CGAffineTransformMakeScale (self.scaleFactor!, self.scaleFactor!))
//                    let ciImage = CIImage(image: image)
//                    self.filter.setDefaults()
//                    self.filter.setValue(ciImage, forKey: kCIInputImageKey)
//                    self.eventImage.image = UIImage(CGImage: context.createCGImage(self.filter.outputImage, fromRect: self.extent))
                }
                if currentObject.location != nil {
                    println(currentObject.location)
                    self.locationLabel.text = currentObject.location
                }
                if currentObject.coordinates != nil {
                    var addLocation =  Place(coordinate: CLLocationCoordinate2D (latitude: currentObject.coordinates!.latitude, longitude: currentObject.coordinates!.latitude), title: currentObject.title, subtitle: currentObject.location)
                    self.places.insert(addLocation, atIndex: 0)
                    self.mapView.addAnnotation(self.places[0])
                }
//                if self.places.count > 0 {
//                    self.mapView.removeAnnotation(self.places[0])
//                }
                
                println(self.locationLabel.text)
                
                self.acivityIndicator.stopAnimating()
            }
        } else {
            locationLabel.text = currentObject.location!
            self.eventImage.image = currentObject.logo!
            
//            var context = CIContext(options: nil)
//            self.scaleFactor = UIScreen.mainScreen().scale
//            self.extent = CGRectApplyAffineTransform(UIScreen.mainScreen().bounds, CGAffineTransformMakeScale (self.scaleFactor!, self.scaleFactor!))
//            let ciImage = CIImage(image: currentObject.logo!)
//            self.filter.setDefaults()
//            self.filter.setValue(ciImage, forKey: kCIInputImageKey)
//            self.eventImage.image = UIImage(CGImage: context.createCGImage(self.filter.outputImage, fromRect: self.extent))

            
            //var addLocation: Place =  Place(coordinate: currentObject.coordinates!, title: currentObject.title, subtitle: currentObject.location)
//            if self.places.count > 0 {
//                mapView.removeAnnotation(self.places[0])
//            }
            //self.places.insert(addLocation, atIndex: 0)
            self.mapView.addAnnotation(self.places[0])
            
            acivityIndicator.stopAnimating()
            
            count++

        }

    }

    
    func getTimeRange(startDate: NSDate, endDate: NSDate) -> String {
        var toReturn: String!
        
        dateFormatter.dateFormat = "MM" //format style. Browse online to get a format that fits your needs.
        var monthStartDateString = dateFormatter.stringFromDate(startDate)
        switch monthStartDateString{
        case "01":
            toReturn = "January"
        case "02":
            toReturn = "February"
        case "03":
            toReturn = "March"
        case "04":
            toReturn = "April"
        case "05":
            toReturn = "May"
        case "06":
            toReturn = "June"
        case "07":
            toReturn = "July"
        case "08":
            toReturn = "August"
        case "09":
            toReturn = "September"
        case "10":
            toReturn = "October"
        case "11":
            toReturn = "November"
        case "12":
            toReturn = "December"
        default:
            toReturn = "Unable to get month"
        }
        dateFormatter.dateFormat = " dd, hh:mm"
        var startDateString = dateFormatter.stringFromDate(startDate)
        toReturn = toReturn + startDateString + " - "
        
        dateFormatter.dateFormat = "hh:mm"
        var endDateString = dateFormatter.stringFromDate(endDate)
        //println("")
        toReturn = toReturn + endDateString
        return toReturn
    }

    @IBAction func reportButtonTapped(sender: AnyObject) {
        if count <= nearbyParseEvents.count {
            
            let myAlertControler = UIAlertController(title: "Flag", message: "Would you like to report this event as inappropriate?", preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                //Do the stuff if they are like wait I want a password
            }
            
            myAlertControler.addAction(cancelAction)
            
            let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                let currentObject = self.nearbyParseEvents[self.count]
                currentObject["Flags"] = (currentObject["Flags"] as! Int) + 1
                if currentObject["Flags"] as! Int + 1 >= 3 {
                    currentObject.delete()
                }
                else {
                    currentObject.save()
                }
                self.count = self.count + 1
                self.displayScreenAlso()
            }
            
            myAlertControler.addAction(yesAction)
            
            //myAlertControler.addTextFieldWithConfigurationHandler { textField -> Void in
            //println("generating the TextField")
            //textField.placeholder = "Enter a password"
            //self.tField = textField
            self.presentViewController(myAlertControler, animated: true, completion: nil)
            
            
        }
    }
    
    func getParse() {
            
            for var p = 0; p < self.nearbyParseEvents.count; p++ {
                
                var parseEvent = self.nearbyParseEvents[p]
                println(nearbyParseEvents.count)
                let data = parseEvent["imageFile"]!.getData()
                var parseImage = UIImage(data: data!, scale:1.0)
                
                var toAdd = Event(gtitle: parseEvent["eventTitle"] as! String, gsummary: parseEvent["eventDescription"] as! String!, glocation: parseEvent["locationName"] as! String, gvenueId: nil, gtimeRange: newFunc(parseEvent["startTime"] as! NSDate, endTime: parseEvent["endTime"] as! NSDate, startString: nil, endString: nil)!, gcoordinates: CLLocationCoordinate2D(latitude: parseEvent["coordinatePoint"]!.latitude, longitude: parseEvent["coordinatePoint"]!.longitude), glogo: parseImage!, glogoId: nil)
                
                self.nearbyEvents.append(toAdd)
            }
        //println(self.nearbyEvents.count)
    }
    
    func getEventbrite() {
        
        if nearbyEvents.count < 49 {
        var today: NSDate = NSDate()
        var farthestTimePoint1 = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.CalendarUnitDay,
            value: 1,
            toDate: NSDate(),
            options: NSCalendarOptions.WrapComponents)
        var farthestTimePoint: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.CalendarUnitHour,
            value: 12,
            toDate: farthestTimePoint1!,
            options: NSCalendarOptions.WrapComponents)!
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var todayString = dateFormatter.stringFromDate(today) + "T"
        var farthestDateString = dateFormatter.stringFromDate(farthestTimePoint) + "T"
        
        dateFormatter.dateFormat = "HH:mm:ss"
        
        todayString = todayString + dateFormatter.stringFromDate(today) + "Z"
        farthestDateString = farthestDateString + dateFormatter.stringFromDate(farthestTimePoint) + "Z"
        
        println(todayString)
        println(farthestDateString)
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Bearer HAMN4635LP26YWCD2NNP"
        request.GET("https://www.eventbriteapi.com/v3/events/search/", parameters: ["location.latitude": userLatitude, "location.longitude": userLongitude, "start_date.range_start": todayString, "start_date.range_end": farthestDateString], completionHandler: {(response: HTTPResponse) in
            
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            
            if var data = response.responseObject as? NSData {
                
                let json = JSON(data: data)
                
                
                for var i = 0; i < json["events"].count; i++ {
                    
                    //var ebtimeRange: String = json["events"][i]["start"]["local"].stringValue
                    var ebtimeRange = self.newFunc(nil, endTime: nil, startString: json["events"][i]["start"]["local"].stringValue, endString: json["events"][i]["end"]["local"].stringValue)
                    //ebtimeRange + json["events"][i]["end"]["local"].stringValue
                    
                    var toAdd = Event(gtitle: json["events"][i]["name"]["text"].stringValue, gsummary:
                        json["events"][i]["url"].stringValue + "\n" + json["events"][i]["description"]["text"].stringValue, glocation: nil, gvenueId: json["events"][i]["venue_id"].stringValue, gtimeRange: ebtimeRange!, gcoordinates: nil, glogo: nil, glogoId: json["events"][i]["logo_id"].stringValue)
                    self.nearbyEvents.append(toAdd)
                }
            }
            //println(self.nearbyEvents.count)
        })
        }
        
        //println(nearbyEvents.count)
    }
    
//    func getEventful() {
//        
//        var request = HTTPTask()
//        var reqURL = "http://api.eventful.com/rest/events/search?app_key=Kcd49m9RFC2pbgvL&keywords=books"
//        request.GET(reqURL, parameters: nil, completionHandler: {(response: HTTPResponse) in
//            
//            if let err = response.error {
//                println("error: \(err.localizedDescription)")
//                return //also notify app of failure as needed
//            }
//            
//            if var data = response.responseObject as? NSData {
//                
//                let json = JSON(data: data)
//                
////                
//               //for var i = 0; i < json["events"].count; i++ {
//                println("inside")
//                println(json["total_items"])
////                    var ebtimeRange: String = json["events"][i]["start"]["local"].stringValue
////                    ebtimeRange + json["events"][i]["end"]["local"].stringValue
////                    
////                    var toAdd = Event(gtitle: json["events"][i]["name"]["text"].stringValue, gsummary: json["events"][i]["description"]["text"].stringValue, glocation: nil, gvenueId: json["events"][i]["venue_id"].stringValue, gtimeRange: ebtimeRange, gcoordinates: nil, glogo: nil, glogoId: json["events"][i]["logo_id"].stringValue)
////                    self.nearbyEvents.append(toAdd)
//                //}
//            }
//            //println(self.nearbyEvents.count)
//        })
//        
//        //println(nearbyEvents.count)
//    }
    
    func newFunc (startTime: NSDate?, endTime: NSDate?, startString: String?, endString: String?) -> String? {
        println(startString)
        var dayNum: Int!
        var eventDayNum: Int!
        var toRet: String!
        
        dateFormatter.dateFormat = "d"
        dayNum = dateFormatter.stringFromDate(NSDate()).toInt()
        
        if startTime != nil {
           
            println(dayNum)
            eventDayNum = dateFormatter.stringFromDate(startTime!).toInt()
        } else {
            eventDayNum = startString!.substringWithRange(Range<String.Index>(start: advance (startString!.startIndex, 8), end: advance(startString!.endIndex, -9))).toInt()
            println(eventDayNum)
            
        }
        
        if dayNum == eventDayNum {
            toRet = "Today at "
        }
        if eventDayNum == dayNum + 1 {
            toRet = "Tomorrow at "
        }
        
        if startTime != nil {
            //dateFormatter.dateFormat = "h:mm a"
            //toRet = toRet + dateFormatter.stringFromDate(startTime!)
            dateFormatter.dateFormat = "h"
            var startInt = dateFormatter.stringFromDate(startTime!).toInt()
            if startInt > 12 {
                startInt = startInt! - 12
                toRet = toRet! + String(stringInterpolationSegment: startInt!)
                dateFormatter.dateFormat = ":mm"
                //dateFormatter.stringFromDate(startTime)
                toRet = toRet + dateFormatter.stringFromDate(startTime!)
            }
        }
        else {
            var eventTimeHour = startString!.substringWithRange(Range<String.Index>(start: advance (startString!.startIndex, 11), end: advance(startString!.endIndex, -3)))
            toRet = toRet + eventTimeHour + " - "
        }
        if endTime != nil {
            dateFormatter.dateFormat = "d"
            var endNum = dateFormatter.stringFromDate(endTime!).toInt()
            if endNum == eventDayNum {
                dateFormatter.dateFormat = "h:mm a"
                toRet = toRet + dateFormatter.stringFromDate(endTime!)
            } else {
                toRet = toRet + "The Next Day at "
                dateFormatter.dateFormat = "h:mm a"
                toRet = toRet + dateFormatter.stringFromDate(endTime!)
            }
        }
        else {
            var eventTimeHour = endString!.substringWithRange(Range<String.Index>(start: advance (endString!.startIndex, 11), end: advance(endString!.endIndex, -3)))
            toRet = toRet + eventTimeHour
        }
        
        
        return toRet
    }

    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var view: MKPinAnnotationView?
        if annotation is MKUserLocation {
            println("user")
            return nil
        }
        
        //annotation1 = self.places[0]
        let identifier = "pin"
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            println("Here")
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier:identifier)
            //view!.calloutOffset = CGPoint(x: -5, y: 5)
            println(annotation.coordinate.latitude)
            view!.pinColor = MKPinAnnotationColor.Purple
        }
        return view
    }
    //println("DONE")
    
    
}
