//
//  DataService.swift
//  uDown
//
//  Created by Rachit Sengupta on 5/22/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    
    private var _BASE_REF = FIRDatabase.database().reference()
    private var _USER_REF = FIRDatabase.database().reference().child("users")

    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        
        var userID:String = "nil"
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil
        {
            userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        }
        
        let currentUser = _USER_REF.child(userID);
        return currentUser
    }
}