//
//  MySearchesTableViewCell.swift
//  uDown
//
//  Created by Oscar Pan on 6/5/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit

class MySearchesTableViewCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
