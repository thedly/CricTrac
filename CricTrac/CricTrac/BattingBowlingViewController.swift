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

class BattingBowlingViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable {
    
    var selectedText:UITextField!

    @IBOutlet weak var runsText: SkyFloatingLabelTextField!
    @IBOutlet weak var ballsPlayedText:UITextField!
    @IBOutlet weak var foursText:UITextField!
    @IBOutlet weak var sixesText:UITextField!
    @IBOutlet weak var strikeRateText:UITextField!
    @IBOutlet weak var positionText:UITextField!
    @IBOutlet weak var dismissalText:UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var oversText:UITextField!
    @IBOutlet weak var wicketsText:UITextField!
    @IBOutlet weak var noballText:UITextField!
    @IBOutlet weak var widesText:UITextField!
    @IBOutlet weak var maidensText: UITextField!
    @IBOutlet weak var runsGivenText: UITextField!
    weak var parent:MatchParent?
    @IBOutlet weak var battingDetailsLabel: UILabel!
    @IBOutlet weak var bowlingdetailsLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var bowledOvers: String!
    var WicketsTaken: String!
    var RunsGiven: String!
    var NoBalls: String!
    var Wides: String!
    var Maidens: String!
    
    var RunsTaken: String!
    var BallsFaced: String!
    var Fours: String!
    var Sixes: String!
    var Position: String!
    var Dismissal: String!
    
    var BowlingData:[String:String]{
        return ["OversBowled":bowledOvers,"WicketsTaken":WicketsTaken,"RunsGiven":RunsGiven,"NoBalls":NoBalls,"Wides":Wides, "Maidens": Maidens]
    }
    
    var allRequiredFieldsHaveFilledProperly: Bool {
        if let _ = runsText, let _ = oversText {
            ValidateScore()
            validateOvers()
            return true
        }
        return true
    }
    
    func ValidateScore() -> Void {
        if let runText = runsText.text {
            if runText.trimWhiteSpace.length > 0 && Int(runText)! >= 0  {
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
                
               // foursText.userInteractionEnabled = false
               // sixesText.userInteractionEnabled = false
               // dismissalText.userInteractionEnabled = false
               // positionText.userInteractionEnabled = false
               // ballsPlayedText.userInteractionEnabled = false
            }
        }
    }
    
