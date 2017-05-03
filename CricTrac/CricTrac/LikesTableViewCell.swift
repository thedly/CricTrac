//
//  LikesTableViewCell.swift
//  CricTrac
//
//  Created by AIPL on 03/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var friendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       //  userImage.layer.cornerRadius = userImage.bounds.size.width/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
