//
//  SearchCreateViewController.swift
//  uDown
//
//  Created by Oscar Pan on 5/29/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit

class SearchCreateViewController: UIViewController {


    
    @IBOutlet weak var activityButton: UIButton!
    var activity:String = "Grab Food" {
        didSet {
            activityButton.setTitle(activity, forState: UIControlState.Normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
