//
//  FriendBaseViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FriendBaseViewController: ButtonBarPagerTabStripViewController,ThemeChangeable {

    @IBAction func didTapCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        
        
        
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        
        setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let friends = viewControllerFrom("Main", vcid: "FriendsViewController")
        
        let friendReq = viewControllerFrom("Main", vcid: "FriendRequestsViewController")
        
        let friendSug = viewControllerFrom("Main", vcid: "FriendSuggestViewController")
        
        
        return [friends, friendReq, friendSug]
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
