//
//  AddEventViewController.swift
//  TemplateProject
//
//  Created by New Account on 7/20/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit
import Parse

class AddEventViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    
    @IBOutlet weak var venueNameField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var adressField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var decriptionView: UITextView!
    @IBOutlet weak var newEventMap: MKMapView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var scrollViewAdd: UIScrollView!
    var locationManager = CLLocationManager()
    @IBOutlet weak var newEventImage: UIImageView!
    var check1: String!
    var check2: String!
    var check3: String!
    var check4: String!
    let addLocationRequest = MKLocalSearchRequest()
    var newEventPlaces: [Place] = []
    var newEventLatitude: Double!
    var newEventLongitude: Double!
    var imagePicker = UIImagePickerController()
    
    //var imagePicker = UIImagePickerController()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollViewAdd.contentSize.height = 1650
        // Do any additional setup after loading the view.
        scrollViewAdd.contentSize.height = 1650
        //myTextField.layer.borderColor
        var myColor : UIColor = UIColor( red: 0.5, green: 0.5, blue:0, alpha: 1.0 )
        decriptionView.textColor = UIColor.lightGrayColor()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        check1 = self.adressField.text
        check2 = self.cityField.text
        check3 = self.stateField.text
        check4 = self.zipcodeField.text
        
        locationManager.delegate = self
        newEventMap.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

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
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        
        
        
        var newPost = PFObject (className:"Post")
        newPost["eventTitle"] = titleTextField.text as String
        newPost["coordinatePoint"] = PFGeoPoint(latitude: newEventLatitude, longitude: newEventLongitude)
        newPost["eventDescription"] = decriptionView.text as String
        newPost["locationName"] = venueNameField.text as String
        newPost["startTime"] = startDatePicker.date
        newPost["endTime"] = endDatePicker.date
        let imageData = UIImageJPEGRepresentation(newEventImage.image! as UIImage, 0.8)
        let imageFile = PFFile(data: imageData)
        newPost["imageFile"] = imageFile
        
        newPost.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                //println("activity saved")
            } else {
                println("activity not saved")
            }
            
        }
    }
    
    @IBAction func addImageButtonTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            //println("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        self.newEventImage.image = image
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        //println("hit method")
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
        
        if self.adressField.text != check1 && self.cityField.text != check2 && self.stateField.text != check3 && self.zipcodeField.text != check4 {
            
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
                    self.newEventLatitude = self.newEventPlaces[0].coordinate.latitude
                    self.newEventLongitude = self.newEventPlaces[0].coordinate.longitude
                }
            })
            
        }
    }
}