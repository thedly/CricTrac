//
//  AboutViewController.swift
//  CricTrac
//
//  Created by Sajith Kumar on 23/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController,ThemeChangeable {
   
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setBackgroundColor()
        
        //textView.text = "About Us"
        
        let formattedString = NSMutableAttributedString()
        formattedString.bold("The Team" , fontName: appFont_black, fontSize: 20)
        formattedString.bold("\n\nSajith Kumar (Founder, CEO)" , fontName: appFont_black, fontSize: 20)
        formattedString.bold("\nSajith Kumar is the Founder and CEO of CricTrac, a product from Arjun Innovations Pvt Ltd. He is responsible for the company's overall vision and strategy as well as day-to-day operations. \n\nSince the beginning, Sajith has focused on inspiring creativity through solving problems with thoughtful product design. As a result, CricTrac has become the essential accessory for any cricketer to carry along with his cricket kit. \n\nPrior to founding Arjun Innovations and CricTrac, Sajith was part of multiple organizations like Harman, Wipro etc with an extensive service experience of 15 plus years." , fontName: appFont_regular, fontSize: 15)

        textView.attributedText = formattedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        self.barView.backgroundColor = currentTheme.topColor
        
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
