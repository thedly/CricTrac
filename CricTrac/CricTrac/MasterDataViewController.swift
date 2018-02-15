//
//  MasterDataViewController.swift
//  CricTrac
//
//  Created by AIPL on 06/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class MasterDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

      @IBOutlet weak var tableView: UITableView!
    let masterArray = ["Teams","Opponents","Venue","Tournaments","Grounds"]
      var currentTheme: CTTheme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationProperties()
        setBackgroundColor()
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    func setNavigationProperties() {
      
        currentTheme = cricTracTheme.currentTheme
        
        let menuButton:UIButton = UIButton(type: .Custom)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1)
        menuButton.addTarget(self, action: #selector(CloseBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButton = UIBarButtonItem(customView:menuButton)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationController?.navigationBar.barTintColor = currentTheme.topColor
        title = "Master Data"
        
        
    }
    @IBAction func CloseBtnPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        cell.textLabel?.text = masterArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 17)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vcName = masterArray[indexPath.row]
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if vcName == "Teams" {
            let viewCntrl = storyboard.instantiateViewControllerWithIdentifier("MasterDataListViewController") as! MasterDataListViewController
              viewCntrl.vcName = vcName
            navigationController?.pushViewController(viewCntrl, animated: true)
        }
        else if vcName == "Opponents" {
            let viewCntrl = storyboard.instantiateViewControllerWithIdentifier("MasterDataListViewController") as! MasterDataListViewController
             viewCntrl.vcName = vcName
            navigationController?.pushViewController(viewCntrl, animated: true)
            
        }
        else if vcName == "Venue" {
            let viewCntrl = storyboard.instantiateViewControllerWithIdentifier("MasterDataListViewController") as! MasterDataListViewController
            viewCntrl.vcName = vcName
            navigationController?.pushViewController(viewCntrl, animated: true)
            
        }
        else if vcName == "Tournaments" {
            let viewCntrl = storyboard.instantiateViewControllerWithIdentifier("MasterDataListViewController") as! MasterDataListViewController
            viewCntrl.vcName = vcName
            navigationController?.pushViewController(viewCntrl, animated: true)
            
        }
        else if vcName == "Grounds" {
            let viewCntrl = storyboard.instantiateViewControllerWithIdentifier("MasterDataListViewController") as! MasterDataListViewController
             viewCntrl.vcName = vcName
            navigationController?.pushViewController(viewCntrl, animated: true)
        }
    }
  
}
