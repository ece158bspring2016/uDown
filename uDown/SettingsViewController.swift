//
//  SettingsViewController.swift
//  uDown
//
//  Created by Ashwin Devendran on 6/7/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet var deleteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), forControlEvents: .TouchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func deleteButtonAction(sender: UIButton!) {
        let _USER_REF = FIRDatabase.database().reference().child("users")
        var userID:String = "nil"
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil
        {
            userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
            let currentUser = _USER_REF.child(userID);
            currentUser.removeValue();
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
