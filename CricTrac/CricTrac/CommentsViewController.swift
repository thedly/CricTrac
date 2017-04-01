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
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var userCity: UILabel!
    
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    

    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inerView: UIView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var dataSource = [[String:AnyObject]]()
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var postData:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inerView.layer.masksToBounds = true
        inerView.layer.cornerRadius = inerView.frame.width/56
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = inerView.backgroundColor
        tableView.backgroundView?.backgroundColor = inerView.backgroundColor
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50.0;
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.darkGrayColor().CGColor
        commentTextView.setPlaceHolder()
        
        postText.text = postData!.dictionaryValue["Post"]?.stringValue
        
        let postId = postData!.dictionaryValue["postId"]?.stringValue
        
        userName.text = postData!.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
        
        if let likeCount = postData!.dictionaryValue["Likes"]?.count{
            
            //likeButton.setTitle("\(likeCount) Likes", forState: .Normal)
            
        }else{
            
            //likeButton.setTitle("0 Likes", forState: .Normal)
        }
        
        
        
        
        let friendId = postData!["OwnerID"].stringValue
        
        if let city = friendsCity[friendId]{
            
            self.userCity.text = city
            
        }else{
            
            fetchFriendDetail(friendId, sucess: { (city) in
                friendsCity[friendId] = city
                dispatch_async(dispatch_get_main_queue(),{
                    //self.userCity.text = city
                    
                })
                
            })
        }
        
       
        getAllComments(postId!) { (data) in
            
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
        
        dismissViewControllerAnimated(true) { }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
