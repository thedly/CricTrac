//
//  NewMatchViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/23/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class NewMatchViewController: UIViewController {

    
    @IBOutlet weak var matchSelector: UIView!
    
    @IBOutlet weak var bowlingSelector: UIView!
    
   
    @IBOutlet weak var extraSelector: UIView!
    
    @IBOutlet weak var battingSelector: UIView!
    
    var lastSelectedTab:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedTab = matchSelector
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func didTapCancel(sender: UIButton) {
        
        dismissViewControllerAnimated(true) {}
    }

    
    @IBAction func didTapMatch(sender: AnyObject) {
        matchSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = matchSelector
    }
  
    
    @IBAction func didTapBat(sender: AnyObject){
        battingSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = battingSelector
    }
    
    
    @IBAction func didTapBowl(sender: AnyObject) {
        bowlingSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = bowlingSelector
    }
    
    
    @IBAction func didTapExtra(sender: AnyObject) {
        extraSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = extraSelector
    }
    
    func hideAllSelectors(){
        matchSelector.hidden = true
        battingSelector.hidden = true
        bowlingSelector.hidden = true
        extraSelector.hidden = true
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