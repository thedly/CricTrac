
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
import GoogleMobileAds

class FriendSuggestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider,ThemeChangeable {
    @IBOutlet weak var SuggestsTblview: UITableView!
     @IBOutlet weak var bannerView: GADBannerView!
     @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    var currentTheme:CTTheme!
    
    var followingIds = [String]()
    var followingNodeId = [String]()
    var followingNodeIdOther = [String]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        // Do any additional setup after loading the view.
        
        UserProfilesData.removeAll()
        self.SuggestsTblview.reloadData()
        getFriendSuggestions()
        self.view.backgroundColor = UIColor.clearColor()
        
        loadBannerAds()
    }
    
    func loadBannerAds() {
        if showAds == "1" {
            self.bannerViewHeightConstraint.constant = 50
            bannerView.adUnitID = adUnitId
            bannerView.rootViewController = self
            bannerView.loadRequest(GADRequest())
        }
        else {
            self.bannerViewHeightConstraint.constant = 0
        }
    }
    
//    override func viewWillAppear(animated: Bool) {
//        UserProfilesData.removeAll()
//        self.SuggestsTblview.reloadData()
//        getFriendSuggestions()
//        self.view.backgroundColor = UIColor.clearColor()
//        //setBackgroundColor()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    func initializeView() {
        SuggestsTblview.registerNib(UINib.init(nibName:"FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        SuggestsTblview.allowsSelection = false
        SuggestsTblview.separatorStyle = .None
        SuggestsTblview.dataSource = self
        SuggestsTblview.delegate = self
        
        //setUIBackgroundTheme(self.view)
        
        //getFriendSuggestions()
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SUGGESTIONS")
    }
    
    func getFriendSuggestions() {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        backgroundThread(background: {
            KRProgressHUD.showText("Loading ...")
            
            //sravani - mark for follow
            
            getMyFollowingList { (data) in
                
                self.followingIds.removeAll()
                self.followingNodeId.removeAll()
                self.followingNodeIdOther.removeAll()
                
                for(_,req) in data {
                    let followingId = req["FollowingId"] as? String
                    
                    self.followingIds.append(followingId!)
                    self.followingNodeId.append(req["FollowingNodeId"] as! String)
                    self.followingNodeIdOther.append(req["FollowingNodeIdOther"] as! String)
                    
                }
            }
            
            
            getAllFriendSuggestions({
//                var modFriendReqData = [Profile]()
//                for (_, dat) in UserProfilesData.enumerate() {
//                    //if FriendRequestsData.filter({$0.Name == dat.fullName }).count == 0 {
//                        modFriendReqData.append(dat)
//                    //}
//                }
//                UserProfilesData.removeAll()
//                UserProfilesData = modFriendReqData
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    self.SuggestsTblview.reloadData()
                    KRProgressHUD.dismiss()
                })
            })
        })
    }

    
    // MARK: - Table delegate functions
    
    @IBAction func getAllProfilesBtnPressed(sender: AnyObject) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserProfilesData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return getCellForSuggestionsRow(indexPath)
    }
    
    func getCellForSuggestionsRow(indexPath:NSIndexPath)->FriendSuggestionsCell{
        //if FriendRequestsData.filter({$0.Name == UserProfilesData[indexPath.row].fullName}).first == nil {
            if let aCell =  SuggestsTblview.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as? FriendSuggestionsCell {
                
                let sugFriendUserId = UserProfilesData[indexPath.row].id
                aCell.friendId = sugFriendUserId
              
                fetchBasicProfile(sugFriendUserId, sucess: { (result) in
                    let proPic = result["proPic"]
                    let city =   result["city"]
                    let userProfile = result["userProfile"]
                    let playingRole = result["playingRole"]
                    
                    aCell.userCity.text = city
                    
                    if userProfile == "Player" {
                     aCell.userRole.text = playingRole
                    }
                        
                    else if userProfile == "Coach" {
                        aCell.userRole.text = "Coach"
                    }
                    else if userProfile == "Cricket Fan" {
                        aCell.userRole.text = "Cricket Fan"
                    }

                    
                    
                    if proPic! == "-"{
                        let imageName = defaultProfileImage
                        let image = UIImage(named: imageName)
                        aCell.userProfileView.image = image
                    }else{
                        if let imageURL = NSURL(string:proPic!){
                            aCell.userProfileView.kf_setImageWithURL(imageURL)
                        }
                    }
                })
                
                //aCell.configureCell(UserProfilesData[indexPath.row])
                aCell.userName.text = UserProfilesData[indexPath.row].fullName
                aCell.AddFriendBtn.accessibilityIdentifier = UserProfilesData[indexPath.row].id
                aCell.AddFriendBtn.addTarget(self, action: #selector(AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                // sravani - mark for follow
                
                if followingIds.contains(sugFriendUserId) {
                    
                    aCell.FollowBtn.setTitle("FOLLOWING", forState: .Normal)
                    let indexNub = followingIds.indexOf(sugFriendUserId)
                    print(indexNub)
                    aCell.FollowBtn.accessibilityValue = followingNodeId[indexNub!]
                    aCell.FollowBtn.accessibilityHint = followingNodeIdOther[indexNub!]
                    aCell.FollowBtn.accessibilityLabel = aCell.FollowBtn.titleLabel?.text
                    aCell.FollowBtn.userInteractionEnabled = false
                    aCell.FollowBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                   // aCell.FollowBtn.alpha = 0.2
                    
                }
                    
                else {
                     aCell.FollowBtn.setTitle("FOLLOW", forState: .Normal)
                    aCell.FollowBtn.userInteractionEnabled = true
                    aCell.FollowBtn.alpha = 1
                   // aCell.FollowBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                    aCell.FollowBtn.setTitleColor(UIColor(red: 104/255, green: 187/255, blue: 2/255, alpha: 1.0), forState: .Normal)
                    
                    aCell.FollowBtn.accessibilityLabel = aCell.FollowBtn.titleLabel?.text
                    
                    aCell.FollowBtn.addTarget(self, action: #selector(followBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    aCell.FollowBtn.accessibilityIdentifier = UserProfilesData[indexPath.row].id

                }
                
                aCell.FollowBtn.tag = indexPath.row

                
               aCell.baseView.alpha = 1
              aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
                aCell.backgroundColor = UIColor.clearColor()
                return aCell
            }
            else {
                return FriendSuggestionsCell()
            }
//        }
//        else {
//            return FriendSuggestionsCell()
//        }
    }
    
    func AddFriendBtnPressed(sender: UIButton) {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            getProfileInfoById(FriendUserId, sucessBlock: { FriendData in
                let FriendObject = Profile(usrObj: FriendData)
                getProfileInfoById((currentUser?.uid)!, sucessBlock: { data in
                    let loggedInUserObject = Profile(usrObj: data)
                    let sendFriendRequestData = SentFriendRequest()
                    sendFriendRequestData.City = FriendObject.City
                    sendFriendRequestData.Name = FriendObject.fullName
                    sendFriendRequestData.SentTo = FriendObject.id
                    sendFriendRequestData.SentDateTime = NSDate().getCurrentTimeStamp()
                    
                    let receiveFriendRequestData = ReceivedFriendRequest()
                    receiveFriendRequestData.City = loggedInUserObject.City
                    
                    receiveFriendRequestData.Name = loggedInUserObject.fullName
                    receiveFriendRequestData.ReceivedFrom = loggedInUserObject.id
                    receiveFriendRequestData.ReceivedDateTime = NSDate().getCurrentTimeStamp()
                    
                    if let index = UserProfilesData.indexOf( {$0.id == FriendObject.id}) {
                        UserProfilesData.removeAtIndex(index)
                    }
                    
                    backgroundThread(background: {
                        AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                self.SuggestsTblview.reloadData()
                            })
                        })
                    })
                })
            })
            let alert = UIAlertController(title: "", message:"Friend Request Sent", preferredStyle: UIAlertControllerStyle.Alert)
            //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            let delay = 1.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: nil)
            })


        }
    }
    
    // sravani - mark for follow 
    
    func followBtnPressed(sender: UIButton) {
        
        let indexP = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = SuggestsTblview.cellForRowAtIndexPath(indexP) as! FriendSuggestionsCell
        
        if followingIds.contains(sender.accessibilityIdentifier!) {
            
        }
        else {
            createFollowingAndFollowers(sender.accessibilityIdentifier!)
            cell.FollowBtn.setTitle("FOLLOWING", forState: .Normal)
            cell.FollowBtn.userInteractionEnabled = false
            cell.FollowBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            
            //call the follow notification api
            followNotification(sender.accessibilityIdentifier!)
            
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

