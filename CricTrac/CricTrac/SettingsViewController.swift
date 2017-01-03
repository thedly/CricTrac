//
//  SettingsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 01/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var SettingsTableView: UITableView!
    
    
    @IBAction func closeBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initializeView() {
        
        SettingsTableView.registerNib(UINib.init(nibName:"SettingsViewCell", bundle: nil), forCellReuseIdentifier: "SettingsViewCell")
        SettingsTableView.separatorStyle = .SingleLine
        SettingsTableView.dataSource = self
        SettingsTableView.delegate = self
        
        setUIBackgroundTheme(self.view)
        
    }
    
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMenuData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsViewCell", forIndexPath: indexPath) as! SettingsViewCell
        let itemTitle = settingsMenuData[indexPath.row]["title"] as! String
        
        let menuIcon = UIImage(named: settingsMenuData[indexPath.row]["img"]! as! String)
        
        let menuDesc = settingsMenuData[indexPath.row]["desc"] as! String
        let selectedValue = "hello World"
        
        let toggleConfig = settingsMenuData[indexPath.row]["IsSwitchVisible"] as! Bool
        
        
        cell.backgroundColor = UIColor.clearColor()
        
        
        cell.menuItemName.text = itemTitle
        cell.menuItemIcon.image = menuIcon
        cell.menuItemSelectedValue.text = selectedValue
        
        
        cell.menuItemToggleSwitch.hidden = !toggleConfig
        cell.menuItemSelectedValue.hidden = toggleConfig
        
        
        cell.menuItemDescription.text = menuDesc
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vcName = settingsMenuData[indexPath.row]["vc"]
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName! as! String)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
