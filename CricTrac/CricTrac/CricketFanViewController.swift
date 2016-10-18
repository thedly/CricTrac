//
//  CricketFanViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 14/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CricketFanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
