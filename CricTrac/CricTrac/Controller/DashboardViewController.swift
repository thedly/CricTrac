//
//  DashboardViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {

    @IBOutlet weak var BattingBtn: UIButton!
    @IBOutlet weak var BowlingBtn: UIButton!
    @IBOutlet weak var BattingSelectedIndicator: UIView!
    @IBOutlet weak var BowlingSelectedIndicator: UIView!
    
    // MARK: View controller Delegates and related methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarProperties()
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeView() {
        BowlingSelectedIndicator.hidden = true
        BattingSelectedIndicator.hidden = false
        
        BattingBtn.setTitleColor(UIColorFromRGB(0xD8D8D8), forState: UIControlState.Normal)
        BowlingBtn.setTitleColor(UIColorFromRGB(0xD8D8D8), forState: UIControlState.Normal)
        
        BattingBtn.tintColor = UIColor.clearColor()
        BowlingBtn.tintColor = UIColor.clearColor()
        
        BowlingBtn.setTitleColor(UIColorFromRGB(0x6D9447), forState: UIControlState.Selected)
        BattingBtn.setTitleColor(UIColorFromRGB(0x6D9447), forState: UIControlState.Selected)
        
        BattingBtn.selected = true
    }
    
    //Sets button for Slide menu, Title and Navigationbar Color
    func setNavigationBarProperties(){
        let button: UIButton = UIButton(type:.Custom)
        button.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 40, 40)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        navigationItem.leftBarButtonItem = barButton
        navigationController!.navigationBar.barTintColor = UIColor(hex:"B12420")
        title = "CricTrac"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    // MARK: Button Actions
    
    @IBAction func BattingTabSelected(sender: UIButton) {
        
        BowlingSelectedIndicator.hidden = true
        BattingSelectedIndicator.hidden = false
        BattingBtn.selected = true
        BowlingBtn.selected = false
        
    }
    @IBAction func BowlingTabSelected(sender: UIButton) {
        
        BowlingSelectedIndicator.hidden = false
        BattingSelectedIndicator.hidden = true
        BattingBtn.selected = false
        BowlingBtn.selected = true
        
    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      // MARK: TableView DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell =  UITableViewCell()
        cell.textLabel?.text = "data"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 12
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
