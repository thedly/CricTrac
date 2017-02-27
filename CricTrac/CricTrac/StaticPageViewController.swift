//
//  StaticPageViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class StaticPageViewController: UIViewController,ThemeChangeable {

    @IBOutlet weak var pageHeader: UILabel!
    @IBOutlet weak var HtmlContentHolder: UIWebView!
    
    var pageToLoad: String!
    var pageHeaderText: String!
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.pageHeader.text = pageHeaderText
        self.view.backgroundColor = currentTheme.topColor
      //  navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        setBackgroundColor()
        
        let req = NSURLRequest(URL: NSURL(string: pageToLoad)!)
        
        
        
        HtmlContentHolder.loadRequest(req)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
