//
//  ExtraViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import AnimatedTextInput

class ExtraViewController: UIViewController,IndicatorInfoProvider {
    
     @IBOutlet weak var commentsText:AnimatedTextInput!
    
    @IBOutlet weak var tossText:UITextField!
    @IBOutlet weak var firstBatText:UITextField!
    @IBOutlet weak var firstScoreText:UITextField!
    @IBOutlet weak var firstWicketsText:UITextField!
    @IBOutlet weak var secondBatText:UITextField!
    @IBOutlet weak var secondScoreText:UITextField!
    @IBOutlet weak var secondWicketsText:UITextField!
    @IBOutlet weak var resultText:UITextField!
    
    
    var data:[String:String]{
        
        return ["Toss":tossText.textVal,"FirstBat":firstBatText.textVal,"FirstScore":firstScoreText.textVal,"FirstWickets":firstWicketsText.textVal,"SecondBat":secondBatText.textVal, "SecondScore":secondScoreText.textVal,"SecondWickets":secondWicketsText.textVal,"Result":resultText.textVal,"Comments":commentsText.text!]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         commentsText.type = .multiline
         commentsText.style =  CustomTextInputStyle()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXTRA")
    }
    
    func allRequiredFieldsHaveFilledProperly()->Bool{
        
        return false
    }
    
}
