//
//  CommentsViewController.swift
//  CricTrac
//
//  Created by Renjith on 25/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftyJSON
class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var userCity: UILabel!
    
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var postDetailView: UIView!
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var CommentLblHeight: NSLayoutConstraint!
    @IBOutlet weak var commnetButton: UIButton!

    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [[String:String]]()
    
    var postData:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postText.text = postData!.dictionaryValue["Post"]?.stringValue
        
        let font = UIFont(name: "Source Sans Pro", size: 17)
        let detailHeight = heightForLabel(postText.text! , font: font!, width: postDetailView.bounds.size.width)
        
        CommentLblHeight.constant = detailHeight + 300
        
        
        
        let postId = postData!.dictionaryValue["postId"]?.stringValue
        
        userName.text = postData!.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
        
        if let likeCount = postData!.dictionaryValue["Likes"]?.count{
            
            likeButton.setTitle("\(likeCount) Likes", forState: .Normal)
            
        }else{
            
            likeButton.setTitle("0 Likes", forState: .Normal)
        }
        let commentCount =  postData!.dictionaryValue["TimelineComments"]?.count
        
        self.commnetButton.setTitle("\(commentCount) Comments", forState: .Normal)
        
        
        
        let friendId = postData!["OwnerID"].stringValue
        
        if let city = friendsCity[friendId]{
            
            self.userCity.text = city
            
        }else{
            
            fetchFriendDetail(friendId, sucess: { (city) in
                friendsCity[friendId] = city
                dispatch_async(dispatch_get_main_queue(),{
                    self.userCity.text = city
                    
                })
                
            })
        }
        
       
        getAllComments(postId!) { (data) in
            
            self.dataSource = data
            self.commnetButton.setTitle("\(data.count) Comments", forState: .Normal)
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
        
        aCell.commentText.text = data["Comment"]
        
        var value = data["OwnerName"]
        if value == ""{
            
            value = "No Name Added"
        }
        
        aCell.userName.text =   value
        
        return aCell
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        textView.text = ""
    }
    func textViewDidEndEditing(textView: UITextView){
        commentBox.text = "Add Comment"
    }
    
    @IBAction func postNewComment(sender: AnyObject) {
        
        
        dataSource.append(["OwnerName":loggedInUserName ?? "Another Friend","Comment":commentBox.text])
        
        let postId = postData!.dictionaryValue["postId"]?.stringValue
        addNewComment(postId!, comment: commentBox.text)
        commentBox.text = ""
        tableView.reloadData()
    }
    
    @IBAction func didTapClose(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) { }
    }
    
    
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
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
