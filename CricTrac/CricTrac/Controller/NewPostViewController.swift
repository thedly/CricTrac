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

class NewPostViewController: UIViewController,ThemeChangeable,UITextViewDelegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var postOwnerName:UILabel!
    @IBOutlet weak var barView: UIView!
    
    weak var sendPostDelegate:PostSendable?
    var editingPost:String?
    var postId:String = ""
    var postIndex = 0
    var postOwnerId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setNavigationBarProperties()
       //self.view.backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        postContent.backgroundColor = UIColor.clearColor()
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        postContent.placeHolderForTextView()
        //postContent.keyboardAppearance
        
        postContent.delegate = self
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
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                self.profilePic.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                    self.profilePic.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        postOwnerName.text = loggedInUserName ?? "CricTrac"
        loadPostIfEditMode()
        
        // Do any additional setup after loading the view.
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        self.barView.backgroundColor = currentTheme.topColor
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
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let postText = postContent.text {
            if postText.characters.count > 0 && postText != "Free hit"{
                if editingPost == nil{
                    sendPostDelegate?.sendNewPost(postText)
                }else{
                    sendPostDelegate?.modifyPost(postText, postId: postId,index: postIndex)
                }
            }
            else{
                let alert = UIAlertController(title: "", message: "Please enter a post", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        dismissViewControllerAnimated(true) {}
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if editingPost == nil && textView.text == "Free hit" {
            textView.text = ""
        }
    }
    
//    func textViewDidEndEditing(textView: UITextView){
//        if textView == postContent{
//            postContent.placeHolderForTextView()
//           
//        }
//    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        textView.clearPlaceHolderForTextView()
        return true
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
