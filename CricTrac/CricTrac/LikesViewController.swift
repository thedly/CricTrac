//
//  LikesViewController.swift
//  CricTrac
//
//  Created by AIPL on 03/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var barView: UIView!
    var postID: String = ""
     var dataSource = [[String:AnyObject]]()
     var currentTheme:CTTheme!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLikes(postID) { (data) in
           self.dataSource = data
           self.tableView.reloadData()
        }
        self.setBackgroundColor()
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        self.barView.backgroundColor =  currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let data = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("LikesTableViewCell", forIndexPath:
            indexPath) as! LikesTableViewCell
        
        
        
        cell.name.text = data["OwnerName"] as? String
        let friendUserId = data["OwnerID"] as? String
        
        cell.userImage.layer.borderWidth = 1
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.clearColor().CGColor
        cell.userImage.layer.cornerRadius = cell.userImage.frame.width/2
        cell.userImage.clipsToBounds = true
        
        fetchFriendDetail(friendUserId!, sucess: { (result) in
            let proPic = result["proPic"]
            let city = result["city"]
            cell.city.text = city
            
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                cell.userImage.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                   cell.userImage.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        

        cell.backgroundColor = UIColor.clearColor()
        return cell
    }

}
