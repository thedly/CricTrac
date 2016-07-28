//
//  MenuViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 28/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KYDrawerController

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTbl: UITableView!
    var menuItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeView()
    }

    func initializeView() {
        menuTbl.dataSource = self
        menuTbl.delegate = self
        getMenuItems()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table delegate functions
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as? MenuTableViewCell {
            cell.configureCell(menuItems[indexPath.row])
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as?MenuTableViewCell
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let currentCellText = currentCell!.menuLbl.text!
        var viewControllerToGoTo : UIViewController!
        switch currentCellText {
        case "Summary":
            viewControllerToGoTo = storyboard.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        
        case "Profile":
            
            viewControllerToGoTo = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            
            
        default:
            viewControllerToGoTo = storyboard.instantiateViewControllerWithIdentifier("SummaryViewController") as! SummaryViewController
        }
        
        
       self.presentViewController(viewControllerToGoTo, animated: true, completion: nil)
        sliderMenu.setDrawerState(KYDrawerController.DrawerState.Closed, animated: true)
        
    }
    
    
    
    // MARK: - Make service calls
    
    func getMenuItems() {
        menuItems = [
            "Dashboard",
            "New Match",
            "Summary",
            "Profile",
            "Friends",
            "Statistics",
            "Feedback",
            "About"
        ]
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
