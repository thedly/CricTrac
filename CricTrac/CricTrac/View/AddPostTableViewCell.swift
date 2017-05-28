//
//  AddPostTableViewCell.swift
//  CricTrac
//
//  Created by Renjith on 9/19/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class AddPostTableViewCell: UITableViewCell {

    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var newPostText: UITextField!
    @IBOutlet weak var timelineOwnerPic: UIImageView!
    @IBOutlet weak var freeHitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timelineOwnerPic.layer.cornerRadius = timelineOwnerPic.frame.size.width/2
        timelineOwnerPic.clipsToBounds = true
    }

    
    @IBAction func didTapPostButton(sender: AnyObject) {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
