//
//  AddNewEventViewController.swift
//  Bored Events
//
//  Created by Srividhya Gopalan on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit
import Parse

class AddNewEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textView: UIImageView!
    @IBOutlet weak var dateView: UIImageView!
    @IBOutlet weak var locationView: UIImageView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var eventTitle: UITextField!
    var eventSummary: String?
    var viewTitleString: String?
    @IBOutlet weak var viewTitle: UILabel!
    var newObj: PFObject?

    @IBOutlet weak var eventImageField: UIImageView!
    var eventImage: UIImage?
    var eventStartTime: NSDate?
    var eventEndTime: NSDate?
    var backgroundImage: UIImage?
    var eventCoordinates: CLLocationCoordinate2D?
    var eventLocation: String?
    var eventTitleS: String?
    var imagePicker = UIImagePickerController()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitle.delegate = self
        eventTitle.text = eventTitleS
        if eventImage != nil {
            eventImageField.image = eventImage
        }
        eventImage = eventImageField.image!
        if eventSummary != nil {
            println(eventSummary!)
        }
        if newObj == nil {
            xButton.hidden = true
        }
        if viewTitleString != nil {
            viewTitle.text = viewTitleString
        }
        if eventLocation != nil && eventCoordinates != nil {
            locationView.hidden = false
        }
        else {
            locationView.hidden = true
        }
        if eventEndTime != nil && eventStartTime != nil {
            dateView.hidden = false
        }
        else {
            dateView.hidden = true
        }
        if eventSummary != nil {
            textView.hidden = false
        }
        else {
            textView.hidden = true
        }
        //eventTitle.placeholder.textColor = UIColor.whiteColor() // FIX THIS SARA!
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        self.view.endEditing(true)
        return false
    }
    
    @IBAction func xButtonTapped(sender: AnyObject) {
        let myAlertControler = UIAlertController(title: "Cancel", message: "Would you like to cancel this event?", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            //Do the stuff if they are like wait I want a password
        }
        
        myAlertControler.addAction(cancelAction)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            
            self.newObj?.delete()
            self.performSegueWithIdentifier("eventDeleted", sender: nil)
        }
        
        myAlertControler.addAction(yesAction)
        
        //myAlertControler.addTextFieldWithConfigurationHandler { textField -> Void in
        //println("generating the TextField")
        //textField.placeholder = "Enter a password"
        //self.tField = textField
        self.presentViewController(myAlertControler, animated: true, completion: nil)

    }

    @IBAction func createButtonTapped(sender: AnyObject) {
        if newObj != nil {
            var newPost = PFObject (className:"Post")
            newPost["eventTitle"] = eventTitle.text as String
            let myLocation = CLLocation(latitude: eventCoordinates!.latitude ?? 37.81, longitude: eventCoordinates!.longitude ?? -122.41)
            var newLoc = PFGeoPoint(location: myLocation)
            newPost["toUser"] = PFUser.currentUser()
            newPost["coordinatePoint"] = newLoc
            println(eventSummary)
            newPost["eventDescription"] = self.eventSummary as String!
            newPost["locationName"] = self.eventLocation
            newPost["startTime"] = self.eventStartTime
            newPost["endTime"] = self.eventEndTime
            newPost["Flags"] = 0
            let imageData = UIImageJPEGRepresentation(self.eventImage! as UIImage, 0.8)
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
                newObj?.delete()
        } else if eventTitle != nil && eventStartTime != nil && eventSummary != nil && eventEndTime != nil && eventImage != nil && eventCoordinates != nil && eventLocation != nil {
            
            var newPost = PFObject (className:"Post")
            newPost["eventTitle"] = eventTitle.text as String
            let myLocation = CLLocation(latitude: eventCoordinates!.latitude ?? 37.81, longitude: eventCoordinates!.longitude ?? -122.41)
            var newLoc = PFGeoPoint(location: myLocation)
            newPost["toUser"] = PFUser.currentUser()
            newPost["coordinatePoint"] = newLoc
            println(eventSummary)
            newPost["eventDescription"] = self.eventSummary as String!
            newPost["locationName"] = self.eventLocation
            newPost["startTime"] = self.eventStartTime
            newPost["endTime"] = self.eventEndTime
            newPost["Flags"] = 0
            let imageData = UIImageJPEGRepresentation(self.eventImage! as UIImage, 0.8)
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
        else {
            let myAlertControler = UIAlertController(title: "Uh-oh", message: "You must complete all fields to add an event", preferredStyle: .Alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Back", style: .Cancel) { action -> Void in
                //Do the stuff if they are like wait I want a password
            }
            
            myAlertControler.addAction(cancelAction)
            
            //myAlertControler.addTextFieldWithConfigurationHandler { textField -> Void in
            println("generating the TextField")
            //textField.placeholder = "Enter a password"
            //self.tField = textField
            self.presentViewController(myAlertControler, animated: true, completion: nil)
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
        
        self.eventImageField.image = image
        self.eventImage = image
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toAddDate") {
            //backgroundMusic.stop()
            var svc = segue.destinationViewController as! DateViewController;
            if eventTitle.text != nil {
                svc.eventTitle = self.eventTitle.text
            }
            if eventImageField.image != nil {
                svc.eventImage = self.eventImageField.image
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
            if eventCoordinates != nil {
                svc.eventCoordinates = self.eventCoordinates
            }
            if eventLocation != nil {
                svc.eventLocation = self.eventLocation
            }
        }
        if (segue.identifier == "toAddLocation") {
            //backgroundMusic.stop()

            var svc = segue.destinationViewController as! LocationViewController;
            if eventTitle.text != nil {
                svc.eventTitle = self.eventTitle.text
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
            if eventCoordinates != nil {
                svc.eventCoordinates = self.eventCoordinates
            }
            if eventLocation != nil {
                svc.eventLocation = self.eventLocation
            }
        }
        if (segue.identifier == "toAddBackground") {
            //backgroundMusic.stop()
            var svc = segue.destinationViewController as! BackgroundViewController;
            if eventTitle.text != nil {
                svc.eventTitle = self.eventTitle.text
            }
            if eventImageField.image != nil {
                svc.eventImage = self.eventImageField.image
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
            if eventCoordinates != nil {
                svc.eventCoordinates = self.eventCoordinates
            }
            if eventLocation != nil {
                svc.eventLocation = self.eventLocation
            }
        }
        if (segue.identifier == "toAddDescription") {
            //backgroundMusic.stop()
            var svc = segue.destinationViewController as! DescriptionViewController;
            if eventTitle.text != nil {
                svc.eventTitle = self.eventTitle.text
            }
            if eventImageField.image != nil {
                svc.eventImage = self.eventImageField.image
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
            if eventCoordinates != nil {
                svc.eventCoordinates = self.eventCoordinates
            }
            if eventLocation != nil {
                svc.eventLocation = self.eventLocation
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
