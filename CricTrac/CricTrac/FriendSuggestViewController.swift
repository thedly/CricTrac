//
//  FriendSuggestViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FriendSuggestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider,ThemeChangeable {
    
    @IBOutlet weak var SuggestsTblview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    func initializeView() {
        SuggestsTblview.registerNib(UINib.init(nibName:"FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        SuggestsTblview.allowsSelection = false
        SuggestsTblview.separatorStyle = .None
        SuggestsTblview.dataSource = self
        SuggestsTblview.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        
        //setBackgroundColor()
        //setUIBackgroundTheme(self.view)
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SUGGESTIONS")
    }
    
    // MARK: - Table delegate functions
    
    
        
    @IBAction func getAllProfilesBtnPressed(sender: AnyObject) {
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserProfilesData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return getCellForRow(indexPath)
        
    }
    
    func getCellForRow(indexPath:NSIndexPath)->FriendSuggestionsCell{
        
        
        if let aCell =  SuggestsTblview.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as? FriendSuggestionsCell {
             
            
            aCell.configureCell(UserProfilesData[indexPath.row])
            
            aCell.AddFriendBtn.accessibilityIdentifier = UserProfilesData[indexPath.row].id
            
            
            aCell.AddFriendBtn.addTarget(self, action: #selector(AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            
            aCell.backgroundColor = UIColor.clearColor()
            return aCell
        }
        else {
            return FriendSuggestionsCell()
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    func AddFriendBtnPressed(sender: UIButton) {
        
        if let FriendUserId = sender.accessibilityIdentifier {
            
            if let FriendObject  = UserProfilesData.filter({ $0.id == FriendUserId }).first {
                
                if let loggedInUserObject = UserProfilesData.filter({ $0.id == currentUser?.uid }).first {
                    
                    
                    var sendFriendRequestData = SentFriendRequest()
                    
                    sendFriendRequestData.City = FriendObject.City
                    sendFriendRequestData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                    sendFriendRequestData.Name = FriendObject.fullName
                    sendFriendRequestData.SentTo = FriendObject.id
                    sendFriendRequestData.SentDateTime = NSDate().getCurrentTimeStamp()
                    
                    
                    
                    var receiveFriendRequestData = ReceivedFriendRequest()
                    
                    
                    receiveFriendRequestData.City = loggedInUserObject.City
                    receiveFriendRequestData.Club = loggedInUserObject.PlayerCurrentTeams.joinWithSeparator(",")
                    receiveFriendRequestData.Name = loggedInUserObject.fullName
                    receiveFriendRequestData.ReceivedFrom = loggedInUserObject.id
                    receiveFriendRequestData.ReceivedDateTime = NSDate().getCurrentTimeStamp()
                    
                    
                    
                    AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
                        
                        
                        if let index = UserProfilesData.indexOf( {$0.id == FriendObject.id}) {
                            UserProfilesData.removeAtIndex(index)
                        }
                        
                        
                        self.SuggestsTblview.reloadData()
                        
                        
                    })
                    
                    
                    
                    
                }
                
                
            }
            
        }
        
        
        
        
        //            let friendRequestData  = ["sentRequestData":
        //
        //            ["City": _userObj.City, "Club": _userObj.TeamName, "Name": _userObj.fullName, "SentTo": _userObj.id, "SentDateTime": "\(currentTimeMillis())"],
        //
        //            "ReceivedRequestData" : ["City": loggedInUser.City, "Club": loggedInUser.TeamName, "Name": loggedInUser.fullName, "ReceivedFrom": loggedInUser.id, "ReceievedDateTime": "\(currentTimeMillis())"]
        //            ]
        //
        //            AddSentRequestData(friendRequestData, callback: { sentRequestId in
        //            print(sentRequestId)
        //            })
        
        
        
        //Send Friend Request
        
        
        
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

