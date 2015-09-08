//
//  MyEventsViewController.swift
//  Bored Events
//
//  Created by Srividhya Gopalan on 8/12/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class MyEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    var userEvents: [PFObject] = []
    var count = 0
    
    var eventTitle: String!
    var eventSummary: String!
    var eventImage: UIImage!
    var eventStartTime: NSDate!
    var eventEndTime: NSDate!
    var newObj: PFObject!
    //var backgroundImage = self.backgroundImage
    var eventCoordinates: CLLocationCoordinate2D!
    var eventLocation: String!
    var viewTitleString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.whereKey("toUser", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.userEvents = result as! [PFObject]
            println(self.userEvents.count)
            println("count of nearbyEvents")
            self.count = 1
            self.tableView.reloadData()
        }

//        while count < 1 {
//            
//        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userEvents.count == 0 {
            return 1
        }
        return userEvents.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if self.userEvents.count > 0 {
        eventTitle = self.userEvents[indexPath.row]["eventTitle"] as! String
        eventSummary = self.userEvents[indexPath.row]["eventDescription"] as! String
        var img = self.userEvents[indexPath.row]["imageFile"] as! PFFile
        var img2 = img.getData()
        eventImage = UIImage(data: img2!)
        eventStartTime = self.userEvents[indexPath.row]["startTime"] as! NSDate
        eventEndTime = self.userEvents[indexPath.row]["endTime"] as! NSDate
        //var backgroundImage = self.backgroundImage
        eventCoordinates = CLLocationCoordinate2D (latitude: self.userEvents[indexPath.row]["coordinatePoint"]!.latitude as Double, longitude: self.userEvents[indexPath.row]["coordinatePoint"]!.longitude as Double)
        eventLocation  = self.userEvents[indexPath.row]["locationName"] as! String
        newObj = self.userEvents[indexPath.row] as PFObject
        var newString = "Edit: "
        newString = newString + eventTitle
        viewTitleString = newString
        
        self.performSegueWithIdentifier("editEvent", sender: self)
        } else {
            self.performSegueWithIdentifier("howToAddEvent", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var thing = userEvents[indexPath.row] as PFObject
            thing.delete()

        }
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.whereKey("toUser", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.userEvents = result as! [PFObject]
            println(self.userEvents.count)
            println("count of nearbyEvents")
            self.count = 1
            self.tableView.reloadData()
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        
        if userEvents.count > 0 {
            let row = indexPath.row
            cell.textLabel?.text = userEvents[row]["eventTitle"] as! String
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        else {
            cell.textLabel?.text = "You don't have any events :("
            //cell.textLabel?.font = UIFont.systemFontOfSize(10)
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        PFUser.logOut()
        if PFUser.currentUser() == nil {
            println("logged out")
            tableView.reloadData()
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "editEvent") {
            //backgroundMusic.stop()
            var svc = segue.destinationViewController as! AddNewEventViewController;
                svc.eventTitleS = self.eventTitle
                svc.eventImage = self.eventImage
                svc.eventSummary = self.eventSummary
                svc.eventStartTime = self.eventStartTime
                svc.eventEndTime = self.eventEndTime
                //svc.backgroundImage = self.backgroundImage
                svc.eventCoordinates = self.eventCoordinates
                svc.eventLocation = self.eventLocation
                svc.newObj = self.newObj
                svc.viewTitleString = self.viewTitleString
                println("hgh")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
