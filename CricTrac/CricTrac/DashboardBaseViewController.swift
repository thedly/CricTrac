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
        //setNavigationBarProperties()
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
    
        
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
