//
//  FriendBaseViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import KRProgressHUD

class FriendBaseViewController: ButtonBarPagerTabStripViewController,ThemeChangeable, UISearchResultsUpdating, UISearchBarDelegate {

    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    @IBOutlet var SearchDisplayCtrlr: UISearchDisplayController!
    
    func didSearchTapp(sender: UIButton){
        UIView.animateWithDuration(0.3) {
            self.searchBar.hidden = false
            self.searchBar.alpha = 1
            //self.searchResultsTblView.alpha = 1
            self.searchBar.becomeFirstResponder()
        }
    }
    
    var searchedProfiles = [Profile]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTblView: UITableView!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTblView.registerNib(UINib.init(nibName:"FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        self.buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.buttonBarView.frame.size.height = 40
        searchBar.delegate = self
        searchBar.alpha = 0
        self.searchBar.hidden = true
        searchResultsTblView.alpha = 0
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        setBackgroundColor()
        setNavigationBarProperties()
        self.searchBar.returnKeyType = UIReturnKeyType.Done
        SearchDisplayCtrlr.searchResultsTableView.backgroundColor = cricTracTheme.currentTheme.topColor
        searchBar.barTintColor = cricTracTheme.currentTheme.bottomColor
//        searchResultsTblView.dataSource = self
//        searchResultsTblView.delegate = self
        definesPresentationContext = true
        //self.view.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view.
    }

    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let searchButton: UIButton = UIButton(type:.Custom)
        searchButton.frame = CGRectMake(0, 0, 20, 20)
        searchButton.setImage(UIImage(named: "Search-100"), forState: UIControlState.Normal)
        searchButton.addTarget(self, action: #selector(didSearchTapp), forControlEvents: UIControlEvents.TouchUpInside)
        
        let righttbarButton = UIBarButtonItem(customView: searchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "DUGOUT"
        
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let friends = viewControllerFrom("Main", vcid: "FriendsViewController")
        let friendReq = viewControllerFrom("Main", vcid: "FriendRequestsViewController")
        let friendInv = viewControllerFrom("Main", vcid: "FriendsInviteViewController")
        return [friends, friendReq, friendInv]
    }
    
    func getCellForSearchedParametersRow(indexPath:NSIndexPath)->FriendSuggestionsCell{
        if let aCell =  searchResultsTblView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell") as? FriendSuggestionsCell {
            if searchedProfiles.count > 0 && indexPath.row < searchedProfiles.count {
                aCell.configureCell(searchedProfiles[indexPath.row])
                aCell.AddFriendBtn.accessibilityIdentifier = searchedProfiles[indexPath.row].id
                aCell.AddFriendBtn.addTarget(self, action: #selector(AddFriendBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                aCell.backgroundColor = UIColor.clearColor()
                aCell.selectionStyle = .None
            }
            return aCell
        }
        else {
            return FriendSuggestionsCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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
        return 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
        
    }
    
    func AddFriendBtnPressed(sender:UIButton) {
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
                    
                    //KRProgressHUD.show(progressHUDStyle: .White, message: "Friend Request Sent")
                    //KRProgressHUD.dismiss()
                    self.searchBar.text = ""
                    
                    backgroundThread(background: {
                        AddSentRequestData(["sentRequestData": sendFriendRequestData.GetFriendRequestObject(sendFriendRequestData), "ReceivedRequestData": receiveFriendRequestData.getFriendRequestObject(receiveFriendRequestData)], callback: { data in
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                self.searchedProfiles.removeAll()
                                self.searchResultsTblView.reloadData()
                                //self.setRequests()
                                //self.searchResultsTblView.reloadData()
                                //self.suggestionsTblView.reloadData()
                            })
                        })
                    })
                })
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 1 {
            backgroundThread(background: {
                searchProfiles(searchText, sucessBlock: { data in
                    if let searchedData = data as? [Profile] {
                        self.searchedProfiles.removeAll()
                        for profile in searchedData {
                            self.searchedProfiles.append(profile)
                        }
//                        self.searchResultsTblView.reloadData()
                    }
                })
            })
        }
        else if searchText.characters.count == 0 {
            self.searchedProfiles.removeAll()
            self.searchResultsTblView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBarCancelButtonClicked(searchBar)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
//
//            // 1
//            filteredData.removeAll(keepCapacity: false)
//            // 2
//            let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", searchController.searchBar.text!)
//            // 3
//            let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
//            // 4
//            filteredData = array as! [String]
//            // 5
//            tableView.reloadData()
//            
//        }
//        else {
//            
//            filteredData.removeAll(keepCapacity: false)
//            
//            filteredData = tableData
//            
//            tableView.reloadData()
//            
        }
    }
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        
//        
//        
//        
//    }
    
    func searchrefresh(searchBar: UISearchBar){
        searchBar.text = ""
        searchBar.endEditing(true)
        self.searchedProfiles.removeAll()
        self.searchResultsTblView.reloadData()
        SearchDisplayCtrlr.active = false
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchrefresh(searchBar)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        UIView.animateWithDuration(0.5) {
            self.searchBar.alpha = 0
            self.searchBar.hidden = true
        }
    }
}
