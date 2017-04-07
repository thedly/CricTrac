//
//  CommentsViewController.swift
//  CricTrac
//
//  Created by Renjith on 25/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON
class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userCity: UILabel!
    
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var likes: UILabel!
    
  
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var postIndex = 0
    
    
    
    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    var postLikeCount = 0
    var initialLikes = 0
    var refreshableParent:Refreshable?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inerView: UIView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var dataSource = [[String:AnyObject]]()
    var  postId:String = ""
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var postData:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inerView.layer.masksToBounds = true
        inerView.layer.cornerRadius = inerView.frame.width/56
        inerView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50.0;
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
        commentTextView.setPlaceHolder()
        
        postText.text = postData!.dictionaryValue["Post"]?.stringValue
        
        postId = (postData!.dictionaryValue["postId"]?.stringValue)!
        
        userName.text = postData!.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
        
        if let likeCount = postData!.dictionaryValue["Likes"]?.count{
            
            likes.text = "\(likeCount) Likes"
            postLikeCount = likeCount
            initialLikes = postLikeCount
            
        }else{
            
            likes.text = "0 Likes"
        }
        
        if let commentCount = postData!.dictionaryValue["TimelineComments"]?.count{
            
            comments.text = "\(commentCount) Comments"
            
        }else{
            
            comments.text = "0 Comments"
        }
        
        
        let friendId = postData!["OwnerID"].stringValue
        
        if let city = friendsCity[friendId]{
            
            self.userCity.text = city
            
        }else{
            
            fetchFriendCity(friendId, sucess: { (city) in
                friendsCity[friendId] = city
                dispatch_async(dispatch_get_main_queue(),{
                    //self.userCity.text = city
                    
                })
                
            })
        }
        
        
        fetchFriendDetail(friendId, sucess: { (result) in
            let proPic = result["proPic"]
            
            if proPic! == "-"{
                
                let imageName = "propic.png"
                let image = UIImage(named: imageName)
                self.profileImage.image = image
                
            }else{
                if let imageURL = NSURL(string:proPic!){
                    self.profileImage.kf_setImageWithURL(imageURL)
                }
            }
            
            //sucess(result: ["proPic":proPic,"city":city])
        })
        
        
        
        
        
        if let dateTimeStamp = postData!["AddedTime"].double{
            
            let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            self.date.text = dateFormatter.stringFromDate(date)
        }
        
        
        getAllComments(postId) { (data) in
            
            self.dataSource = data
            self.tableView.reloadData()
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let data = dataSource[indexPath.row]
        let aCell =  tableView.dequeueReusableCellWithIdentifier("commentcell", forIndexPath: indexPath) as! CommentTableViewCell
        
        if let val = data["Comment"] as? String{
            
            aCell.commentText.text = val
            aCell.backgroundColor = UIColor.clearColor()
        }
        

        
        if let dateTimeStamp = data["AddedTime"] as? Double{
            
            let date = NSDate(timeIntervalSince1970:dateTimeStamp/1000.0)
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            aCell.commentDate.text = dateFormatter.stringFromDate(date)
        }
        
        
        if var value = data["OwnerName"] as? String{
            
            if value == ""{
                
                value = "No Name Added"
            }
            
            aCell.userName.text =   value
        }
        
        
        return aCell
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        textView.text = ""
    }
    func textViewDidEndEditing(textView: UITextView){
        
        if textView == commentTextView{
            commentTextView.setPlaceHolder()
            textViewHeightConstraint.constant = 30
        }
        
    }
    
    @IBAction func postNewComment(sender: AnyObject) {
        
        
        let text = commentTextView.text.trimWhiteSpace
        
        if text.characters.count > 0{
            
            commentTextView.resignFirstResponder()
            commentTextView.setPlaceHolder()
            textViewHeightConstraint.constant = 30
            dataSource.append(["OwnerName":loggedInUserName ?? "Another Friend","Comment":text])
            let postId = postData!.dictionaryValue["postId"]?.stringValue
            addNewComment(postId!, comment:text)
            tableView.reloadData()
        }
    }
    
    @IBAction func didTapClose(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) {
            
            if self.postLikeCount < self.initialLikes{
                
                var likes = timelineData!.arrayObject![self.postIndex]["Likes"] as! [String:[String:String]]
                let keys =  likes.filter{key,val in
                    
                    return val["OwnerID"]! == currentUser!.uid
                    
                    }.map{
                        
                        return $0.0
                }
                
                if keys.count > 0 {
                    
                    likes.removeValueForKey(keys[0])
                    
                    timelineData![self.postIndex]["Likes"] = JSON(likes)
                }
                
            }
            if self.postLikeCount != self.initialLikes{
                
                self.refreshableParent?.refresh()
            }
            
        }
    }
    
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        
        let textViewContent = textView.text
        /*
         
         if textViewContent != ""{
         
         let lastChar = textViewContent[textViewContent.endIndex.predecessor()]
         if lastChar == "\n" && text ==  ""{
         if self.TextViewHeight.constant > 30{
         self.TextViewHeight.constant = self.TextViewHeight.constant-18
         }
         }
         }
         if text ==  "\n"{
         
         UIView.animateWithDuration(0.1, animations: { () -> Void in
         if self.TextViewHeight.constant < 102{
         self.TextViewHeight.constant = self.TextViewHeight.constant+18
         }
         
         })
         }
         */
        
        if text ==  "\n"{ return false}
        
        let lines  =  textViewContent.characters.count/40
        
        let heightConstant = Int((self.textViewHeightConstraint.constant - 30)/18)
        
        if lines > heightConstant{
            
            if self.textViewHeightConstraint.constant < 102{
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    
                    self.textViewHeightConstraint.constant = self.textViewHeightConstraint.constant+18
                })}
        }else if heightConstant > lines{
            
            self.textViewHeightConstraint.constant = self.textViewHeightConstraint.constant - 18
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        
        textView.clearPlaceHolder()
        return true
    }
    
    
    
    
    @IBAction func didTapLikeButton(sender: UIButton) {
        
        
        likeOrUnlike(postId, like: { (likeDict) in
            
            self.likeButton.titleLabel?.textColor = UIColor.yellowColor()
            self.postLikeCount += 1
            self.likes.text = "\(self.postLikeCount) Likes"
             timelineData![self.postIndex]["Likes"] = JSON(likeDict)
            
        }) {
            self.removeLikeFromArray()
            self.likeButton.titleLabel?.textColor = UIColor.grayColor()
            self.postLikeCount -= 1
            self.likes.text = "\(self.postLikeCount) Likes"
            
        }
    }
    
    func addLikeToDataArray(likeArray:[String:[String:String]]){
        
        //timelineData![index]["Likes"] = JSON(likeArray)
    }
    
    func removeLikeFromArray(){
        /*
         var likes = timelineData!.arrayObject![index]["Likes"] as! [String:[String:String]]
         let keys =  likes.filter{key,val in
         
         return val["OwnerID"]! == currentUser!.uid
         
         }.map{
         
         return $0.0
         }
         
         if keys.count > 0 {
         
         likes.removeValueForKey(keys[0])
         
         timelineData![index!]["Likes"] = JSON(likes)
         }
         */
        
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
