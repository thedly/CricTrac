//
//  FriendRequestsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import KRProgressHUD

class FriendRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider,ThemeChangeable {

    @IBOutlet weak var RequestsTblViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var suggestionsTblView: UITableView!
    
    @IBOutlet weak var noRequestsLbl: UILabel!
    
    @IBOutlet weak var RequestsTblview: UITableView!
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
        RequestsTblview.registerNib(UINib.init(nibName:"FriendRequestsCell", bundle: nil), forCellReuseIdentifier: "FriendRequestsCell")
        
        
        suggestionsTblView.registerNib(UINib.init(nibName:"FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        
        RequestsTblview.allowsSelection = false
        RequestsTblview.separatorStyle = .None
        RequestsTblview.dataSource = self
        RequestsTblview.delegate = self
        
        suggestionsTblView.allowsSelection = false
        suggestionsTblView.separatorStyle = .None
        suggestionsTblView.dataSource = self
        suggestionsTblView.delegate = self
        
        
        
        //setBackgroundColor()
        //setUIBackgroundTheme(self.view)
        self.view.backgroundColor = UIColor.clearColor()
        
        getFriendSuggestions()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        friendsRequestsData.removeAll()
        getAllFriendRequests { (data) in
            
            for (_, req) in data {
                var reqData = ReceivedFriendRequest(dataObj: req as! [String : AnyObject])
                friendsRequestsData.append(reqData)
                
            }
            
            
                
            self.noRequestsLbl.hidden = !(friendsRequestsData.count == 0)
            
            
            
            self.RequestsTblViewHeight.constant = CGFloat(friendsRequestsData.count * 100)
            self.RequestsTblview.reloadData()
            
            
            // do something here
        }
        
        
    }
    
    
    func getFriendSuggestions() {
        
        backgroundThread(background: {
            
            KRProgressHUD.showText("Loading ...")
            getAllFriendSuggestions({
                KRProgressHUD.dismiss()
                self.suggestionsTblView.reloadData()
            })
            
        })
        
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "REQUESTS")
    }
    
    func getCellForRow(indexPath:NSIndexPath)->FriendRequestsCell{
        
        
        if let aCell =  RequestsTblview.dequeueReusableCellWithIdentifier("FriendRequestsCell", forIndexPath: indexPath) as? FriendRequestsCell {
            aCell.FriendName.text = friendsRequestsData[indexPath.row].Name
            aCell.FriendCity.text = friendsRequestsData[indexPath.row].City
            aCell.FriendProfileImage.image = extractImages(friendsRequestsData[indexPath.row].ReceivedFrom)
            
            aCell.backgroundColor = UIColor.clearColor()
            return aCell
        }
        else
        {
            return FriendRequestsCell()
        }
        
        
    }
    
    // MARK: - Table delegate functions
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(suggestionsTblView){
            
            return UserProfilesData.count
        }
        
        return friendsRequestsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(suggestionsTblView){
            
            return getCellForSuggestionsRow(indexPath)
        }
        else
        {
            return getCellForRow(indexPath)
        }
        
        
    }

    func getCellForSuggestionsRow(indexPath:NSIndexPath)->FriendSuggestionsCell{
        
        
        if let aCell =  suggestionsTblView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as? FriendSuggestionsCell {
            
            
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
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            
            if let FriendObject  = UserProfilesData.filter({ $0.id == FriendUserId }).first {
                
                getProfileInfoById((currentUser?.uid)!, sucessBlock: { data in
                    
                    var loggedInUserObject = Profile(usrObj: data)
                    
                    
                    var sendFriendRequestData = SentFriendRequest()
                    
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
                    
                    
                    
                    var receiveFriendRequestData = ReceivedFriendRequest()
                    
                    
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
                        
                        
                        self.suggestionsTblView.reloadData()
                        
                        
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
