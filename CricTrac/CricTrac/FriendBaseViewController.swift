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

class FriendBaseViewController: ButtonBarPagerTabStripViewController,ThemeChangeable{

    var topicId:String = ""
    var topic:String = ""
   
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didSearchTapp(sender: UIButton){
        UIView.animateWithDuration(0.3) {
           // self.view.backgroundColor = cricTracTheme.currentTheme.topColor
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let vc  = storyboard.instantiateViewControllerWithIdentifier("FriendSearchViewController") as! FriendSearchViewController
             self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        //sajith commented for Notifications
        //navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
      //  self.view.backgroundColor = UIColor.clearColor()
        setNavigationBarProperties()
        
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
       
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.blackColor()
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        
        self.buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.buttonBarView.frame.size.height = 45
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 14)!
        settings.style.buttonBarItemLeftRightMargin = 0
        settings.style.buttonBarMinimumLineSpacing = 1
        
      
        
       
        setNavigationBarProperties()
       definesPresentationContext = true
       
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
        
        if topicId == ""  {
             //self.topBarViewHeightConstraint.constant = 0
            self.navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        }
        else {
           // self.topBarViewHeightConstraint.constant = 56
            self.topBarView.backgroundColor = currentTheme.topColor
        }
        title = "DUGOUT"
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let friends = viewControllerFrom("Main", vcid: "FollowingViewController")
        let friendReq = viewControllerFrom("Main", vcid: "FollowerListViewController")
        let friendSug = viewControllerFrom("Main", vcid: "FriendSuggestViewController")
        let friendInv = viewControllerFrom("Main", vcid: "FriendsInviteViewController")
        //let celebritiesVC = viewControllerFrom("Main", vcid: "FollowerAndFollowingViewController")
        return [friends, friendReq,friendSug, friendInv]
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}
