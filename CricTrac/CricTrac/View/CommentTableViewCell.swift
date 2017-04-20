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
    @IBOutlet weak var delCommentBtn: UIButton!
    
    var commentID:String?
    var postID:String?
    var parent:DeleteComment?
    
    
    @IBAction func deletebuttonTapped(sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            //delete comment
            if let value = self.commentID {
                delComment(self.postID!,commentId: self.commentID!)
            }
            
            self.parent?.deletebuttonTapped()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            //print("Handle Cancel Logic here")
        }))
        
        if let parentVc = parent as? UIViewController{
            parentVc.presentViewController(deleteAlert, animated: true, completion: nil)
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
