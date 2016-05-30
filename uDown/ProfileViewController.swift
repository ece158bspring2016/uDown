//
//  ProfileViewController.swift
//  uDown
//
//  Created by Rachit Sengupta on 5/22/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {


    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Here?")
        if let user = FIRAuth.auth()?.currentUser {
            print("In if")
            for profile in user.providerData {
                let uid = profile.uid;  // Provider-specific UID
                let name = profile.displayName!
                
                self.usernameLabel.text = name
                let imageUrl = "https://graph.facebook.com/\(uid)/picture?type=large"
                let url = NSURL(string: imageUrl)
                if let data = NSData(contentsOfURL: url!) {
                    self.profileImage.image = UIImage(data: data)
                }
        
            }
        }
    
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("We are here")

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
