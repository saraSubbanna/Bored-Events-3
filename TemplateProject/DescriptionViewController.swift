//
//  DescriptionViewController.swift
//  Bored Events
//
//  Created by Srividhya Gopalan on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit
import SwiftHTTP
import SwiftyJSON

class DescriptionViewController: UIViewController {
    
    var eventTitle: String?
    var eventImage: UIImage?
    var eventStartTime: NSDate?
    var eventEndTime: NSDate?
    var backgroundImage: UIImage?
    var eventCoordinates: CLLocationCoordinate2D?
    var eventLocation: String?
    var eventSummary: String?
    @IBOutlet weak var summaryTextField: UITextView!
    var eventSummaryS: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if eventSummary != nil {
            summaryTextField.text = eventSummary!
        }
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func DismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        eventSummaryS = summaryTextField.text
        println(eventSummaryS)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "finished") {
            //backgroundMusic.stop()
            var svc = segue.destinationViewController as! AddNewEventViewController;
            if eventTitle != nil {
                svc.eventTitleS = self.eventTitle
            }
            if eventImage != nil {
                svc.eventImage = self.eventImage
            }
            if eventSummaryS != nil && eventSummaryS != "" {
                svc.eventSummary = self.eventSummaryS
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
