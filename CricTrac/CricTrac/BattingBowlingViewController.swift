//
//  BattingBowlingViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField

class BattingBowlingViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var runsGivenText:SkyFloatingLabelTextField!
    @IBOutlet weak var ballsText:UITextField!
    @IBOutlet weak var foursText:UITextField!
    @IBOutlet weak var sixesText:UITextField!
    @IBOutlet weak var strikeRateText:UITextField!
    @IBOutlet weak var positionText:UITextField!
    @IBOutlet weak var dismissalText:UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var oversText:SkyFloatingLabelTextField!
    @IBOutlet weak var wicketsText:UITextField!
    @IBOutlet weak var runsText:UITextField!
    @IBOutlet weak var noballText:UITextField!
    @IBOutlet weak var widesText:UITextField!
    @IBOutlet weak var economyText:UITextField!
    
    weak var parent:MatchParent?
    
    var BowlingData:[String:String]{
        
        return ["OversBalled":oversText.textVal,"Wickets":wicketsText.textVal,"RunsGiven":runsText.textVal,"Noballs":noballText.textVal,"Wides":widesText.text!]
    }
    
    
    var allRequiredFieldsHaveFilledProperly:Bool{
        _ = view
        if oversText.text?.trimWhiteSpace.length > 0 && runsGivenText.text?.trimWhiteSpace.length > 0{
            return true
        }
        else{
            
            
//            if ballsText.text?.trimWhiteSpace.length > 0 && foursText.text?.trimWhiteSpace.length > 0 && sixesText.text?.trimWhiteSpace.length > 0 && positionText.text?.trimWhiteSpace.length > 0 && dismissalText.text?.trimWhiteSpace.length > 0 {
//                    return true
//            }
//            
//            else if wicketsText.text?.trimWhiteSpace.length > 0 && runsText.text?.trimWhiteSpace.length > 0 && noballText.text?.trimWhiteSpace.length > 0 {
//                return true
//            }
            
            
            return false
        }
        
        
        
    }
    
    @IBAction func incrementWickets(sender: AnyObject) {
        self.incrementDecrementOperation(wicketsText, isIncrement: true)
    }
    
    @IBAction func decrementWickets(sender: AnyObject) {
        self.incrementDecrementOperation(wicketsText, isIncrement: false)
    }
    
    @IBAction func incrementNoBalls(sender: AnyObject) {
        self.incrementDecrementOperation(noballText, isIncrement: true)
    }
    
    @IBAction func decrementNoBalls(sender: AnyObject) {
        self.incrementDecrementOperation(noballText, isIncrement: false)
    }
    
    @IBAction func incrementWides(sender: AnyObject) {
        self.incrementDecrementOperation(widesText, isIncrement: true)
    }
    
   
    @IBAction func decrementWides(sender: AnyObject) {
        self.incrementDecrementOperation(widesText, isIncrement: false)
    }
    
    @IBAction func incrementSixes(sender: AnyObject) {
        self.incrementDecrementOperation(sixesText, isIncrement: true)
    }
    
    @IBAction func decrementSixes(sender: AnyObject) {
        self.incrementDecrementOperation(sixesText, isIncrement: false)
    }
    
    @IBAction func incrementFours(sender: AnyObject) {
        self.incrementDecrementOperation(foursText, isIncrement: true)
    }
    
    @IBAction func decrementFours(sender: AnyObject) {
        self.incrementDecrementOperation(foursText, isIncrement: false)
    }
   
    
    var selectedText:UITextField!
    
    var BattingData:[String:String]{
        
        
        return ["Runs":runsText.textVal,"Balls":ballsText.textVal,"Fours":foursText.textVal,"Sixes":sixesText.textVal,"Position":positionText.textVal,"Dismissal":dismissalText.textVal]
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
        
        
        oversText.textVal = parent!.selecetedData!["OversBalled"]!
        wicketsText.textVal = parent!.selecetedData!["Wickets"]!
        runsText.textVal = parent!.selecetedData!["RunsGiven"]!
        noballText.textVal = parent!.selecetedData!["Noballs"]!
        widesText.textVal = parent!.selecetedData!["Wides"]!
        calculateEconomy()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runsGivenText.errorColor = UIColor.redColor()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        dismissalText.delegate = self
        runsText.delegate = self
        oversText.delegate = self
        
        runsGivenText.delegate = self
        ballsText.delegate = self
        foursText.delegate = self
        sixesText.delegate = self
        strikeRateText.delegate = self
        positionText.delegate = self
        dismissalText.delegate = self
        
        oversText.delegate = self
        wicketsText.delegate = self
        runsText.delegate = self
        noballText.delegate = self
        widesText.delegate = self
        economyText.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BATTING & BOWLING")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func incrementDecrementOperation(controlText: UITextField, isIncrement: Bool) {
        if isIncrement {
            if let currentValue = Int(controlText.text!) {
                if currentValue >= 0 {
                    controlText.text = String(currentValue + 1)
                }
            }
        }
        else
        {
            if let currentValue = Int(controlText.text!) {
                if currentValue > 0 {
                    controlText.text = String(currentValue - 1)
                }
            }
        }
    }

}


extension BattingBowlingViewController:UITextFieldDelegate{
    
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
        
        if textField.tag == 1 {
            if allRequiredFieldsHaveFilledProperly{
                runsGivenText.errorMessage = ""
            }
            else{
                runsGivenText.errorMessage = "Runs cant be empty"
            }
            
            if textField == runsText || textField == ballsText{
                
                calculateStrikeRate()
            }
            
            if textField.text?.trimWhiteSpace.length > 0{
                
                parent?.dataChangedAfterLastSave()
            }
        }
        else if textField.tag == 2 {
            if allRequiredFieldsHaveFilledProperly{
                oversText.errorMessage = ""
            }
            else{
                oversText.errorMessage = "Overs cant be empty"
            }
            
            if textField == oversText || textField == runsText{
                
                calculateEconomy()
            }
            
            if textField.text?.trimWhiteSpace.length > 0{
                
                parent?.dataChangedAfterLastSave()
            }

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
        
        if let runs = Double((runsText.text?.trimWhiteSpace)!){
            if let balls = Double((ballsText.text?.trimWhiteSpace)!){
                
                strikeRateText.text = String(format: "%.0f",(runs*100 / balls))
            }
            
        }
    }
    
}
