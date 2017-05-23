//
//  PrivacyPolicyViewController.swift
//  CricTrac
//
//  Created by Sajith Kumar on 23/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController,ThemeChangeable {
    
    @IBOutlet weak var barView: UIView!
     @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        // Do any additional setup after loading the view.
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
          self.barView.backgroundColor = currentTheme.topColor
    }
   
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
