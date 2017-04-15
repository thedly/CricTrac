//
//  NewPosTViewController.swift
//  CricTrac
//
//  Created by Renjith on 22/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class NewPostViewController: UIViewController,ThemeChangeable {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var postOwnerName:UILabel!
    
    weak var sendPostDelegate:PostSendable?
    var editingPost:String?
    var postId:String = ""
    var postIndex = 0
    var postOwnerId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
       //self.view.backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        postContent.backgroundColor = UIColor.clearColor()
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        
        let postOwnerId = currentUser?.uid
        fetchFriendDetail(postOwnerId!, sucess: { (result) in
            let proPic = result["proPic"]
//            
//            aCell.userImage.layer.borderWidth = 1
//            aCell.userImage.layer.masksToBounds = false
//            aCell.userImage.layer.borderColor = UIColor.clearColor().CGColor
//            aCell.userImage.layer.cornerRadius = aCell.userImage.frame.width/2
//            aCell.userImage.clipsToBounds = true
            
            if proPic! == "-"{
                let imageName = "propic.png"
                let image = UIImage(named: imageName)
                self.profilePic.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                    self.profilePic.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        postOwnerName.text = loggedInUserName ?? "Say Something Loud"
        loadPostIfEditMode()
        
        // Do any additional setup after loading the view.
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
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
        // network reachability test
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
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
