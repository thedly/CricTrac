//
//  ProfileImageExpandingVC.swift
//  CricTrac
//
//  Created by Arjun Innovations on 12/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class ProfileImageExpandingVC: UIViewController {

    @IBOutlet weak var profileImageExtended: UIImageView!
   
   var imageString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageExtended.image = UIImage(named: imageString)
        let imageURL = NSURL(string:imageString)
            profileImageExtended.kf_setImageWithURL(imageURL!)

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
