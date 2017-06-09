//
//  AppIntroFirstScreen.swift
//  CricTrac
//
//  Created by AIPL on 09/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
class AppIntroFirstScreen:UIViewController {
    @IBOutlet weak var FirstTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.alpha = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        
        FirstTextLabel.center.x = view.center.x // Place it in the center x of the view.
        FirstTextLabel.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 0, options: [.CurveEaseOut], animations: {
             self.imageView.alpha = 0.5
            self.FirstTextLabel.text = "Welcome to CricTrac. \n\nThis app is only for Cricket Players or Cricket Coaches or if you have any one close to you playing cricket. \n\nAfter registering and verifying your email account, login to create your profile. \n\nSelect your role and click NEXT to fill your Personal Information which is mandatory."
            self.FirstTextLabel.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
}
