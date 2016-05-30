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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we have the uid stored, the user is already logger in - no need to sign in again!
        /*if let user = FIRAuth.auth()?.currentUser {
            self.performSegueWithIdentifier("ProfileSegue", sender: nil)
        }*/

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(sender: AnyObject)
    {
        let ref = FIRDatabase.database().reference()

        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                //self.showMessagePrompt(error.localizedDescription)
            } else if(result.isCancelled) {
                print("FBLogin cancelled")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                //self.firebaseLogin(credential)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    if(error != nil)
                    {
                        print("Login failed. \(error)")
                    }
                    else
                    {
                        print("Logged In! \(user)")
                        print(user?.providerData)
                        for profile in user!.providerData {
                            let email = profile.email
                            let photoURL = profile.photoURL
                            let uid = profile.uid
                            ref.child("users").child(user!.uid).child("email").setValue(email)
                            ref.child("users").child(user!.uid).child("profileImageUrl").setValue(photoURL?.absoluteString)
                            ref.child("users").child(user!.uid).child("uid").setValue(uid)
                        }
                        ref.child("users").child(user!.uid).child("displayName").setValue(user?.displayName)
                        
                        // Store the uid for future access - handy!
                        NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: "uid")
                        
                        //Display next view controller
                        self.performSegueWithIdentifier("ProfileSegue", sender: nil)

                    }
                }
            }
        })
    
        
        /*let facebookLogin = FBSDKLoginManager()
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
                                "email": authData.providerData["email"] as? NSString as? String,
                                "profileImageURL": authData.providerData["profileImageURL"] as? NSString as? String,
                            ]
                            
                            ref.childByAppendingPath("users")
                            .childByAppendingPath(authData.uid).setValue(newUser)
                            
                            // Store the uid for future access - handy!
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            
                            //Display next view controller
                            
                            self.performSegueWithIdentifier("ProfileSegue", sender: nil)
                        }
                })
            }
        })*/

        
    }


}

