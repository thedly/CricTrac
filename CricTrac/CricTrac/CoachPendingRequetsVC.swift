//
//  CoachPendingRequetsVC.swift
//  CricTrac
//
//  Created by AIPL on 31/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachPendingRequetsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    @IBOutlet weak var RequestsTblview: UITableView!
    
    let currentTheme = cricTracTheme.currentTheme
    
    var playerRequests = [String]()
    var playerNodeIdOthers = [String]()
    var coachNodeIds = [String]()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getMyPlayers { (data) in
            for(_,req) in data {
                let pendingReq = req as! [String : AnyObject]
                let isAcceptVal = pendingReq["isAccepted"]!
                if isAcceptVal as! NSObject == 0 {
                    let pendingReqs = pendingReq["PlayerID"]!
                    self.playerNodeIdOthers.append(pendingReq["PlayerNodeIdOther"]! as! String)
                    self.coachNodeIds.append(pendingReq["CoachNodeId"]! as! String)
                    self.playerRequests.append(pendingReqs as! String)
                }
            }
            self.RequestsTblview.reloadData()
        }
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
    }
    
    func initializeView() {
        RequestsTblview.registerNib(UINib.init(nibName:"FriendRequestsCell", bundle: nil), forCellReuseIdentifier: "FriendRequestsCell")
        RequestsTblview.allowsSelection = false
        RequestsTblview.separatorStyle = .None
        RequestsTblview.dataSource = self
        RequestsTblview.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = currentTheme.topColor
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerRequests.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = RequestsTblview.dequeueReusableCellWithIdentifier("FriendRequestsCell", forIndexPath: indexPath) as! FriendRequestsCell
        
        if playerRequests.count != 0 {
        let pendingReqId = playerRequests[indexPath.row]
        
        fetchBasicProfile(pendingReqId) { (result) in
            let proPic = result["proPic"]
            let city =   result["city"]
            let name = "\(result["firstname"]!) \(result["lastname"]!)"
            let userProfile = result["userProfile"]
            let playingRole = result["playingRole"]
            
            aCell.FriendCity.text = city
            aCell.FriendName.text = name
            
            if userProfile == "Player" {
                aCell.FriendRole.text = playingRole
            }
                
            else if userProfile == "Coach" {
                aCell.FriendRole.text = "Coach"
            }
            else if userProfile == "Cricket Fan" {
                aCell.FriendRole.text = "Cricket Fan"
            }
           
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                aCell.FriendProfileImage.image = image
            }else{
                if let imageURL = NSURL(string:proPic!){
                    aCell.FriendProfileImage.kf_setImageWithURL(imageURL)
                }
            }
        }
    }
        
        aCell.backgroundColor = UIColor.clearColor()
        aCell.baseView.backgroundColor = currentTheme.bottomColor
        aCell.baseView.alpha = 1
        aCell.cancelBtn.hidden = true
        aCell.confirmBtn.accessibilityIdentifier = playerNodeIdOthers[indexPath.row]
        aCell.confirmBtn.restorationIdentifier = coachNodeIds[indexPath.row]
        aCell.confirmBtn.addTarget(self, action: #selector(CoachPendingRequetsVC.confirmPlayerRequest(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return aCell
    }
    
    // confirm btn
    
    func confirmPlayerRequest(sender:UIButton) {
     
        
        
        
    }
    
    
}
