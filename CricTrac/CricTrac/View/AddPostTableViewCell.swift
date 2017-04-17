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
        // Initialization code
        //addTapGestureToUserName()
    }
//    var timelineVc = TimeLineViewController()
//    func addTapGestureToUserName(){
//        if let _ = freeHitLabel{
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(AddPostTableViewCell.didTapLabelName))
//            freeHitLabel.userInteractionEnabled = true
//            freeHitLabel.addGestureRecognizer(gesture)
//        }
//    }
    
//    func didTapLabelName(){
//            //if let parentVC = parent as? UIViewController{
//                 let newPost = viewControllerFrom("Main", vcid: "NewPostViewController") as! NewPostViewController
//                //newPost.postId = postId!
//                timelineVc.navigationController?.presentViewController(newPost, animated: true) {}
//           // }
//    }
    
    @IBAction func didTapPostButton(sender: AnyObject) {
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
