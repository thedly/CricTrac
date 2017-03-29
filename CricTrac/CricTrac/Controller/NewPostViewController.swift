//
//  NewPosTViewController.swift
//  CricTrac
//
//  Created by Renjith on 22/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewPostViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var postOwnerName:UILabel!
    
    weak var sendPostDelegate:PostSendable?
    
    var editingPost:String?
    var postId:String = ""
    var postIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = cricTracTheme.currentTheme.topColor
        contentView.backgroundColor = cricTracTheme.currentTheme.boxColor
        postContent.backgroundColor = UIColor.clearColor()
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        postOwnerName.text = loggedInUserName ?? "Say Something Loud"
        loadPostIfEditMode()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadPostIfEditMode(){
        
        guard let value = editingPost else {return}
        
        postContent.text = value
    }

    @IBAction func close(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) {}
    }
    
    
    @IBAction func sendNewPostToTimline(sender:UIButton){
        
        if let postText = postContent.text{
            if editingPost == nil{
        sendPostDelegate?.sendNewPost(postText)
            }else{
                sendPostDelegate?.modifyPost(postText, postId: postId,index: postIndex)
            }
        }
        
        dismissViewControllerAnimated(true) {}
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
