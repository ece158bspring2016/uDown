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


    //Variables for UI inputs
    @IBOutlet weak var range: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var time: UITextField!
    let ref = FIRDatabase.database().reference() //reference to firebase db
    
    //Initialize gps variables
    let locationManager = CLLocationManager()
    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0

    //If new activity is selected in activity view controller, update it in search create view
    @IBOutlet weak var activityButton: UIButton!
    var activity:String = "Grab Food" {
        didSet {
            activityButton.setTitle(activity, forState: UIControlState.Normal)
        }
    }
    var activityEmoji:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //Get user location
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

        //Get current user information
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                id = profile.uid;  // Provider-specific UID
                name = profile.displayName!
            }
            uid = user.uid
            //newSearchRef.child("user").setValue(["uid": uid, "id": id, "displayName": name])
        }

        //Variable to hold search information
        let newSearch : [String : String] = [
            "activityName": activity,
            "activityEmoji": activityEmoji,
            "where": place.text!,
            "range": range.text!,
            "latitude": latitude.description,
            "longitude": longitude.description,
            
            "user_uid": uid,
            "user_id": id,
            "user_displayName": name,
            
            "activityTime": time.text!,
            "searchTime": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle),

        ]
        let newSearchRef = ref.child("searches").childByAutoId()
        newSearchRef.setValue(newSearch)
    
        //Add searches of current user
        let usersSearch: [String: String] = [
            "activityName": activity,
            "activityEmoji": activityEmoji,
            "searchTime": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle),
        ]
        
        ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("searches").child(newSearchRef.key).setValue(usersSearch)
        
        
        var matches = 0
        //Get all searches in the db and loop over all searches
        ref.child("searches").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                let searchKey = snapshot.childSnapshotForPath(child.key).key
                let searchDict = snapshot.childSnapshotForPath(child.key).value as! [String : AnyObject]
                print(searchDict)
                print("Compare: \(searchKey) to \(newSearchRef.key)")
                if(searchKey != newSearchRef.key && searchDict["activityName"] as! String == self.activity){
                    let currentLoc = CLLocation(latitude: self.latitude, longitude: self.longitude)
                    let searchLat = Double(searchDict["latitude"] as! String)
                    let searchLong = Double(searchDict["longitude"] as! String)
                    let searchLoc = CLLocation(latitude: searchLat!, longitude: searchLong!)
                    let distance = currentLoc.distanceFromLocation(searchLoc)
                    print("Comparing \(searchDict["searchTime"]): \(distance) to \(self.range.text)")
                    
                    //If search location is within range of search a match is found!
                    if(distance < Double(self.range.text!) && distance < Double(searchDict["range"] as! String)){
                        print("Match found! We are in range")
                        matches += 1 //increment number of matches
                        
                        //Information for new chat
                        let newMessage: [String: String] = [
                            "senderId": "uDownasdf",
                            "text": "Hey! We matched!"
                        ]
                        
                        //Start a new chat
                        let newMessageRef = self.ref.child("messages").childByAutoId()
                        newMessageRef.childByAutoId().setValue(newMessage)
                        
                        //Get current users matches
                        let myMatched: [String: String] = [
                            "receiverUid": searchDict["user_uid"] as! String,
                            "receiverId": searchDict["user_id"] as! String,
                            "receiverName": searchDict["user_displayName"] as! String,
                            "where": searchDict["where"] as! String,
                            "activityTime": searchDict["activityTime"] as! String,
                            "latitude": searchDict["latitude"] as! String,
                            "longitude": searchDict["longitude"] as! String,
                            "match": "my",
                            "messages": newMessageRef.key,
                            "matchTime": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                        ]
                        
                        //Save users match into db
                        self.ref.child("users").child(uid).child("searches").child(newSearchRef.key).child("matches").child(searchKey).setValue(myMatched)
                        
                        //Variable that holds match for other user
                        let theirMatched: [String: String] = [
                            "receiverUid": uid,
                            "receiverId": id,
                            "receiverName": name,
                            "where": self.place.text!,
                            "activityTime": self.time.text!,
                            "latitude": self.latitude.description,
                            "longitude": self.longitude.description,
                            "match": "their",
                            "messages": newMessageRef.key,
                            "matchTime": NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                        ]
                    
                        //Save other users match into db
                        self.ref.child("users").child(searchDict["user_uid"] as! String).child("searches").child(searchKey).child("matches").child(newSearchRef.key).setValue(theirMatched)
                        
                        //newSearchRef.child("matches").child(child.key).setValue(myMatched)
                        //self.ref.child("searches").child(child.key).child("matches").child(newSearchRef.key).setValue(theirMatched)
                    }
                }
            }
            //If matches found then send alert.
            if(matches > 1)
            {
                let myMessage = "Found \(matches) matches!"
                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(myAlert, animated: true, completion: nil)
            }
            else if(matches == 1)
            {
                let myMessage = "Found \(matches) match!"
                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(myAlert, animated: true, completion: nil)
            }
           
            
            
        })
    }
    
    //Used by CoreLocation to get users latitude and longitude
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //If cancel is clicked
    @IBAction func cancelToSearchCreateViewController(segue:UIStoryboardSegue) {
    }
    
    
    //If done is clicked
    @IBAction func doneSearchCreateViewController(segue:UIStoryboardSegue) {
        if let activityPickerViewController = segue.sourceViewController as? ActivityPickerViewController,
            selectedActivity = activityPickerViewController.selectedActivity,
            selectedActivityEmoji = activityPickerViewController.selectedActivityEmoji{
                activity = selectedActivity
                activityEmoji = selectedActivityEmoji
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
