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
    

    @IBOutlet weak var runsText: SkyFloatingLabelTextField!
    @IBOutlet weak var ballsPlayedText:UITextField!
    @IBOutlet weak var foursText:UITextField!
    @IBOutlet weak var sixesText:UITextField!
    @IBOutlet weak var strikeRateText:UITextField!
    @IBOutlet weak var positionText:UITextField!
    @IBOutlet weak var dismissalText:UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var oversText:SkyFloatingLabelTextField!
    @IBOutlet weak var wicketsText:UITextField!
    @IBOutlet weak var noballText:UITextField!
    @IBOutlet weak var widesText:UITextField!
    @IBOutlet weak var economyText:UITextField!
    
    @IBOutlet weak var runsGivenText: UITextField!
    weak var parent:MatchParent?
    
    var BowlingData:[String:String]{
        
        return ["OversBalled":oversText.textVal,"Wickets":wicketsText.textVal,"RunsGiven":runsGivenText.textVal,"Noballs":noballText.textVal,"Wides":widesText.text!]
    }
    
    var allRequiredFieldsHaveFilledProperly: Bool {
        if let runText = runsText, let overText = oversText {
            ValidateScore()
            validateOvers()
            return runText.errorMessage?.length == 0  && overText.errorMessage?.length == 0
        }
        return false
    }
    
    func ValidateScore() -> Void {
        
        if let runText = runsText {
            if runText.text?.trimWhiteSpace.length > 0  {
                if let foursScored = foursText.text, let sixesScored = sixesText.text
                {
                    var sum = 0
                    if foursScored.trimWhiteSpace.length > 0, let foursInt = Int(foursScored) {
                        sum += (4*foursInt)
                    }
                    if sixesScored.trimWhiteSpace.length > 0, let sixesInt = Int(sixesScored) {
                        sum += (6*sixesInt)
                    }
                    
                    if sum > Int(runText.text!)! {
                        runsText.errorMessage = "Invalid Runs"
                    }
                    else
                    {
                        runsText.errorMessage = ""
                    }
                }
            }
            else
            {
                runsText.errorMessage = "Runs Empty"
            }
        }
    }
    
    func validateOvers() -> Void {
        
        if let overText = oversText {
            if overText.text!.trimWhiteSpace.length > 0 {
                if let widesBowled = widesText.text, let noBallsBowled = noballText.text
                {
                    var sum = 0
                    if widesBowled.trimWhiteSpace.length > 0, let widesInt = Int(widesBowled) {
                        sum += widesInt
                    }
                    
                    if noBallsBowled.trimWhiteSpace.length > 0, let noBallsInt = Int(noBallsBowled) {
                        sum += noBallsInt
                    }
                    
                    if sum > Int(oversText.text!)! {
                        oversText.errorMessage = "Invalid Overs"
                    }
                    else
                    {
                        oversText.errorMessage = ""
                    }
                }
            }
            else
            {
                oversText.errorMessage = "Overs Empty"
            }
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
        
        
        return ["Runs":runsText.textVal,"Balls":ballsPlayedText.textVal,"Fours":foursText.textVal,"Sixes":sixesText.textVal,"Position":positionText.textVal,"Dismissal":dismissalText.textVal]
    }
    
    func loadEditData(){
        
        runsText.textVal = parent!.selecetedData!["Runs"]!
        ballsPlayedText.textVal = parent!.selecetedData!["Balls"]!
        foursText.textVal = parent!.selecetedData!["Fours"]!
        sixesText.textVal = parent!.selecetedData!["Sixes"]!
        strikeRateText.textVal = parent!.selecetedData!["Ground"]!
        positionText.textVal = parent!.selecetedData!["Position"]!
        dismissalText.textVal = parent!.selecetedData!["Dismissal"]!
        setStrikeRate()
        
        
        oversText.textVal = parent!.selecetedData!["OversBalled"]!
        wicketsText.textVal = parent!.selecetedData!["Wickets"]!
        runsGivenText.textVal = parent!.selecetedData!["RunsGiven"]!
        noballText.textVal = parent!.selecetedData!["Noballs"]!
        widesText.textVal = parent!.selecetedData!["Wides"]!
        calculateEconomy()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runsText.errorColor = UIColor.redColor()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        dismissalText.delegate = self
        runsText.delegate = self
        oversText.delegate = self
        
        runsText.delegate = self
        ballsPlayedText.delegate = self
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
            ValidateScore()
            
            if textField == runsText || textField == ballsPlayedText{
                
                calculateStrikeRate()
            }
            
            if textField.text?.trimWhiteSpace.length > 0{
                
                parent?.dataChangedAfterLastSave()
            }
        }
        else if textField.tag == 2 {
            validateOvers()
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
        else if ballsPlayedText.text?.trimWhiteSpace.length == 0{
            strikeRateText.text = ""
        }
        else{
            setStrikeRate()
        }
    }
    
    
    func setStrikeRate(){
        
        if let runs = Double((runsText.text?.trimWhiteSpace)!){
            if let balls = Double((ballsPlayedText.text?.trimWhiteSpace)!){
                
                strikeRateText.text = String(format: "%.0f",(runs*100 / balls))
            }
            
        }
    }
    
}
