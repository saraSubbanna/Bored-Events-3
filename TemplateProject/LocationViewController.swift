//
//  LocationViewController.swift
//  Bored Events
//
//  Created by Srividhya Gopalan on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,UITextFieldDelegate {
    
    var eventTitle: String?
    var eventImage: UIImage?
    var eventStartTime: NSDate?
    var eventEndTime: NSDate?
    var eventSummary: String?
    var backgroundImage: UIImage?
    var eventCoordinates: CLLocationCoordinate2D?
    var eventLocation: String?

    @IBOutlet weak var venueNameField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var adressField: UITextField!
    var locationManager = CLLocationManager()
    @IBOutlet weak var newEventMap: MKMapView!
    
    var check1: String!
    var check2: String!
    var check3: String!
    var check4: String!
    
    let addLocationRequest = MKLocalSearchRequest()
    var newEventPlaces: [Place] = []
    var newEventLatitude: Double!
    var newEventLongitude: Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        check1 = self.adressField.text
        check2 = self.cityField.text
        check3 = self.stateField.text
        check4 = self.zipcodeField.text
        
        adressField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipcodeField.delegate = self
        venueNameField.delegate = self
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        locationManager.delegate = self
        newEventMap.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if eventCoordinates != nil {
            newEventPlaces.insert(Place(coordinate: eventCoordinates!, title: eventLocation, subtitle: nil), atIndex: 0)
            newEventMap.addAnnotation(newEventPlaces[0])
        }
        venueNameField.text = eventLocation ?? ""
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.venueNameField.endEditing(true)
        self.zipcodeField.endEditing(true)
        self.cityField.endEditing(true)
        self.stateField.endEditing(true)
        self.adressField.endEditing(true)
        return false
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let location1 = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error")
    }
    
    @IBAction func addressEditEnd(sender: AnyObject) {
        printCurrentLoc()
        adressField.resignFirstResponder()
        showLocation()
    }
    
    @IBAction func stateEditEnd(sender: AnyObject) {
        printCurrentLoc()
        stateField.resignFirstResponder()
        showLocation()
    }
    
    @IBAction func cityEditEnd(sender: AnyObject) {
        printCurrentLoc()
        cityField.resignFirstResponder()
        showLocation()
    }
    
    @IBAction func zipEditEnd(sender: AnyObject) {
        printCurrentLoc()
        zipcodeField.resignFirstResponder()
        showLocation()
    }
    
    func printCurrentLoc () {
        println(self.adressField.text)
        println(self.stateField.text)
        println(self.cityField.text)
        println(self.zipcodeField.text)
    }
    
    func showLocation () {
        var totalLocale: String!
        
       // if self.adressField.text != check1 && self.cityField.text != check2 && self.stateField.text != check3 && self.zipcodeField.text != check4 {
            
            if newEventPlaces != [] {
                self.newEventMap.removeAnnotation(self.newEventPlaces[0])
                self.newEventPlaces = []
            }
            totalLocale = self.adressField.text + " " + self.cityField.text + " " + self.stateField.text + " " + self.zipcodeField.text
            
            addLocationRequest.naturalLanguageQuery = totalLocale
            addLocationRequest.region = newEventMap.region
            
            let search = MKLocalSearch(request: addLocationRequest)
            
            search.startWithCompletionHandler({(response: MKLocalSearchResponse!,
                error: NSError!) in
                
                if error != nil {
                    println("Error occured in search: \(error.localizedDescription)")
                } else if response.mapItems.count == 0 {
                    println("No matches found")
                } else {
                    //println("Matches found")
                    
                    for item in response.mapItems as! [MKMapItem] {
                        //println("Name = \(item.name)")
                        //println("Phone = \(item.phoneNumber)")
                        var coordinates: CLLocationCoordinate2D =  CLLocationCoordinate2D (latitude: item.placemark.location.coordinate.latitude, longitude: item.placemark.location.coordinate.longitude)
                        var addLocation: Place =  Place(coordinate: coordinates, title: nil, subtitle: nil)
                        self.newEventPlaces.append(addLocation)
                    }
                }
                if self.newEventPlaces != []{
                    self.newEventMap.addAnnotation(self.newEventPlaces[0])
                    //self.newEventLatitude = self.newEventPlaces[0].coordinate.latitude
                    //self.newEventLongitude = self.newEventPlaces[0].coordinate.longitude
                }
            })
            
      //  }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "doneLoc") {
            //backgroundMusic.stop()
            var svc = segue.destinationViewController as! AddNewEventViewController;
            if eventTitle != nil {
                svc.eventTitleS = self.eventTitle
            }
            if eventImage != nil {
                svc.eventImage = self.eventImage
            }
            if eventSummary != nil {
                svc.eventSummary = self.eventSummary
            }
            if eventStartTime != nil {
                svc.eventStartTime = self.eventStartTime
            }
            if eventEndTime != nil {
                svc.eventEndTime = self.eventEndTime
            }
            if backgroundImage != nil {
                svc.backgroundImage = self.backgroundImage
            }
            if self.newEventLongitude != nil {
                svc.eventCoordinates = CLLocationCoordinate2D(latitude: newEventLatitude, longitude: newEventLongitude)
            }
            if self.venueNameField != nil {
                svc.eventLocation = self.adressField.text + " " + self.cityField.text + " " + self.stateField.text + " " + self.zipcodeField.text
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
