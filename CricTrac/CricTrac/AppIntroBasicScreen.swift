//
//  AppIntroBasicScreen.swift
//  CricTrac
//
//  Created by AIPL on 12/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AppIntroBasicScreen:UIViewController {
    @IBOutlet weak var FirstTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.alpha = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        FirstTextLabel.center.x = view.center.x // Place it in the center x of the view.
        FirstTextLabel.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 0, options: [.CurveEaseOut], animations: {
            self.view.alpha = 0.7
            self.FirstTextLabel.text = "Welcome to CricTrac. \n\nThis app is mainly for Cricket Players who wants to record their match data and analyse their statistics and performance. \n\nAfter registering and verifying your email account, login to create your profile."
            self.FirstTextLabel.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

}
