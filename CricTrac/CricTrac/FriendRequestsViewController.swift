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
import GoogleMobileAds

class FriendRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider,ThemeChangeable {
    @IBOutlet weak var RequestsTblViewHeight: NSLayoutConstraint!
    @IBOutlet weak var suggestionsTblView: UITableView!
    @IBOutlet weak var noRequestsLbl: UILabel!
    @IBOutlet weak var RequestsTblview: UITableView!
    @IBOutlet weak var noRequestLblHeightConstraint: NSLayoutConstraint!
    
     @IBOutlet weak var bannerView: GADBannerView!
     @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
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
        RequestsTblview.registerNib(UINib.init(nibName:"FriendRequestsCell", bundle: nil), forCellReuseIdentifier: "FriendRequestsCell")
        RequestsTblview.allowsSelection = false
        RequestsTblview.separatorStyle = .None
        RequestsTblview.dataSource = self
        RequestsTblview.delegate = self

        self.view.backgroundColor = UIColor.clearColor()
        //getFriendSuggestions()
    }
    
    override func viewWillAppear(animated: Bool) {
        //setBackgroundColor()
        self.view.backgroundColor = UIColor.clearColor()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
      
        setRequests();
        //self.RequestsTblview.reloadData()
    }
    
    func setRequests(){
        FriendRequestsData.removeAll()
        self.setAllReceivedRequests()
        self.setAllSentRequestsData()
    }
    
    func AdjustHeight(){

    }
    
    func ReloadTbl() {
        setRequests()
    }
    
    func setAllReceivedRequests() {
        getAllFriendRequests { (data) in
            for (_, req) in data {
                var modReq = req as! [String : AnyObject]
                modReq["IsSentRequest"] = false
                let reqData = RequestsData(dataObj: modReq)
                FriendRequestsData.append(reqData)
            }
            dispatch_async(dispatch_get_main_queue(),{
                
                self.RequestsTblview.reloadData()
                self.AdjustHeight()
            })
        }
    }
    
    func setAllSentRequestsData() {
        getAllSentFriendRequests { (data) in
            for (_, req) in data {
                //let reqData = ReceivedFriendRequest(dataObj: req as! [String : AnyObject])
                //friendsRequestsData.append(reqData)
                var modReq = req as! [String : AnyObject]
                modReq["IsSentRequest"] = true
                let reqData = RequestsData(dataObj: modReq)
                FriendRequestsData.append(reqData)
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.RequestsTblview.reloadData()
                self.AdjustHeight()
                
            })
        }
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "REQUESTS")
    }
    
        
    func getCellForRow(indexPath:NSIndexPath)->FriendRequestsCell{
        let aCell =  RequestsTblview.dequeueReusableCellWithIdentifier("FriendRequestsCell", forIndexPath: indexPath) as! FriendRequestsCell
        if FriendRequestsData[indexPath.row].isSentRequest == true {
            
            let reqFriendUserId = FriendRequestsData[indexPath.row].SentTo
            aCell.friendId = reqFriendUserId

            fetchBasicProfile(reqFriendUserId, sucess: { (result) in
                let proPic = result["proPic"]
                let city =   result["city"]
                let name = "\(result["firstname"]!) \(result["lastname"]!)"
                aCell.FriendCity.text = city
                aCell.FriendName.text = name
                
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
            
            aCell.confirmBtn.hidden = true
            aCell.rejectBtn.hidden = true
            aCell.cancelBtn.hidden = false
            //aCell.rejectBtn.setTitle("CANCEL", forState: UIControlState.Normal)
           // aCell.FriendName.text = FriendRequestsData[indexPath.row].Name
            //aCell.FriendCity.text = FriendRequestsData[indexPath.row].City
            //aCell.FriendProfileImage.image = extractImages(FriendRequestsData[indexPath.row].SentTo)
            //aCell.confirmBtn.accessibilityIdentifier = FriendRequestsData[indexPath.row].SentTo
            //aCell.confirmBtn.restorationIdentifier = FriendRequestsData[indexPath.row].SentRequestId
            aCell.cancelBtn.restorationIdentifier = FriendRequestsData[indexPath.row].SentRequestId
            aCell.cancelBtn.addTarget(self, action: #selector(FriendRequestsViewController.CancelRequest(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        else
        {
            let reqFriendUserId = FriendRequestsData[indexPath.row].ReceivedFrom
            aCell.friendId = reqFriendUserId

            fetchBasicProfile(reqFriendUserId, sucess: { (result) in
                let proPic = result["proPic"]
                let city =   result["city"]
                let name = "\(result["firstname"]!) \(result["lastname"]!)"
                aCell.FriendCity.text = city
                aCell.FriendName.text = name
                
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
            
            aCell.confirmBtn.hidden = false
            aCell.rejectBtn.hidden = false
            aCell.cancelBtn.hidden = true
            //aCell.rejectBtn.setTitle("REJECT", forState: UIControlState.Normal)
            //aCell.FriendName.text = FriendRequestsData[indexPath.row].Name
            //aCell.FriendCity.text = FriendRequestsData[indexPath.row].City
            //aCell.FriendProfileImage.image = extractImages(FriendRequestsData[indexPath.row].ReceivedFrom)
            aCell.confirmBtn.accessibilityIdentifier = FriendRequestsData[indexPath.row].ReceivedFrom
            aCell.confirmBtn.restorationIdentifier = FriendRequestsData[indexPath.row].RequestId
            aCell.rejectBtn.restorationIdentifier = FriendRequestsData[indexPath.row].RequestId
            aCell.rejectBtn.addTarget(self, action: #selector(FriendRequestsViewController.RejectFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            aCell.confirmBtn.addTarget(self, action: #selector(FriendRequestsViewController.ConfirmFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
         aCell.baseView.alpha = 1
         aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
    }
    // MARK: - Table delegate functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FriendRequestsData.count == 0 {
            self.noRequestLblHeightConstraint.constant = 38
            self.noRequestsLbl.text = "No pending request"
        }
        else {
            self.noRequestLblHeightConstraint.constant = 0
        }
        
        
        return FriendRequestsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return getCellForRow(indexPath)
    }

    
    func CancelRequest(sender: UIButton){
        let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Cancel this request?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Ignore", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        let unfriendAction = UIAlertAction(title: "Cancel Request", style: .Default) { action -> Void in
            let RequestObjectid = sender.restorationIdentifier
        
            if let index = FriendRequestsData.indexOf( {$0.SentRequestId == RequestObjectid }) {
                FriendRequestsData.removeAtIndex(index)
            }
            
            //self.ReloadTbl()
            
            backgroundThread(background: {
                CancelSentFriendRequestData(RequestObjectid!, successBlock: { (data) in
                
                    dispatch_async(dispatch_get_main_queue(),{
                        self.setRequests()
                        self.RequestsTblview.reloadData()
                        //self.suggestionsTblView.reloadData()
                    })
                })
            })
        }
        actionSheetController.addAction(unfriendAction)
        
        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        // Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    func RejectFriendBtnPressed(sender: UIButton){
         let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Reject this request?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            // Just dismiss the action sheet
            actionSheetController.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        let unfriendAction = UIAlertAction(title: "Reject", style: .Default) { action -> Void in
        let RequestObjectid = sender.restorationIdentifier
         
            if let index = FriendRequestsData.indexOf( {$0.RequestId == RequestObjectid }) {
                FriendRequestsData.removeAtIndex(index)
            }
        
            self.ReloadTbl()
            backgroundThread(background: {
                DeleteSentAndReceivedFriendRequestData(RequestObjectid!, successBlock: { data in
                
                    dispatch_async(dispatch_get_main_queue(),{
                        self.setRequests()
                        self.RequestsTblview.reloadData()
                        //self.suggestionsTblView.reloadData()
                    })
                })
            })
        }
        actionSheetController.addAction(unfriendAction)
        
        // We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        
        // Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

     func ConfirmFriendBtnPressed(sender:UIButton!) {
        // network reachability test
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.reachability.isReachable()  {
            let alert = UIAlertController(title: "", message: networkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let FriendUserId = sender.accessibilityIdentifier where FriendUserId != "" {
            if FriendExists(FriendUserId) == nil {
                var FriendObject = Profile(usrObj: [:])
                var loggedInUserObject = Profile(usrObj: [:])
                
                getProfileInfoById(FriendUserId, sucessBlock: { FriendData in
                    FriendObject = Profile(usrObj: FriendData)
                    
                    getProfileInfoById((currentUser?.uid)!, sucessBlock: { loggedInUserObjectData in
                        loggedInUserObject = Profile(usrObj: loggedInUserObjectData)
                        
                        let RequestObjectid = sender.restorationIdentifier
                        let FriendData = Friends(dataObj: [:])
                        
                        FriendData.UserId = FriendObject.id
                        FriendData.City = FriendObject.City
                        FriendData.Name = FriendObject.fullName
                        FriendData.FriendshipDateTime = NSDate().getCurrentTimeStamp()
                        
                        let UserData = Friends(dataObj: [:])
                        
                        UserData.UserId = loggedInUserObject.id
                        UserData.City = loggedInUserObject.City
                        UserData.Name = loggedInUserObject.fullName
                        UserData.FriendshipDateTime = NSDate().getCurrentTimeStamp()
                        
                        self.ReloadTbl()
                        
                        backgroundThread(background: {
                            AcceptFriendRequest(["UserData": UserData.FriendRequestObject(UserData), "FriendData": FriendData.FriendRequestObject(FriendData)], callback: { data in
                                DeleteSentAndReceivedFriendRequestData(RequestObjectid!, successBlock: { data in
                                    
                                    dispatch_async(dispatch_get_main_queue(),{
                                        self.setRequests()
                                        self.RequestsTblview.reloadData()
                                        //self.suggestionsTblView.reloadData()
                                    })
                                })
                            })
                        })
                    })
                })
            }
            let alert = UIAlertController(title: "", message:"Friend Request Confirmed", preferredStyle: UIAlertControllerStyle.Alert)
           // alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            let delay = 1.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: nil)
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
