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
                self.RequestsTblview.reloadData()
            }
            
            
            

            
            
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
        
        aCell.confirmBtn.accessibilityIdentifier = UserProfilesData[indexPath.row].id
        
        aCell.confirmBtn.addTarget(self, action: #selector(ConfirmFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
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

    func ConfirmFriendBtnPressed(sender: UIButton) {
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            
            if let FriendObject  = UserProfilesData.filter({ $0.id == FriendUserId }).first {
                
                if let loggedInUserObject = UserProfilesData.filter({ $0.id == currentUser?.uid }).first {
                    
                    
                    var AcceptedFriendRequestData = Friends(dataObj: [:])
                    
                    AcceptedFriendRequestData.City = FriendObject.City
                    AcceptedFriendRequestData.Club = FriendObject.PlayerCurrentTeams.joinWithSeparator(",")
                    AcceptedFriendRequestData.Name = FriendObject.fullName
                    AcceptedFriendRequestData.FriendRecordIdOther = FriendObject.id
                    AcceptedFriendRequestData.FriendRecordId = loggedInUserObject.id
                    AcceptedFriendRequestData.FriendshipDateTime = NSDate().getCurrentTimeStamp() as! String
                    
                    var AcceptFriendRequestData = Friends(dataObj: [:])
                    
                    AcceptFriendRequestData.City = loggedInUserObject.City
                    AcceptFriendRequestData.Club = loggedInUserObject.PlayerCurrentTeams.joinWithSeparator(",")
                    AcceptFriendRequestData.Name = loggedInUserObject.fullName
                    AcceptFriendRequestData.FriendRecordIdOther = loggedInUserObject.id
                    AcceptFriendRequestData.FriendRecordId = FriendObject.id
                    AcceptFriendRequestData.FriendshipDateTime = NSDate().getCurrentTimeStamp() as! String

                    AcceptFriendRequest(["AcceptedFriendRequestData": AcceptedFriendRequestData.FriendRequestObject(AcceptedFriendRequestData), "AcceptFriendRequestData": AcceptFriendRequestData.FriendRequestObject(AcceptFriendRequestData)], callback: { data in
                        
                        
                        if let index = UserProfilesData.indexOf( {$0.id == FriendObject.id}) {
                            UserProfilesData.removeAtIndex(index)
                        }
                        
                        
                        self.RequestsTblview.reloadData()
                        
                    })
                }
            }
            
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
