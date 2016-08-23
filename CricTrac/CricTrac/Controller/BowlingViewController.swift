//
//  BowlingViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import SkyFloatingLabelTextField

class BowlingViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var oversText:SkyFloatingLabelTextField!
    @IBOutlet weak var wicketsText:UITextField!
    @IBOutlet weak var runsText:UITextField!
    @IBOutlet weak var noballText:UITextField!
    @IBOutlet weak var widesText:UITextField!
    @IBOutlet weak var economyText:UITextField!
    
    
    var data:[String:String]{
        
        return ["OversBalled":oversText.textVal,"Wickets":wicketsText.textVal,"RunsGiven":runsText.textVal,"Noballs":noballText.textVal,"Wides":widesText.text!]
    }
    
    
    var allRequiredFieldsHaveFilledProperly:Bool{
        if oversText.text?.trimWhiteSpace.length > 0{
            return true
        }
        else{
            if wicketsText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            if runsText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            if noballText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            return true
        }
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
}

extension BowlingViewController:UITextFieldDelegate{
    
    func textFieldDidEndEditing(textField: UITextField){
        
        if allRequiredFieldsHaveFilledProperly{
            oversText.errorMessage = ""
        }
        else{
            oversText.errorMessage = "Overs cant be empty"
        }
    }
}
