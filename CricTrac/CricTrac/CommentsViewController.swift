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
    
    @IBOutlet weak var commnetButton: UIButton!

    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inerView: UIView!
    
    
    var dataSource = [[String:AnyObject]]()
    
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
        
        postText.text = postData!.dictionaryValue["Post"]?.stringValue
        
        let postId = postData!.dictionaryValue["postId"]?.stringValue
        
        userName.text = postData!.dictionaryValue["OwnerName"]?.stringValue ?? "No Name"
        
        if let likeCount = postData!.dictionaryValue["Likes"]?.count{
            
            //likeButton.setTitle("\(likeCount) Likes", forState: .Normal)
            
        }else{
            
            //likeButton.setTitle("0 Likes", forState: .Normal)
        }
        let commentCount =  postData!.dictionaryValue["TimelineComments"]?.count
        
        //self.commnetButton.setTitle("\(commentCount) Comments", forState: .Normal)
        
        
        
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
    
    
    @IBAction func addCommnet(sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Alert Title",
                                      message: "Alert message",
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first where alertTextField.text != nil {
                                    
                                    print("And the text is... \(alertTextField.text!)!")
                                    
                                }
                                
                                
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertActionStyle.Cancel,
                                   handler: nil)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            
            textField.placeholder = "Text here"
            
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
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
