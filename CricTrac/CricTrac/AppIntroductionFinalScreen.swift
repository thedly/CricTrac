//
//  AppIntroductionFinalScreen.swift
//  CricTrac
//
//  Created by AIPL on 08/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AppIntroductionFinalScreen: UIViewController{

    @IBOutlet weak var FirstTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
     self.FirstTextLabel.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.alpha = 1
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FirstTextLabel.center.x = view.center.x // Place it in the center x of the view.
        FirstTextLabel.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 1.0, options: [.CurveEaseOut], animations: {
            self.imageView.alpha = 0.3
            self.FirstTextLabel.text = "Your cooling place to hang out with friends. \nAdd friends from SUGGESTIONS or SEARCH for new friends. \nINVITE friends to your Dugout. \n\nClick on Name to view their sightscreen. \n\n\nClick DONE to start your innings."
            self.FirstTextLabel.center.x += self.view.bounds.width
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
