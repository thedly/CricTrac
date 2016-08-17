//
//  DashboardBaseViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import KRProgressHUD

class DashboardBaseViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemTitleColor = UIColor(hex: "#667815")
        buttonBarView.selectedBar.backgroundColor = UIColor(hex: "#B12420")
        settings.style.buttonBarItemFont = UIFont(name: "SFUIText-Regular", size: 15)!
        setNavigationBarProperties()
        KRProgressHUD.dismiss()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let bat = viewControllerFrom("Main", vcid: "DashboardBattingDetailsViewController")
        
        let bowl = viewControllerFrom("Main", vcid: "DashboardBowlingDetailsViewController")
        
        
        return [bat, bowl]
    }

    
    func setUserData(){
        
        let rootRef = FIRDatabase.database().referenceFromURL("https://arjun-innovations.firebaseio.com")
        
        // rootRef.child("TestValue_Renjith").setValue(["test1":["One","Two","Three"]])
        
        //rootRef.setValue("TestValue_Renjith")
        
        // rootRef.child("users").child("RenjithTestOne").removeValue()
        
       
        rootRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let userId = currentUser!.uid
            
            if !snapshot.hasChild(userId){
                
                let userData = [userId:["BattingSum":["data"],"BowlingSum":["data"],"Matches":["data"],"PlayerInfo":["data"]]]
                rootRef.updateChildValues(userData)
            }
            
        })
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
