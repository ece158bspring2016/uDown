//
//  SearchCreateViewController.swift
//  uDown
//
//  Created by Oscar Pan on 5/29/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class SearchCreateViewController: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var range: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var time: UITextField!
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()
    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0

    @IBOutlet weak var activityButton: UIButton!
    var activity:String = "Grab Food" {
        didSet {
            activityButton.setTitle(activity, forState: UIControlState.Normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func search(sender: AnyObject) {
        
        var id:String = ""
        var uid:String = ""
        var name:String = ""


        let newSearch : [String : String] = [
            "name": activity,
            "where": place.text!,
            "range": range.text!,

            "activityTime": time.text!,
            "searchTime": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle),

        ]
        let newSearchRef = ref.child("searches").childByAutoId()
        newSearchRef.setValue(newSearch as AnyObject)
        newSearchRef.child("location").setValue(["latitude": latitude.description, "longitude": longitude.description])

        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                id = profile.uid;  // Provider-specific UID
                name = profile.displayName!
            }
            uid = user.uid
            newSearchRef.child("user").setValue(["uid": uid, "id": id, "displayName": name])
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToSearchCreateViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func doneSearchCreateViewController(segue:UIStoryboardSegue) {
        if let activityPickerViewController = segue.sourceViewController as? ActivityPickerViewController,
            selectedActivity = activityPickerViewController.selectedActivity {
                activity = selectedActivity
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
