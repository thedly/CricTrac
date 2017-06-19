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
    @IBOutlet weak var imageView2 : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        self.imageView2.alpha = 0
        self.imageView.alpha = 1
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // animate it from the left to the right
        UIView.animateWithDuration(1.5, delay: 0.5, options: [.CurveEaseOut], animations: {
            self.imageView2.alpha = 1
            self.imageView.alpha = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    

}
