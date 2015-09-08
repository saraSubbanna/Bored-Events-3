//
//  DateViewController.swift
//  Bored Events
//
//  Created by Srividhya Gopalan on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit

class DateViewController: UIViewController {
    
    var eventTitle: String?
    var eventImage: UIImage?
    var eventStartTime: NSDate?
    var eventEndTime: NSDate?
    var eventSummary: String?
    var backgroundImage: UIImage?
    var eventCoordinates: CLLocationCoordinate2D?
    var eventLocation: String?
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var startDate: NSDate?
    var endDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if eventStartTime != nil {
            startDatePicker.date = eventStartTime!
        }
        if eventEndTime != nil {
            endDatePicker.date = eventEndTime!
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        startDate = startDatePicker.date
        endDate = endDatePicker.date
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "doneDate") {
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
            if self.endDate != nil && startDate?.timeIntervalSinceNow < endDate?.timeIntervalSinceNow {
                
                println(startDate?.timeIntervalSinceNow)
                println(endDate?.timeIntervalSinceNow)
                svc.eventEndTime = self.endDate
                svc.eventStartTime = self.startDate
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
