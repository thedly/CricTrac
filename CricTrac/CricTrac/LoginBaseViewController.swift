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
        settings.style.buttonBarItemBackgroundColor = UIColor(hex: "#D4D4D4")
        settings.style.buttonBarItemTitleColor = UIColor(hex: "#667815")
        buttonBarView.selectedBar.backgroundColor = UIColor(hex: "#B12420")
        settings.style.buttonBarItemFont = UIFont(name: "SFUIText-Regular", size: 15)!
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
