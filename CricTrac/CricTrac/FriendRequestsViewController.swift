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
    
    
    
    func setAllReceivedRequests() {
        
        getAllFriendRequests { (data) in
            
            for (_, req) in data {
                
                var modReq = req as! [String : AnyObject]
                
                modReq["IsSentRequest"] = false
                
                var reqData = ReceivedFriendRequest(dataObj: modReq)
                friendsRequestsData.append(reqData)
                
                self.ReloadTbl()
                
            }
            
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        friendsRequestsData.removeAll()
        
        setAllReceivedRequests()
        
        setAllSentRequestsData()
        
        
        
        
    }
    
    
    func ReloadTbl() {
        
        self.noRequestsLbl.hidden = !(friendsRequestsData.count == 0)
        
        if friendsRequestsData.count < 3 {
            self.RequestsTblViewHeight.constant = CGFloat(friendsRequestsData.count * 100)
        }
        
        
        self.RequestsTblview.reloadData()
    }
    
    
    func setAllSentRequestsData() {
        
        getAllSentFriendRequests { (data) in
            for (_, req) in data {
                
                var modReq = req as! [String : AnyObject]
            
                modReq["IsSentRequest"] = true
            
                var reqData = ReceivedFriendRequest(dataObj: modReq)
                friendsRequestsData.append(reqData)
                
                
                self.ReloadTbl()
                
            }
        }
    }
    
    
    func getFriendSuggestions() {
        
        backgroundThread(background: {
            
            KRProgressHUD.showText("Loading ...")
            getAllFriendSuggestions({
                
                var modFriendReqData = [Profile]()
                
                for (index, dat) in UserProfilesData.enumerate() {
                    
                    if friendsRequestsData.filter({$0.Name == dat.fullName }).count == 0 {
                        modFriendReqData.append(dat)
                    }
                    
                }
                
                UserProfilesData = modFriendReqData
                
                KRProgressHUD.dismiss()
                self.suggestionsTblView.reloadData()
            })
            
        })
        
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
        
        
        
        if friendsRequestsData[indexPath.row].isSentRequest == true {
            aCell.confirmBtn.hidden = true
            aCell.rejectBtn.setTitle("Delete", forState: UIControlState.Normal)
            
        }
        
        
        
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
        
        
        if friendsRequestsData.filter({$0.Name == UserProfilesData[indexPath.row].fullName}).first == nil {
            
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
        else {
            return FriendSuggestionsCell()
        }
        
        
    }
    
    func RejectFriendBtnPressed(sender: UIButton){
        
         let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to reject this request  ?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        let unfriendAction = UIAlertAction(title: "Reject", style: .Default) { action -> Void in
        
        let RequestObjectid = sender.restorationIdentifier
        if let index = friendsRequestsData.indexOf( {$0.RequestId == RequestObjectid }) {
            friendsRequestsData.removeAtIndex(index)
        }
            if friendsRequestsData.count < 3 {
                self.RequestsTblViewHeight.constant = CGFloat(friendsRequestsData.count * 100)
            }

        self.RequestsTblview.reloadData()
        backgroundThread(background: {
            DeleteSentAndReceivedFriendRequestData(RequestObjectid!, successBlock: { data in
                
            })
        })
        
        }
        
        actionSheetController.addAction(unfriendAction)
        
        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        // Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }

    public func ConfirmFriendBtnPressed(sender:UIButton!) {
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
          
            if FriendExists(FriendUserId) == nil {
                
            
            
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
                        break
                        
                    }
                
                    UserData.Name = loggedInUserObject.fullName
                    UserData.FriendshipDateTime = NSDate().getCurrentTimeStamp()
                    
                    if let index = friendsRequestsData.indexOf( {$0.ReceivedFrom == FriendObject.id}) {
                        friendsRequestsData.removeAtIndex(index)
                    }
                    if friendsRequestsData.count < 3 {
                        self.RequestsTblViewHeight.constant = CGFloat(friendsRequestsData.count * 100)
                    }

                    self.RequestsTblview.reloadData()
                    
                    
                    backgroundThread(background: { 
                        AcceptFriendRequest(["UserData": UserData.FriendRequestObject(UserData), "FriendData": FriendData.FriendRequestObject(FriendData)], callback: { data in
                            DeleteSentAndReceivedFriendRequestData(RequestObjectid!, successBlock: { data in
                                if data == true {
                                    
                                }
                            })
                        })

                    })
                    
                    
                })
            })
            }
         }
    }
    
    func AddFriendBtnPressed(sender: UIButton) {
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            
            getProfileInfoById(FriendUserId, sucessBlock: { FriendData in
                
                let FriendObject = Profile(usrObj: FriendData)
                
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

                    if let index = UserProfilesData.indexOf( {$0.id == FriendObject.id}) {
                        UserProfilesData.removeAtIndex(index)
                    }
                    
                    self.suggestionsTblView.reloadData()
                    
                    
                    backgroundThread(background: {
                        AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
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
