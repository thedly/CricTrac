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
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.alpha = 1
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 0, options: [.CurveEaseOut], animations: {
            //self.imageView.alpha = 0.3
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
      //  self.doneButton.setTitle("Loading...", forState: .Normal)
        //doneButton!.setTitle("Loading...", forState: .Normal)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        
//       let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootController = storyboard.instantiateViewControllerWithIdentifier("SplashScreenViewController")
//        self.presentViewController(rootController, animated: false, completion: nil)
        
   
    }

    
    
    
    
    
}
