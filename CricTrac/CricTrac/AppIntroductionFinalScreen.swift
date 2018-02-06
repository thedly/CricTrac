//
//  AppIntroductionFinalScreen.swift
//  CricTrac
//
//  Created by AIPL on 08/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AppIntroductionFinalScreen: UIViewController{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
     @IBOutlet weak var imageView2 : UIImageView!
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView2.alpha = 0
        self.imageView.alpha = 1
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 1, options: [.CurveEaseOut], animations: {
            self.imageView2.alpha = 1
            self.imageView.alpha = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
      //  self.doneButton.setTitle("Loading...", forState: .Normal)
        //doneButton!.setTitle("Loading...", forState: .Normal)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
   
    }
    

    
    
    
    
    
}
