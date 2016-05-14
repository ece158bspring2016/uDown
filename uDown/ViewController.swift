//
//  ViewController.swift
//  uDown
//
//  Created by Oscar Pan on 5/12/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(sender: AnyObject)
    {
        let ref = Firebase(url: "https://udown.firebaseio.com")
        
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        facebookLogin.logInWithReadPermissions(["email"], handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
                
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            
                            let newUser = [
                                "provider": authData.provider,
                                "displayName": authData.providerData["displayName"] as? NSString as? String,
                                "email": authData.providerData["email"] as? NSString as? String
                            ]
                            
                            ref.childByAppendingPath("users")
                            .childByAppendingPath(authData.uid).setValue(newUser)
                            
                            //Display next view controller
                            
                            let nextView = (self.storyboard?.instantiateViewControllerWithIdentifier("Profile"))! as UIViewController; self.presentViewController(nextView, animated: true, completion: nil)
                        }
                })
            }
        })

        
    }


}