    func validateOvers() -> Void {
        if let overText = oversText.text {
            if overText.length > 0 && Float(overText) > 0 {
                bowledOvers = oversText.text
                
                //check the decimal part of OversBowled
                let floatOvers = bowledOvers.componentsSeparatedByString(".")
                if floatOvers.count > 1 {
                    let intOvers = floatOvers[0]
                    var decOvers = "0"
                    if floatOvers[1].length != 0 {
                        decOvers = floatOvers[1]
                    }
                        
                    if decOvers == "0" {
                        bowledOvers = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        bowledOvers = String(newIntOvers)
                    }
                    else {
                        bowledOvers = oversText.text
                    }
                }
                
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
            else
            {
                self.view.endEditing(true)
                Wides = "-"
                NoBalls = "-"
                WicketsTaken = "-"
                Maidens = "-"
                RunsGiven = "-"
                bowledOvers = "-"
                
//                widesText.userInteractionEnabled = false
//                noballText.userInteractionEnabled = false
//                wicketsText.userInteractionEnabled = false
//                maidensText.userInteractionEnabled = false
//                runsGivenText.userInteractionEnabled = false
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
    
    var BattingData:[String:String]{
        return ["RunsTaken":RunsTaken,"BallsFaced":BallsFaced,"Fours":Fours,"Sixes":Sixes,"Position":Position,"Dismissal":Dismissal]
    }
    
    func loadEditData(){
        runsText.textVal = parent!.selecetedData!["RunsTaken"]! as! String
        ballsPlayedText.textVal = parent!.selecetedData!["BallsFaced"]! as! String
        foursText.textVal = parent!.selecetedData!["Fours"]! as! String
        sixesText.textVal = parent!.selecetedData!["Sixes"]! as! String
        strikeRateText.textVal = parent!.selecetedData!["Ground"]! as! String
        positionText.textVal = parent!.selecetedData!["Position"]! as! String
        dismissalText.textVal = parent!.selecetedData!["Dismissal"]! as! String
        
        oversText.textVal = parent!.selecetedData!["OversBowled"]! as! String
        wicketsText.textVal = parent!.selecetedData!["WicketsTaken"]! as! String
        runsGivenText.textVal = parent!.selecetedData!["RunsGiven"]! as! String
        noballText.textVal = parent!.selecetedData!["NoBalls"]! as! String
        widesText.textVal = parent!.selecetedData!["Wides"]! as! String
        maidensText.textVal = parent!.selecetedData!["Maidens"] as! String

    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        oversText.resignFirstResponder()
        runsGivenText.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runsText.errorColor = UIColor.redColor()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        setColorForViewsWithSameTag(lineView)
        setColorForViewsWithSameTag(battingDetailsLabel)
        
        //setBackgroundColor()
        self.view.backgroundColor = UIColor.clearColor()
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        bowledOvers = (parent?.selecetedData?["OversBowled"] ?? "-") as! String
        WicketsTaken = (parent?.selecetedData?["WicketsTaken"] ?? "-") as! String
        RunsGiven = (parent?.selecetedData?["RunsGiven"] ?? "-") as! String
        NoBalls = (parent?.selecetedData?["NoBalls"] ?? "-") as! String
        Wides = (parent?.selecetedData?["Wides"] ?? "-") as! String
        Maidens = (parent?.selecetedData?["Maidens"] ?? "-") as! String
        
        RunsTaken = (parent?.selecetedData?["RunsTaken"] ?? "-") as! String
        BallsFaced = (parent?.selecetedData?["BallsFaced"] ?? "-") as! String
        Fours = (parent?.selecetedData?["Fours"] ?? "-") as! String
        Sixes = (parent?.selecetedData?["Sixes"] ?? "-") as! String
        Position = (parent?.selecetedData?["Position"] ?? "-") as! String
        Dismissal = (parent?.selecetedData?["Dismissal"] ?? "-") as! String
        
        dismissalText.delegate = self
        runsText.delegate = self
        oversText.delegate = self
        oversText.keyboardType = UIKeyboardType.DecimalPad
        ballsPlayedText.delegate = self
        foursText.delegate = self
        sixesText.delegate = self
        strikeRateText.delegate = self
        positionText.delegate = self
        wicketsText.delegate = self
        noballText.delegate = self
        widesText.delegate = self
        maidensText.delegate = self
        runsGivenText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BATTING & BOWLING")
    }
    
    func incrementDecrementOperation(controlText: UITextField, isIncrement: Bool) {
        if isIncrement {
            if controlText == foursText || controlText == sixesText || controlText == maidensText || controlText == maidensText || controlText == widesText || controlText == noballText {
                if let currentValue = Int(controlText.text!) {
                    if currentValue < 999 {
                        controlText.text = String(currentValue + 1)
                    }
                }
                else
                {
                    controlText.text = String(1)
                }
            }
            else if controlText == positionText || controlText == wicketsText {
                if let currentValue = Int(controlText.text!) {
                    if currentValue < 15 {
                        controlText.text = String(currentValue + 1)
                    }
                }
                else
                {
                    controlText.text = String(1)
                }
            }
        }
        else
        {
            if let currentValue = Int(controlText.text!) {
                if controlText == positionText {
                    if currentValue > 1 {
                        controlText.text = String(currentValue - 1)
                    }
                }
                else if currentValue > 0 {
                    controlText.text = String(currentValue - 1)
                }
            }
            else
            {
                if controlText == positionText {
                    controlText.text = String(1)
                }
                else {
                controlText.text = String(0)
                }
            }
        }
        
        textFieldDidEndEditing(controlText)
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
        
        if textField == oversText  {
           animateViewMoving(true, moveValue: 140)
        }
         if textField == runsGivenText {
           animateViewMoving(true, moveValue: 210)
        }
        
        if textField == dismissalText{
           // addSuggstionBox(textField, dataSource: dismissals, showSuggestions: true)
            showPicker(self, inputText: textField, data: dismissals)
        }
        
       // parent?.dataChangedAfterLastSave()
        //textFieldDidEndEditing(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField){
       
        if textField == oversText  {
            animateViewMoving(false, moveValue: 140)
        }
        if textField == runsGivenText {
            animateViewMoving(false, moveValue: 210)
        }
        if textField == positionText {
            if positionText.text == "0" || positionText.text == "00"  {
                positionText.text = "1"
            }
        }

        if textField.tag == 1 {
            ValidateScore()
            
//            if textField.text?.trimWhiteSpace.length > 0{
//              //  parent?.dataChangedAfterLastSave()
//            }
        }
        else if textField.tag == 2 {
            validateOvers()
            
//            if textField.text?.trimWhiteSpace.length > 0{
//              //  parent?.dataChangedAfterLastSave()
//            }
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newlength = (textField.text!.characters.count) + string.characters.count - range.length
        
        //batting details
        if textField == runsText || textField == ballsPlayedText {
            return newlength <= 4
        }
        else if textField == foursText || textField == sixesText {
            return newlength <= 3
        }
        else if textField == positionText {
            
            return newlength <= 2
        }
         // bowling details
        else if textField == oversText {
            return newlength <= 5
        }
        else if textField == runsGivenText || textField == maidensText || textField == noballText || textField == widesText {
            return newlength <= 3
        }
        else if textField == wicketsText {
            return newlength <= 2
        }
        else if textField == dismissalText {
            return false
        }
        else {
            return true
        }
    }
}
