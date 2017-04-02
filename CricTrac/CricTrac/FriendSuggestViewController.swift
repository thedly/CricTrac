//
//  FriendSuggestViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import KRProgressHUD

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
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
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
        return IndicatorInfo(title: "INVITE")
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
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return UITableViewCell()
        
    }
    
    
    func AddFriendBtnPressed(sender: UIButton) {
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            
            if let FriendObject  = UserProfilesData.filter({ $0.id == FriendUserId }).first {
                
                getProfileInfoById((currentUser?.uid)!, sucessBlock: { data in
                
                    let loggedInUserObject = Profile(usrObj: data)
                    
                    
                    let sendFriendRequestData = SentFriendRequest()
                    
                    sendFriendRequestData.City = FriendObject.City
                    
                    
                    switch FriendObject.UserProfile {
                    case userProfileType.Player.rawValue :
                        sendFriendRequestData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                            break;
                    case userProfileType.Coach.rawValue :
                        sendFriendRequestData.Club = FriendObject.CoachCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Fan.rawValue :
                        sendFriendRequestData.Club = FriendObject.SupportingTeams.joinWithSeparator(",")
                        break;
                    default:
                        sendFriendRequestData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;

                    }
                    
                    
                    sendFriendRequestData.Name = FriendObject.fullName
                    sendFriendRequestData.SentTo = FriendObject.id
                    sendFriendRequestData.SentDateTime = NSDate().getCurrentTimeStamp()
                    
                    
                    
                    let receiveFriendRequestData = ReceivedFriendRequest()
                    
                    
                    receiveFriendRequestData.City = loggedInUserObject.City
                    
                    switch loggedInUserObject.UserProfile {
                    case userProfileType.Player.rawValue :
                        receiveFriendRequestData.Club = loggedInUserObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Coach.rawValue :
                        receiveFriendRequestData.Club = loggedInUserObject.CoachCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Fan.rawValue :
                        receiveFriendRequestData.Club = loggedInUserObject.SupportingTeams.joinWithSeparator(",")
                        break;
                    default:
                        receiveFriendRequestData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;
                        
                    }

                    receiveFriendRequestData.Name = loggedInUserObject.fullName
                    receiveFriendRequestData.ReceivedFrom = loggedInUserObject.id
                    receiveFriendRequestData.ReceivedDateTime = NSDate().getCurrentTimeStamp()
                    
                    
                    
                    AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
                        
                        
                        if let index = UserProfilesData.indexOf( {$0.id == FriendObject.id}) {
                            UserProfilesData.removeAtIndex(index)
                        }
                        
                        
                        self.SuggestsTblview.reloadData()
                        
                        
                    })

                
                }) //UserProfilesData.filter({ $0.id == currentUser?.uid }).first {
                
                
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

