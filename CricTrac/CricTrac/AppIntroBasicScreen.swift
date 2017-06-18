//
//  AppIntroBasicScreen.swift
//  CricTrac
//
//  Created by AIPL on 12/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AppIntroBasicScreen:UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.imageView.alpha = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 0, options: [.CurveEaseOut], animations: {
            //self.view.alpha = 0.7
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

}
