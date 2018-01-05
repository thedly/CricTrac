//
//  FriendSearchViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FriendSearchViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable, UISearchBarDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var friendSearchTbl: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var SearchDisplayCtrlr: UISearchDisplayController!
    var searchedProfiles = [Profile]()
    var currentTheme:CTTheme!
   
    var followingIds = [String]()
    var followingNodeId = [String]()
    var followingNodeIdOther = [String]()
    

    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
      
        
    }
    func setNavigationBarProperties(){
        
        currentTheme = cricTracTheme.currentTheme
        let backButton: UIButton = UIButton(type:.Custom)
        backButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(didBackButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        backButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftbarButton
         // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    func didBackButtonTapp() {
       self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didSearchTapp(sender: UIButton){
        UIView.animateWithDuration(0.3) {
            self.searchBar.hidden = false
            self.searchBar.alpha = 1
            //self.searchResultsTblView.alpha = 1
            self.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        //self.view.backgroundColor = UIColor.clearColor()
        self.searchBar.becomeFirstResponder()
        getFollowingIds()
        
    }
    
    func getFollowingIds() {
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
    }
    
    override func viewDidLoad() {
         friendSearchTbl.registerNib(UINib.init(nibName:"FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        super.viewDidLoad()
        setBackgroundColor()
        setNavigationBarProperties()
        self.title = "SEARCH"
        self.searchBar.hidden = false
        self.searchBar.alpha = 1
        self.friendSearchTbl.alpha = 1
        self.searchBar.becomeFirstResponder()
        
        searchBar.delegate = self
        friendSearchTbl.delegate = self
        friendSearchTbl.dataSource = self
        definesPresentationContext = true

        
        self.searchBar.returnKeyType = UIReturnKeyType.Done
        SearchDisplayCtrlr.searchResultsTableView.backgroundColor = cricTracTheme.currentTheme.topColor
        searchBar.barTintColor = cricTracTheme.currentTheme.bottomColor
        
       navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedProfiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchedProfiles.count > 0 {
            return getCellForSearchedParametersRow(indexPath)
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }

    func getCellForSearchedParametersRow(indexPath:NSIndexPath)->FriendSuggestionsCell{
        if let aCell =  friendSearchTbl.dequeueReusableCellWithIdentifier("FriendSuggestionsCell") as? FriendSuggestionsCell {
            if searchedProfiles.count > 0 && indexPath.row < searchedProfiles.count {
                
                let searchFriendUserId = searchedProfiles[indexPath.row].id
                aCell.friendId = searchFriendUserId
                
                fetchBasicProfile(searchFriendUserId, sucess: { (result) in
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
                    
                    // sravani - mark for follow
                    
                    if self.followingIds.contains(searchFriendUserId) {
                        
                        aCell.FollowBtn.setTitle("FOLLOWING", forState: .Normal)
                        let indexNub = self.followingIds.indexOf(searchFriendUserId)
                        print(indexNub)
                        aCell.FollowBtn.accessibilityValue = self.followingNodeId[indexNub!]
                        aCell.FollowBtn.accessibilityHint = self.followingNodeIdOther[indexNub!]
                        aCell.FollowBtn.userInteractionEnabled = false
                        //aCell.FollowBtn.alpha = 0.7
                        aCell.FollowBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                        
                    }
                        
                    else {
                        aCell.FollowBtn.setTitle("FOLLOW", forState: .Normal)
                        aCell.FollowBtn.userInteractionEnabled = true
                        aCell.FollowBtn.alpha = 1
                        aCell.FollowBtn.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                        
                       // aCell.FollowBtn.accessibilityLabel = aCell.FollowBtn.titleLabel?.text
                        
                        aCell.FollowBtn.addTarget(self, action: #selector(self.followBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    }
                    
                    
                })
                
                aCell.FollowBtn.accessibilityIdentifier = searchedProfiles[indexPath.row].id
                aCell.FollowBtn.tag = indexPath.row
                aCell.FollowBtn.accessibilityLabel = aCell.FollowBtn.titleLabel?.text
                
                //aCell.configureCell(searchedProfiles[indexPath.row])
                aCell.userName.text = searchedProfiles[indexPath.row].fullName
                aCell.AddFriendBtn.accessibilityIdentifier = searchedProfiles[indexPath.row].id
                aCell.AddFriendBtn.addTarget(self, action: #selector(AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
               
                aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
                aCell.backgroundColor = UIColor.clearColor()
                aCell.selectionStyle = .None
            }
            return aCell
        }
        else {
            return FriendSuggestionsCell()
        }
    }
    
    func followBtnPressed(sender: UIButton) {
        
        let indexP = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = friendSearchTbl.cellForRowAtIndexPath(indexP) as! FriendSuggestionsCell
        
        let newStr = sender.accessibilityLabel!
        if newStr == "FOLLOW" {
            createFollowingAndFollowers(sender.accessibilityIdentifier!)
            cell.FollowBtn.setTitle("FOLLOWING", forState: .Normal)
            cell.FollowBtn.userInteractionEnabled = false
            cell.FollowBtn.titleLabel?.textColor = UIColor.grayColor()
            //cell.FollowBtn.alpha = 0.7
            
        }
        
    }

    func AddFriendBtnPressed(sender:UIButton) {
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
                    
                    if let index = self.searchedProfiles.indexOf( {$0.id == FriendObject.id}) {
                        self.searchedProfiles.removeAtIndex(index)
                    }
                    
                    
                    backgroundThread(background: {
                        AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                //self.searchedProfiles.removeAll()
                                self.friendSearchTbl.reloadData()
                                
                            })
                        })
                    })
                })
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 2 {
            backgroundThread(background: {
                searchProfiles(searchText, sucessBlock: { data in
                    if let searchedData = data as? [Profile] {
                        self.searchedProfiles.removeAll()
                        for profile in searchedData {
                            self.searchedProfiles.append(profile)
                        }
                        self.friendSearchTbl.reloadData()
                    }
                })
            })
        }
        else if searchText.characters.count == 0 {
            self.searchedProfiles.removeAll()
            self.friendSearchTbl.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBarCancelButtonClicked(searchBar)
    }
    
    func searchrefresh(searchBar: UISearchBar){
        searchBar.text = ""
        searchBar.endEditing(true)
        self.searchedProfiles.removeAll()
        self.friendSearchTbl.reloadData()
        SearchDisplayCtrlr.active = false
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchrefresh(searchBar)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        UIView.animateWithDuration(0.5) {
            //self.searchBar.alpha = 0
           // self.searchBar.hidden = true
        }
    }
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SEARCH")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
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
