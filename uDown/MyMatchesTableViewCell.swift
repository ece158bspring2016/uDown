//
//  MyMatchesTableViewCell.swift
//  uDown
//
//  Created by Oscar Pan on 6/5/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit

class MyMatchesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    
    var matchKey:String = ""
    var messageKey:String = ""
    var receiverId:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}