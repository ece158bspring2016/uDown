//
//  MyMatchesTableViewController.swift
//  uDown
//
//  Created by Oscar Pan on 6/5/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseDatabaseUI

class MyMatchesTableViewController: UITableViewController {
    
    // Reference passed in from MySearchesTableViewController
    var ref: FIRDatabaseReference!
    var dataSource: FirebaseTableViewDataSource!
    var selectedMatchKey:String = ""
    var selectedMessageKey:String = ""
    var selectedMatchUserId:String = ""
    var selectedMatch:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        /*let ref = FIRDatabase.database().reference()
         ref.child("users").child(user!.uid).child("displayName").setValue(user?.displayName)*/
        
        
        self.dataSource = FirebaseTableViewDataSource(ref: ref,
                                                      nibNamed: "MyMatchesTableViewCell",
                                                      cellReuseIdentifier: "cellReuseIdentifier",
                                                      view: self.tableView)
        
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FIRDataSnapshot
            
            let myMatchCell = cell as! MyMatchesTableViewCell
            myMatchCell.matchKey = snap.key
            myMatchCell.accessoryType = .DisclosureIndicator
            
            // populate the values on the cells for the current match
            for values in snap.children {
                if(values.key == "receiverId"){
                    myMatchCell.receiverId = values.value
                    let imageUrl = "https://graph.facebook.com/\(values.value as String)/picture?type=large"
                    print(imageUrl)
                    let url = NSURL(string: imageUrl)
                    if let data = NSData(contentsOfURL: url!) {
                        myMatchCell.profileImage.image = UIImage(data: data)
                    }
                }
                if(values.key == "receiverName"){
                    myMatchCell.nameLabel.text = values.value
                }
                if(values.key == "where"){
                    myMatchCell.whereLabel.text = values.value
                }
                if(values.key == "messages"){
                    myMatchCell.messageKey = values.value
                }
                if(values.key == "match"){
                    myMatchCell.match = values.value
                }
            }
        }
        
        self.tableView.dataSource = self.dataSource
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MyMatchesTableViewCell
        
        print(cell.matchKey)
        //let activityLabel: UILabel = cell!.contentView.viewWithTag(2) as! UILabel
        
        selectedMatchKey = cell.matchKey
        selectedMessageKey = cell.messageKey
        selectedMatchUserId = cell.receiverId
        selectedMatch = cell.match
        self.performSegueWithIdentifier("MatchToChat", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if(segue.identifier == "MatchToChat"){
            let navVc = segue.destinationViewController as! UINavigationController
            let chatVc = navVc.viewControllers.first as! ChatViewController
            print("Segue to messages \(selectedMessageKey)")
            chatVc.messageRef = FIRDatabase.database().reference().child("messages").child(selectedMessageKey)
            chatVc.receiverId = selectedMatchUserId
            chatVc.match = selectedMatch
        }
    }
    
    @IBAction func cancelToMyMatchesViewController(segue:UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
