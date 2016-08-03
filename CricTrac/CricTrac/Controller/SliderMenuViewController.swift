//
//  SliderMenuViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/28/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SCLAlertView

class SliderMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(sender: UIButton) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = userDefaults.valueForKey("loginToken"){
            
            userDefaults.removeObjectForKey("loginToken")
            
        }
        
        
        SCLAlertView().showInfo("Logout",subTitle: "Data saved is cleared, Kill the app and relaunch for now")
        
    }

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuitem", forIndexPath: indexPath) as! SliderMenuCell
        let itemTitle = menuData[indexPath.row]["title"]
        cell.menuItemName.text = itemTitle
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vcName = menuData[indexPath.row]["vc"]
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName!)
        sliderMenu.mainViewController.presentViewController(vc, animated: true, completion: nil)
        sliderMenu.setDrawerState(.Closed, animated: true)
    }

}
