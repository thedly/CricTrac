//
//  NotificationTableViewCell.swift
//  
//
//  Created by AIPL on 02/05/17.
//
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
   
    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var menuName: UILabel!
    var notificationId:String = ""


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuIcon.layer.borderWidth = 1
        menuIcon.layer.masksToBounds = false
        menuIcon.layer.borderColor = UIColor.clearColor().CGColor
        menuIcon.layer.cornerRadius = menuIcon.frame.height/2
       
        menuIcon.clipsToBounds = true
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
