//
//  ActivityPickerViewController.swift
//  uDown
//
//  Created by Rachit Sengupta on 5/29/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseDatabaseUI

class ActivityPickerViewController: UITableViewController {
    
    var activities:[String] = []
    var selectedActivityIndex:Int?
    let ref = FIRDatabase.database().reference().child("activities") //get a reference to the activities table on db
    var dataSource: FirebaseTableViewDataSource! //This will be the variable to hold information for FirebaseUI
    
    var selectedIndex:Int?
    var selectedActivity:String?
    var selectedActivityEmoji:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        /*let ref = FIRDatabase.database().reference()
        ref.child("users").child(user!.uid).child("displayName").setValue(user?.displayName)*/
        
        
        
        //Store information about activites from Firebase into variable that can be used by
        //FirebaseUI
        self.dataSource = FirebaseTableViewDataSource(ref: ref,
                                                      nibNamed: "ActivityTableViewCell",
                                                      cellReuseIdentifier: "cellReuseIdentifier",
                                                      view: self.tableView)
        
        //Allow FirebaseUI to populate the table with information pulled from Firebase
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FIRDataSnapshot
            
            // Populate cell as you see fit, like as below
            //cell.textLabel?.text = snap.key as String
            
            //cell.activityLabel.text = snap.text as String
            let emojiLabel: UILabel = cell.contentView.viewWithTag(1) as! UILabel
            let activityLabel: UILabel = cell.contentView.viewWithTag(2) as! UILabel
            //activityLabel.text = snap.key
            
            for values in snap.children {
                if(values.key == "name"){
                    activityLabel.text = values.value
                }
                if(values.key == "emoji"){
                    emojiLabel.text = values.value
                }
                
            }
        }
        
        self.tableView.dataSource = self.dataSource

    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Animation for deselect
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //If another option was selected earlier, deselect it
        if let index = selectedIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        //selectedActivity = dataSource.accessibilityElementAtIndex(indexPath.row)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let activityLabel: UILabel = cell!.contentView.viewWithTag(2) as! UILabel
        let activityEmojiLabel: UILabel = cell!.contentView.viewWithTag(1) as! UILabel
        
        //Save new activity returned to previous controller
        selectedActivity = activityLabel.text!
        selectedActivityEmoji = activityEmojiLabel.text!
        selectedIndex = indexPath.row
        //Checkmark the new activity and save it to be returned to previous controller
        cell?.accessoryType = .Checkmark
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  /*  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath)
        cell.textLabel?.text = activities[indexPath.row]
        
        if indexPath.row == selectedActivityIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }*/

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
