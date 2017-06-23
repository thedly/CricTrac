//
//  AddMatchThirdIntroScreen.swift
//  CricTrac
//
//  Created by AIPL on 20/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit


class AddMatchThirdIntroScreen: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2 : UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        self.imageView2.alpha = 0
        self.imageView.alpha = 1
        
    }
    func addMatchView() {
        
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
    
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        print(self.navigationController?.viewControllers)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let rootController = storyboard.instantiateViewControllerWithIdentifier("AddMatchDetailsViewController")
        
         self.navigationController?.pushViewController(rootController, animated: true);
    
    }
    
   

}



