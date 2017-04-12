//
//  CommentTableViewCell.swift
//  CricTrac
//
//  Created by Renjith on 25/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var commentDate: UILabel!
   
    var commentID:String?
    var parent:DeleteComment?
    
    @IBAction func deletebuttonTapped(sender: AnyObject) {
                
      
        let refreshAlert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            // self.deleteComment()
            
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        if let parentVc = parent as? UIViewController{
            
            parentVc.presentViewController(refreshAlert, animated: true, completion: nil)
        }


        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    



    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
