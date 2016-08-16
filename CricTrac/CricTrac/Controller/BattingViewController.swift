//
//  BattingViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class BattingViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var runsText:UITextField!
    @IBOutlet weak var ballsText:UITextField!
    @IBOutlet weak var foursText:UITextField!
    @IBOutlet weak var sixesText:UITextField!
    @IBOutlet weak var strikeRateText:UITextField!
    @IBOutlet weak var positionText:UITextField!
    @IBOutlet weak var dismissalText:UITextField!
    
    
    var data:[String:String]{
        
        
        return ["Runs":runsText.textVal,"Balls":ballsText.textVal,"Fours":foursText.textVal,"Sixes":sixesText.textVal,"Position":positionText.textVal,"Dismissal":dismissalText.textVal]
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
        return IndicatorInfo(title: "BATTING")
    }

    func allRequiredFieldsHaveFilledProperly()->Bool{
        
        return false
    }

}
