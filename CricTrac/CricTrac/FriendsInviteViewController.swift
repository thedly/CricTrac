//
//  FriendsInviteViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XLPagerTabStrip

class FriendsInviteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider,ThemeChangeable {
    
    
    var friendInviteDataArray = friendInviteData
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        
    }

  
  override func viewDidLoad() {
        super.viewDidLoad()
      
        setBackgroundColor()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "INVITE")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendInviteDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("SliderMenuViewCell", forIndexPath: indexPath) as? SliderMenuViewCell {
            let itemTitle = friendInviteDataArray[indexPath.row]["title"]
            
            let menuIcon = UIImage(named: friendInviteDataArray[indexPath.row]["img"]!)
            
            cell.menuName.text = itemTitle
            
            cell.menuIcon.frame.size.width = 20
            cell.menuIcon.frame.size.height = 20
            
            cell.menuIcon.contentMode = UIViewContentMode.ScaleAspectFit;
            
            cell.menuIcon.image = menuIcon
            
            return cell

        }
        
        
        return SliderMenuViewCell()
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



