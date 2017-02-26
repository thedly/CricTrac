//
//  FriendRequestsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FriendRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider,ThemeChangeable {

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
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    func initializeView() {
        RequestsTblview.registerNib(UINib.init(nibName:"FriendRequestsCell", bundle: nil), forCellReuseIdentifier: "FriendRequestsCell")
        
        RequestsTblview.allowsSelection = false
        RequestsTblview.separatorStyle = .None
        RequestsTblview.dataSource = self
        RequestsTblview.delegate = self
        //setBackgroundColor()
        //setUIBackgroundTheme(self.view)
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        friendsRequestsData.removeAll()
        getAllFriendRequests { (data) in
            
            
            for (_, req) in data {
                var reqData = ReceivedFriendRequest(dataObj: req as! [String : AnyObject])
                friendsRequestsData.append(reqData)
                
            }
            
            self.RequestsTblview.reloadData()
            
            // do something here
        }
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "REQUESTS")
    }
    
    func getCellForRow(indexPath:NSIndexPath)->FriendRequestsCell{
        
        
        let aCell =  RequestsTblview.dequeueReusableCellWithIdentifier("FriendRequestsCell", forIndexPath: indexPath) as! FriendRequestsCell
        
        aCell.FriendName.text = friendsRequestsData[indexPath.row].Name
        aCell.FriendCity.text = friendsRequestsData[indexPath.row].City
        aCell.FriendProfileImage.image = extractImages(friendsRequestsData[indexPath.row].ReceivedFrom)
        
        aCell.confirmBtn.accessibilityIdentifier = friendsRequestsData[indexPath.row].ReceivedFrom
        
        aCell.confirmBtn.restorationIdentifier = friendsRequestsData[indexPath.row].RequestId
        
        aCell.rejectBtn.restorationIdentifier = friendsRequestsData[indexPath.row].RequestId
        
        
        aCell.confirmBtn.addTarget(self, action: #selector(FriendRequestsViewController.ConfirmFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        aCell.rejectBtn.addTarget(self, action: #selector(FriendRequestsViewController.RejectFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
    }
    
    // MARK: - Table delegate functions
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsRequestsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return getCellForRow(indexPath)
        
    }

    func RejectFriendBtnPressed(sender: UIButton){
        
        let RequestObjectid = sender.restorationIdentifier
        
        DeleteSentAndReceivedFriendRequestData(RequestObjectid!, successBlock: { data in
            
            if data == true {
                if let index = friendsRequestsData.indexOf( {$0.RequestId == RequestObjectid }) {
                    friendsRequestsData.removeAtIndex(index)
                }
                
                
                self.RequestsTblview.reloadData()
            }
            
            
            
        })

        
    }
    
    public func ConfirmFriendBtnPressed(sender:UIButton!) {
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            
            var FriendObject = Profile(usrObj: [:])
            var loggedInUserObject = Profile(usrObj: [:])
            
            getProfileInfoById(FriendUserId, sucessBlock: { FriendData in
                FriendObject = Profile(usrObj: FriendData)
                
                getProfileInfoById((currentUser?.uid)!, sucessBlock: { loggedInUserObjectData in
                    loggedInUserObject = Profile(usrObj: loggedInUserObjectData)
                    
                    
                    let RequestObjectid = sender.restorationIdentifier
                    
                    
                    var FriendData = Friends(dataObj: [:])
                    
                    FriendData.UserId = FriendObject.id
                    FriendData.City = FriendObject.City
                    switch FriendObject.UserProfile {
                    case userProfileType.Player.rawValue :
                        FriendData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Coach.rawValue :
                        FriendData.Club = FriendObject.CoachCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Fan.rawValue :
                        FriendData.Club = FriendObject.SupportingTeams.joinWithSeparator(",")
                        break;
                    default:
                        FriendData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;
                        
                    }

                    FriendData.Name = FriendObject.fullName
                    FriendData.FriendshipDateTime = NSDate().getCurrentTimeStamp()
                    
                    var UserData = Friends(dataObj: [:])
                    
                    UserData.UserId = loggedInUserObject.id
                    UserData.City = loggedInUserObject.City
                    
                    switch FriendObject.UserProfile {
                    case userProfileType.Player.rawValue :
                        UserData.Club = loggedInUserObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Coach.rawValue :
                        UserData.Club = loggedInUserObject.CoachCurrentTeams.joinWithSeparator(",")
                        break;
                    case userProfileType.Fan.rawValue :
                        UserData.Club = loggedInUserObject.SupportingTeams.joinWithSeparator(",")
                        break;
                    default:
                        UserData.Club = loggedInUserObject.PlayerCurrentTeams.joinWithSeparator(",")
                        break;
                        
                    }

                    
                    
                    
                    UserData.Name = loggedInUserObject.fullName
                    UserData.FriendshipDateTime = NSDate().getCurrentTimeStamp()
                    
                    AcceptFriendRequest(["UserData": UserData.FriendRequestObject(UserData), "FriendData": FriendData.FriendRequestObject(FriendData)], callback: { data in
                        
                        
                        DeleteSentAndReceivedFriendRequestData(RequestObjectid!, successBlock: { data in
                            
                            if data == true {
                                if let index = friendsRequestsData.indexOf( {$0.ReceivedFrom == FriendObject.id}) {
                                    friendsRequestsData.removeAtIndex(index)
                                }
                                
                                
                                self.RequestsTblview.reloadData()
                            }
                            
                            
                            
                        })
                        
                        
                        
                        
                    })
                    
                    
                    
                })
                
                
            })
            
            
            
            
         }
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
