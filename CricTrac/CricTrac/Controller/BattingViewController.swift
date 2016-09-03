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
    
    weak var parent:MatchParent?
    
    var data:[String:String]{
        
        
        return ["Runs":runsText.textVal,"Balls":ballsText.textVal,"Fours":foursText.textVal,"Sixes":sixesText.textVal,"Position":positionText.textVal,"Dismissal":dismissalText.textVal]
    }
    
    
    var allRequiredFieldsHaveFilledProperly:Bool{
        _ = view
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
        
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadEditData(){
        
        runsText.textVal = parent!.selecetedData!["Runs"]!
        ballsText.textVal = parent!.selecetedData!["Balls"]!
        foursText.textVal = parent!.selecetedData!["Fours"]!
        sixesText.textVal = parent!.selecetedData!["Sixes"]!
        strikeRateText.textVal = parent!.selecetedData!["Ground"]!
        positionText.textVal = parent!.selecetedData!["Position"]!
        dismissalText.textVal = parent!.selecetedData!["Dismissal"]!
        setStrikeRate()
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BATTING")
    }
    
    
    
    
    
}


extension BattingViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.selectedText = textField
        
        if textField == dismissalText{
            //addSuggstionBox(textField, dataSource: dismissals, showSuggestions: true)
            showPicker(self, inputText: textField, data: dismissals)
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
        
        if textField.text?.trimWhiteSpace.length > 0{
            
            parent?.dataChangedAfterLastSave()
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
            setStrikeRate()
        }
    }
    
    func setStrikeRate(){
        
        if let runs = Int((runsText.text?.trimWhiteSpace)!){
            if let balls = Int((ballsText.text?.trimWhiteSpace)!){
                strikeRateText.text = "\(runs*100 / balls)"
            }
            
        }
    }
    
}

