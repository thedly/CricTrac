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
    
    
    var OversBowled: String! = "-"
    var WicketsTaken: String! = "-"
    var RunsGiven: String! = "-"
    var NoBalls: String! = "-"
    var Wides: String! = "-"
    var Maidens: String! = "-"
    
    var RunsTaken: String! = "-"
    var BallsFaced: String! = "-"
    var Fours: String! = "-"
    var Sixes: String! = "-"
    var Position: String! = "-"
    var Dismissal: String! = "-"
    
    
    

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
    
    @IBOutlet weak var maidensText: UITextField!
    @IBOutlet weak var runsGivenText: UITextField!
    weak var parent:MatchParent?
    
    var BowlingData:[String:String]{
        
        return ["OversBowled":OversBowled,"WicketsTaken":WicketsTaken,"RunsGiven":RunsGiven,"NoBalls":NoBalls,"Wides":Wides, "Maidens": Maidens]
    }
    
    var allRequiredFieldsHaveFilledProperly: Bool {
        if let runText = runsText, let overText = oversText {
            ValidateScore()
            validateOvers()
            return true
        }
        return true
    }
    
    func ValidateScore() -> Void {
        
        if let runText = runsText.text {
            if runText.trimWhiteSpace.length > 0 && Int(runText)! > 0  {
                
                RunsTaken = runText
                
                if let foursScored = foursText.text {
                    Fours = foursScored != "-" && foursScored.length > 0 ? foursScored : "0"
                }
                
                if let sixesScored = sixesText.text {
                    Sixes = sixesScored != "-" && sixesScored.length > 0 ? sixesScored : "0"
                }
                
                if let dismissal = dismissalText.text {
                    Dismissal = dismissal != "-" && dismissal.length > 0 ? dismissal : dismissals[0]
                }
                
                if let position = positionText.text {
                    Position = position != "-" && position.length > 0 ? position : "1"
                }
                
                if let ballsPlayed = ballsPlayedText.text {
                    BallsFaced = ballsPlayed != "-" && ballsPlayed.length > 0 ? ballsPlayed : runText
                }
                
                
                
//                if let foursScored = foursText.text, let sixesScored = sixesText.text
//                {
//                    var sum = 0
//                    if foursScored.trimWhiteSpace.length > 0, let foursInt = Int(foursScored) {
//                        sum += (4*foursInt)
//                    }
//                    if sixesScored.trimWhiteSpace.length > 0, let sixesInt = Int(sixesScored) {
//                        sum += (6*sixesInt)
//                    }
//                    
//                    if sum > Int(runText)! {
//                        runsText.errorMessage = "Invalid Runs"
//                    }
//                    else
//                    {
//                        runsText.errorMessage = ""
//                    }
//                }
                
                
                
                
                foursText.userInteractionEnabled = true
                sixesText.userInteractionEnabled = true
                positionText.userInteractionEnabled = true
                dismissalText.userInteractionEnabled = true
                ballsPlayedText.userInteractionEnabled = true
                
                
            }
            else
            {
                
                self.view.endEditing(true)
                
                RunsTaken = "-"
                Fours = "-"
                Sixes = "-"
                Dismissal = "-"
                Position = "-"
                BallsFaced = "-"
                
                foursText.userInteractionEnabled = false
                sixesText.userInteractionEnabled = false
                dismissalText.userInteractionEnabled = false
                positionText.userInteractionEnabled = false
                ballsPlayedText.userInteractionEnabled = false
                
                
            }
        }
    }
    
    func validateOvers() -> Void {
        
        if let overText = oversText.text {
            if overText.length == 0 || Int(overText) <= 0 {
                
                self.view.endEditing(true)
                
                OversBowled = overText
                
                Wides = "-"
                NoBalls = "-"
                WicketsTaken = "-"
                Maidens = "-"
                RunsGiven = "-"
                
                
                
                widesText.userInteractionEnabled = false
                noballText.userInteractionEnabled = false
                wicketsText.userInteractionEnabled = false
                maidensText.userInteractionEnabled = false
                runsGivenText.userInteractionEnabled = false
                
//                if let widesBowled = widesText.text, let noBallsBowled = noballText.text
//                {
//                    var sum = 0
//                    if widesBowled.trimWhiteSpace.length > 0, let widesInt = Int(widesBowled) {
//                        sum += widesInt
//                    }
//                    
//                    if noBallsBowled.trimWhiteSpace.length > 0, let noBallsInt = Int(noBallsBowled) {
//                        sum += noBallsInt
//                    }
//                    
//                    if sum > Int(Float(oversText.text!)!) {
//                        oversText.errorMessage = "Invalid Overs"
//                    }
//                    else
//                    {
//                        oversText.errorMessage = ""
//                    }
//                }
            }
            else
            {
//                if Int(widesText.textVal) > 0 || Int(noballText.textVal) > 0 {
//                    oversText.errorMessage = "Overs Empty"
//                }
//                else
//                {
//                    oversText.errorMessage = ""
//                }
//                
                OversBowled = oversText.text
                
                if let wides = widesText.text {
                    Wides = wides != "-" && wides.length > 0  ? wides : "0"
                }
                
                if let noball = noballText.text {
                    NoBalls = noball != "-" && noball.length > 0 ? noball : "0"
                }
                
                if let wickets = wicketsText.text {
                    WicketsTaken = wickets != "-" && wickets.length > 0 ? wickets : "0"
                }
                
                if let maidens = maidensText.text {
                    Maidens = maidens != "-" && maidens.length > 0 ? maidens : "0"
                }
                
                if let runsgiven = runsGivenText.text {
                    RunsGiven = runsgiven != "-" && runsgiven.length > 0 ? runsgiven : "0"
                }

                
                widesText.userInteractionEnabled = true
                noballText.userInteractionEnabled = true
                wicketsText.userInteractionEnabled = true
                maidensText.userInteractionEnabled = true
                runsGivenText.userInteractionEnabled = true
                
            }
        }
        
    }
    
    @IBAction func decrementMaidens(sender: UIButton) {
        self.incrementDecrementOperation(maidensText, isIncrement: false)
    }
    @IBAction func incrementMaidens(sender: UIButton) {
        self.incrementDecrementOperation(maidensText, isIncrement: true)
    }
    @IBAction func incrementPosition(sender: AnyObject) {
        self.incrementDecrementOperation(positionText, isIncrement: true)
        
    }
    
    @IBAction func decrementPosition(sender: UIButton) {
        self.incrementDecrementOperation(positionText, isIncrement: false)
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
        
        
        return ["RunsTaken":RunsTaken,"BallsFaced":BallsFaced,"Fours":Fours,"Sixes":Sixes,"Position":Position,"Dismissal":Dismissal]
    }
    
    func loadEditData(){
        
        runsText.textVal = parent!.selecetedData!["RunsTaken"]!
        ballsPlayedText.textVal = parent!.selecetedData!["BallsFaced"]!
        foursText.textVal = parent!.selecetedData!["Fours"]!
        sixesText.textVal = parent!.selecetedData!["Sixes"]!
        strikeRateText.textVal = parent!.selecetedData!["Ground"]!
        positionText.textVal = parent!.selecetedData!["Position"]!
        dismissalText.textVal = parent!.selecetedData!["Dismissal"]!
        setStrikeRate()
        
        
        oversText.textVal = parent!.selecetedData!["OversBowled"]!
        wicketsText.textVal = parent!.selecetedData!["WicketsTaken"]!
        runsGivenText.textVal = parent!.selecetedData!["RunsGiven"]!
        noballText.textVal = parent!.selecetedData!["NoBalls"]!
        widesText.textVal = parent!.selecetedData!["Wides"]!
        
        if let mt = parent!.selecetedData!["Wides"] {
            maidensText.textVal = mt
        }
        
//        calculateEconomy()

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
        oversText.keyboardType = UIKeyboardType.DecimalPad
        
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
        maidensText.delegate = self
        
        
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
    
//    func calculateEconomy(){
//        
//        if runsText.text?.trimWhiteSpace.length == 0{
//            economyText.text = ""
//        }
//        else if oversText.text?.trimWhiteSpace.length == 0{
//            economyText.text = ""
//        }
//        else{
//            
//            if let runs = Double((runsText.text?.trimWhiteSpace)!){
//                if let overs = Double((oversText.text?.trimWhiteSpace)!){
//                    economyText.text = "\(runs / overs)"
//                }
//                
//            }
//        }
//    }
    
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
        
        if textField.accessibilityIdentifier == "textWithNumPad" {
            AddDoneButtonTo(textField)
        }
        
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
//            if textField == oversText || textField == runsText{
//                
//                calculateEconomy()
//            }
            
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
    
    
    func AddDoneButtonTo(inputText:UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(BattingBowlingViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(BattingBowlingViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        selectedText.resignFirstResponder()
    }

    
}
