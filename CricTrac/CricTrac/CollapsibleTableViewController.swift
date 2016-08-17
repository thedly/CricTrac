//
//  CollapsibleTableViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 14/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XMExpandableTableView
import XLPagerTabStrip

class CollapsibleTableViewController: XMExpandableTableView {
    
    @IBOutlet var mainTable: UITableView!
    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func collapseBtnPressed(sender: AnyObject) {
        
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);  //slecting 0th row with 0th section
        
            self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect);
        
        
        
        
        
        
    }
    
    @IBOutlet weak var collapseBtnImg: UIImageView!
   
    var data:[[String]] = [["Xavier Merino", "BSc. Computer Engineering", "Enjoys coding in Swift as a hobby."], ["Chocolate Snail", "Chocolate Eater", "Eats chocolate all day long."], ["Non-Expandable Row"]]
    
    var pictures:[UIImage] = [UIImage(named: "sachin")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        
        
        setNavigationBarProperties()
        
                
        
        self.tableView.scrollEnabled = false
        
        // Adding rows to the model
        super.rowModel.addRow(0, collapsedHeight: 115, expandedHeight: 282)
        //super.rowModel.addRow(1, collapsedHeight: 83, expandedHeight: 174)
        
        // Setting the standard collapsed height to the default 44.
        super.rowModel.standardCollapsedHeight = 44
        //super.rowModel.addRow(2, collapsedHeight: super.rowModel.standardCollapsedHeight, expandedHeight: super.rowModel.standardCollapsedHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    
    
    @IBOutlet weak var UserName: UILabel!
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var currentCell = tableView.cellForRowAtIndexPath(indexPath)
        
        currentCell!.contentView.backgroundColor = UIColor.clearColor()
        
        
        
        // ExpandedRow will be -1 if no row is selected.
        let expandedRow = super.rowModel.getExpandedRow()
        
        var expandedCell:UITableViewCell
        
        // This if statement is here because we only have two expandable cells, which are rows 0 and 1.
        if indexPath.row < 1 {
            if expandedRow == -1 {
                expandedCell = tableView.cellForRowAtIndexPath(indexPath)!
                (expandedCell as! CollapsibleTableViewCell).expandingAccessory.image = UIImage(named: "down")!
                
                collapseBtnImg.image = UIImage(named: "down")
                
            } else {
                expandedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: expandedRow, inSection: 0))!
                (expandedCell as! CollapsibleTableViewCell).expandingAccessory.image = UIImage(named: "up")!
                
                collapseBtnImg.image = UIImage(named: "up")
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 1 {
            
            
            //return containerView.frame.size.height
            
            if super.rowModel.isRowExpanded(forRow: 0) {
                return UIScreen.mainScreen().bounds.size.height - super.rowModel.getExpandedHeight(forRow: 0) - 60 // header height
            }
            else
            {
                return UIScreen.mainScreen().bounds.size.height - super.rowModel.getCollapsedHeight(forRow: 0) - 60
            }
            
        }
        else
        {
            if super.rowModel.isRowExpanded(forRow: indexPath.row) {
                return super.rowModel.getExpandedHeight(forRow: indexPath.row)
            }
            else
            {
                return super.rowModel.getCollapsedHeight(forRow: indexPath.row)
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // This if statement is here because we only have two expandable cells, which are rows 0 and 1.
        if indexPath.row < 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! CollapsibleTableViewCell
            cell.expandingAccessory.image = UIImage(named: "down")!
        }
    }
    
    
    // MARK: - functions
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didNewMatchButtonTapp(){
        
        let newMatchVc = viewControllerFrom("Main", vcid: "AddMatchDetailsViewController")
        self.presentViewController(newMatchVc, animated: true) {}
    }

    
    func setNavigationBarProperties(){
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("+", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 30)
        addNewMatchButton.addTarget(self, action: #selector(didNewMatchButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = UIColor(hex:"B12420")
        title = "Dashboard"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    
}


