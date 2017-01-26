//
//  APostTableViewCell.swift
//  CricTrac
//
//  Created by Renjith on 9/19/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON

class APostTableViewCell: UITableViewCell {

    @IBOutlet weak var postOwnerName: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var postOwnerCity: UILabel!

    @IBOutlet weak var likeCount: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var postId:String?
    var totalLikeCount = 0
    var index:Int?
    var currentUserHasLikedThePost = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func DidTapLikeButton(sender: UIButton) {
        
        if let value = postId{
        
       likeOrUnlike(value, like: { (likeDict) in
        
        self.addLikeToDataArray(likeDict)
        self.likeButton.titleLabel?.textColor = UIColor.yellowColor()
        self.totalLikeCount += 1
        self.likeCount.setTitle("\(self.totalLikeCount) LIKES", forState: .Normal)
        self.currentUserHasLikedThePost = true
        
        }) {
            self.removeLikeFromArray()
            self.likeButton.titleLabel?.textColor = UIColor.grayColor()
            self.totalLikeCount -= 1
            self.likeCount.setTitle("\(self.totalLikeCount) LIKES", forState: .Normal)
            self.currentUserHasLikedThePost = false

        }
        }
    }
    
    

    
    func removeLikeFromArray(){
        
        var likes = timelineData!.arrayObject![index!]["Likes"] as! [String:[String:String]]
        let keys =  likes.filter{key,val in
            
            return val["OwnerID"]! == currentUser!.uid
            
            }.map{
                
                return $0.0
        }
        
        if keys.count > 0 {
            
            likes.removeValueForKey(keys[0])
            
            timelineData![index!]["Likes"] = JSON(likes)
        }
        
        
    }
    
    func addLikeToDataArray(likeArray:[String:[String:String]]){
        
        timelineData![index!]["Likes"] = JSON(likeArray)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
