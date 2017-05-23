//
//  FAQViewController.swift
//  CricTrac
//
//  Created by Sajith Kumar on 23/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController,ThemeChangeable {
   
    @IBOutlet weak var barView: UIView!
     @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setBackgroundColor()
        
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
         self.barView.backgroundColor = currentTheme.topColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }



}
