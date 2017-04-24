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

class FriendBaseViewController: ButtonBarPagerTabStripViewController,ThemeChangeable {

    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didSearchTapp(sender: UIButton){
        UIView.animateWithDuration(0.3) {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let vc  = storyboard.instantiateViewControllerWithIdentifier("FriendSearchViewController") as! FriendSearchViewController
             self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        
        self.buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.buttonBarView.frame.size.height = 40
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
       // setBackgroundColor()
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
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "DUGOUT"
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let friends = viewControllerFrom("Main", vcid: "FriendsViewController")
        let friendReq = viewControllerFrom("Main", vcid: "FriendRequestsViewController")
        let friendSug = viewControllerFrom("Main", vcid: "FriendSuggestViewController")
        let friendInv = viewControllerFrom("Main", vcid: "FriendsInviteViewController")
        return [friends, friendReq, friendSug, friendInv]
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}
