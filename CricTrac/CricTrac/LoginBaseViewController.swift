//
//  LoginBaseViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 19/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LoginBaseViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        setUIBackgroundTheme(self.view)
                // Do any additional setup after loading the view.
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let loginView = viewControllerFrom("Main", vcid: "LoginViewController")
        
        let registerView = viewControllerFrom("Main", vcid: "RegisterViewController")
        
        return [loginView, registerView]
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
