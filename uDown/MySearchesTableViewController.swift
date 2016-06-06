//
//  MySearchesTableViewController.swift
//  uDown
//
//  Created by Oscar Pan on 6/5/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseDatabaseUI

class MySearchesTableViewController: UITableViewController {

    let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("searches")
    var dataSource: FirebaseTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        /*let ref = FIRDatabase.database().reference()
         ref.child("users").child(user!.uid).child("displayName").setValue(user?.displayName)*/
        
        
        self.dataSource = FirebaseTableViewDataSource(ref: ref,
                                                      nibNamed: "MySearchesTableViewCell",
                                                      cellReuseIdentifier: "cellReuseIdentifier",
                                                      view: self.tableView)
        
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FIRDataSnapshot
            
            // Populate cell as you see fit, like as below
            //cell.textLabel?.text = snap.key as String
            
            //cell.activityLabel.text = snap.text as String
            let emojiLabel: UILabel = cell.contentView.viewWithTag(1) as! UILabel
            let activityLabel: UILabel = cell.contentView.viewWithTag(2) as! UILabel
            let timeLabel: UILabel = cell.contentView.viewWithTag(3) as! UILabel
            //activityLabel.text = snap.key
            
            for values in snap.children {
                if(values.key == "activityName"){
                    activityLabel.text = values.value
                }
                if(values.key == "activityEmoji"){
                    emojiLabel.text = values.value
                }
                
            }
        }
        
        self.tableView.dataSource = self.dataSource
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MySearchesTableViewCell
        
        print(cell)
        //let activityLabel: UILabel = cell!.contentView.viewWithTag(2) as! UILabel
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
