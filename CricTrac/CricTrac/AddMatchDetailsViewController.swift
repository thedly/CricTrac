//
//  AddMatchDetailsViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/5/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AddMatchDetailsViewController: ButtonBarPagerTabStripViewController  {

    var matchVC:MatchViewController!
    var battingVC:BattingViewController!
    var bowlingVC:BowlingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemTitleColor = UIColor(hex: "#667815")
        buttonBarView.selectedBar.backgroundColor = UIColor(hex: "#B12420")
        settings.style.buttonBarItemFont = UIFont(name: "SFUIText-Regular", size: 15)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
      
    }
    
    @IBAction func DidtapCancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {}
    }
    
    
    @IBAction func didTapSave(sender: UIButton) {
        
        var data = matchVC.data
        data += battingVC.data
        data += bowlingVC.data
        addMatchData("date \(String(date))",data: data)
        self.dismissViewControllerAnimated(true) {}
        
    }
    
   
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        matchVC = viewControllerFrom("Main", vcid: "MatchViewController") as! MatchViewController
        
        battingVC = viewControllerFrom("Main", vcid: "BattingViewController") as! BattingViewController
        
        bowlingVC = viewControllerFrom("Main", vcid: "BowlingViewController") as! BowlingViewController
        
         let vc2 = viewControllerFrom("Main", vcid: "ExtraViewController")
        
        return [matchVC, battingVC,bowlingVC,vc2]
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
