//
//  BackgroundViewController.swift
//  Bored Events
//
//  Created by Srividhya Gopalan on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import MapKit

class BackgroundViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var eventTitle: String?
    var eventImage: UIImage?
    var eventStartTime: NSDate?
    var eventEndTime: NSDate?
    var backgroundImage: UIImage?
    var eventCoordinates: CLLocationCoordinate2D?
    var eventLocation: String?
    var eventSummary: String?
    var imagePicker = UIImagePickerController()
    
    var backImage: UIImage?

    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imgeView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var imageView5: UIImageView!
    
    @IBOutlet weak var imageView6: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action:Selector("image1Tapped"))
        var tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:Selector("image2Tapped"))
        var tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action:Selector("image3Tapped"))
        var tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action:Selector("image4Tapped"))
        var tapGestureRecognizer5 = UITapGestureRecognizer(target:self, action:Selector("image5Tapped"))
        var tapGestureRecognizer6 = UITapGestureRecognizer(target:self, action:Selector("image6Tapped"))
        imageView1.addGestureRecognizer(tapGestureRecognizer1)
        imageView2.addGestureRecognizer(tapGestureRecognizer2)
        imgeView3.addGestureRecognizer(tapGestureRecognizer3)
        imageView4.addGestureRecognizer(tapGestureRecognizer4)
        imageView5.addGestureRecognizer(tapGestureRecognizer5)
        imageView6.addGestureRecognizer(tapGestureRecognizer6)
        // Do any additional setup after loading the view.
    }
    
    func image1Tapped () {
        backImage = imageView1.image
        imageView1.highlighted = true
        imageView2.highlighted = false
        imageView4.highlighted = false
        imageView5.highlighted = false
        imageView6.highlighted = false
        imgeView3.highlighted = false
        
    }
    
    func image2Tapped () {
        imageView2.highlighted = true
        imageView2.highlighted = false
        imageView4.highlighted = false
        imageView5.highlighted = false
        imageView6.highlighted = false
        imgeView3.highlighted = false
        
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
        
        self.imageView2.image = image
        self.backImage = image
    }

    
    func image3Tapped () {
        backImage = imgeView3.image
        imgeView3.highlighted = true
        imageView2.highlighted = false
        imageView4.highlighted = false
        imageView5.highlighted = false
        imageView6.highlighted = false
        imageView1.highlighted = false
        
    }
    
    func image4Tapped () {
        backImage = imageView4.image
        imageView4.highlighted = true
        imageView2.highlighted = false
        imageView1.highlighted = false
        imageView5.highlighted = false
        imageView6.highlighted = false
        imgeView3.highlighted = false
        
    }
    
    func image5Tapped () {
        backImage = imageView5.image
        imageView5.highlighted = true
        imageView2.highlighted = false
        imageView4.highlighted = false
        imageView1.highlighted = false
        imageView6.highlighted = false
        imgeView3.highlighted = false
        
    }
    
    func image6Tapped () {
        backImage = imageView6.image
        imageView6.highlighted = true
        imageView2.highlighted = false
        imageView4.highlighted = false
        imageView5.highlighted = false
        imageView1.highlighted = false
        imgeView3.highlighted = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if eventSummary != nil {
                svc.eventSummary = self.eventSummary
            }
            if eventStartTime != nil {
                svc.eventStartTime = self.eventStartTime
            }
            if eventEndTime != nil {
                svc.eventEndTime = self.eventEndTime
            }
            if self.backImage != nil {
                svc.backgroundImage = self.backImage
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
