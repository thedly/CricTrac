//
//  BattingViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField

class BattingViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var runsText:SkyFloatingLabelTextField!
    @IBOutlet weak var ballsText:UITextField!
    @IBOutlet weak var foursText:UITextField!
    @IBOutlet weak var sixesText:UITextField!
    @IBOutlet weak var strikeRateText:UITextField!
    @IBOutlet weak var positionText:UITextField!
    @IBOutlet weak var dismissalText:UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    var selectedText:UITextField!
    
    var data:[String:String]{
    
        
        return ["Runs":runsText.textVal,"Balls":ballsText.textVal,"Fours":foursText.textVal,"Sixes":sixesText.textVal,"Position":positionText.textVal,"Dismissal":dismissalText.textVal]
    }
    
    
    var allRequiredFieldsHaveFilledProperly:Bool{
        if runsText.text?.trimWhiteSpace.length > 0{
            return true
        }
        else{
            if ballsText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            if foursText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            if sixesText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            if positionText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            if dismissalText.text?.trimWhiteSpace.length > 0{
                
                return false
            }
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     runsText.errorColor = UIColor.redColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BATTING")
    }

    

    
    
}


extension BattingViewController:UITextFieldDelegate{
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.selectedText = textField
        
        if textField == dismissalText{
            addSuggstionBox(textField, dataSource: dismissals, showSuggestions: true)
        }
}
    
    func textFieldDidEndEditing(textField: UITextField){
        
        if allRequiredFieldsHaveFilledProperly{
            runsText.errorMessage = ""
        }
        else{
            runsText.errorMessage = "Runs cant be empty"
        }
        
        if textField == runsText || textField == ballsText{
          
           calculateStrikeRate()
        }
    }

    func calculateStrikeRate(){
        
        if runsText.text?.trimWhiteSpace.length == 0{
            strikeRateText.text = ""
        }
        else if ballsText.text?.trimWhiteSpace.length == 0{
            strikeRateText.text = ""
        }
        else{
            
            if let runs = Int((runsText.text?.trimWhiteSpace)!){
                if let balls = Int((ballsText.text?.trimWhiteSpace)!){
                    strikeRateText.text = "\(runs*100 / balls)"
                }
                
            }
        }
    }
   
}

