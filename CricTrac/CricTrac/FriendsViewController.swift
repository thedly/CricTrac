//
//  FriendsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Kingfisher
import GoogleMobileAds

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider,ThemeChangeable {
    
    @IBOutlet weak var FriendsInfoLabelheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var friendsInfoLabel: UILabel!
    
     @IBOutlet weak var bannerView: GADBannerView!
     @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
       
    }
    
    @IBOutlet weak var SuggestsTblview: UITableView!
    var currentTheme:CTTheme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        // Do any additional setup after loading the view.
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
    override func viewWillAppear(animated: Bool) {
         self.SuggestsTblview.reloadData()
        self.view.backgroundColor = UIColor.clearColor()
        //setBackgroundColor()
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    func initializeView() {
        SuggestsTblview.registerNib(UINib.init(nibName:"FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        SuggestsTblview.allowsSelection = false
        SuggestsTblview.separatorStyle = .None
        SuggestsTblview.dataSource = self
        SuggestsTblview.delegate = self
        //setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
               self.view.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getAllFriends { (data) in
            friendsDataArray.removeAll()
            for (_, req) in data {
                if let dat = req as? [String : AnyObject] {
                    let reqData = Friends(dataObj: dat)
                    friendsDataArray.append(reqData)
                }
            }
            self.SuggestsTblview.reloadData()
            // do something here
        }
    }
    
    
    func getCellForRow(indexPath:NSIndexPath)->FriendsCell{
        
        let aCell =  SuggestsTblview.dequeueReusableCellWithIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsCell
        
        let friendUserId = friendsDataArray[indexPath.row].UserId
        aCell.friendId = friendUserId
        fetchBasicProfile(friendUserId, sucess: { (result) in
            let proPic = result["proPic"]
            let city =   result["city"]
            
            let userProfile = result["userProfile"]
            let name = "\(result["firstname"]!) \(result["lastname"]!)"
            aCell.FriendCity.text = city
            aCell.FriendName.text = name
            
            if userProfile == "Player" {
                fetchPlayingRole(friendUserId, sucess: { (result) in
                    let playingRole = result["playingRole"]
                    aCell.friendRole.text = playingRole
                })
            }

           else if userProfile == "Coach" {
                aCell.friendRole.text = "Coach"
            }
            else if userProfile == "Cricket Fan" {
                aCell.friendRole.text = "Cricket Fan"
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
        })
        
        
       // aCell.FriendName.text = friendsDataArray[indexPath.row].Name
        //aCell.FriendCity.text = friendsDataArray[indexPath.row].City
        //aCell.FriendProfileImage.image = extractImages(friendsDataArray[indexPath.row].UserId!)
        aCell.UnfriendBtn.addTarget(self, action: #selector(FriendsViewController.UnfriendBtnBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        aCell.UnfriendBtn.restorationIdentifier = friendsDataArray[indexPath.row].FriendRecordId

         aCell.baseView.alpha = 1
        aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FRIENDS")
    }
    
    // MARK: - Table delegate functions
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if friendsDataArray.count == 0 {
            self.FriendsInfoLabelheightConstraint.constant = 38
            
            self.friendsInfoLabel.text = "You have no friends."
        }
        else {
            self.FriendsInfoLabelheightConstraint.constant = 0
        }
        return friendsDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return getCellForRow(indexPath)
    }
    
    func UnfriendBtnBtnPressed(sender: UIButton) {
        let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to remove this friend?", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        
        // Create and add first option action
        let unfriendAction = UIAlertAction(title: "Unfriend", style: .Default) { action -> Void in
            let friendReqId = sender.restorationIdentifier!
            
            DeleteFriendRequestData(friendReqId, successBlock: { data in
                if data == true {
                    if let index = friendsDataArray.indexOf( {$0.FriendRecordId == friendReqId}) {
                        friendsDataArray.removeAtIndex(index)
                    }
                    self.SuggestsTblview.reloadData()
                }
            })
        }
        actionSheetController.addAction(unfriendAction)
        
        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        // Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
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


