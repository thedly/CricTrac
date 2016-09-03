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
    
    
    weak var parent:MatchParent?
    
    var data:[String:String]{
        
        return ["OversBalled":oversText.textVal,"Wickets":wicketsText.textVal,"RunsGiven":runsText.textVal,"Noballs":noballText.textVal,"Wides":widesText.text!]
    }
    
    
    var allRequiredFieldsHaveFilledProperly:Bool{
        _ = view
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
    
    func calculateEconomy(){
        
        if runsText.text?.trimWhiteSpace.length == 0{
            economyText.text = ""
        }
        else if oversText.text?.trimWhiteSpace.length == 0{
            economyText.text = ""
        }
        else{
            
            if let runs = Double((runsText.text?.trimWhiteSpace)!){
                if let overs = Double((oversText.text?.trimWhiteSpace)!){
                    economyText.text = "\(runs / overs)"
                }
                
            }
        }
    }
}

extension BowlingViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        
        if allRequiredFieldsHaveFilledProperly{
            oversText.errorMessage = ""
        }
        else{
            oversText.errorMessage = "Overs cant be empty"
        }
        
        if textField == oversText || textField == runsText{
            
            calculateEconomy()
        }
        
        
    }
    }
