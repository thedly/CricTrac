//
//  BowlingViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

import XLPagerTabStrip


class BowlingViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var oversText:UITextField!
    @IBOutlet weak var wicketsText:UITextField!
    @IBOutlet weak var runsText:UITextField!
    @IBOutlet weak var noballText:UITextField!
    @IBOutlet weak var widesText:UITextField!
    @IBOutlet weak var economyText:UITextField!
    
    
    var data:[String:String]{
        
        return ["OversBalled":oversText.textVal,"Wickets":wicketsText.textVal,"RunsGiven":runsText.textVal,"Noballs":noballText.textVal,"Wides":widesText.text!]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // commentsText.type = .multiline
        // commentsText.style =  CustomTextInputStyle()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BOWLING")
    }
    
    func allRequiredFieldsHaveFilledProperly()->Bool{
        
        return false
    }
}
