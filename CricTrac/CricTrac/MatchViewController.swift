//
//  MatchViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/5/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AnimatedTextInput

class MatchViewController: UIViewController,IndicatorInfoProvider,MatchDetailsTrackable,ThemeChangeable {
    
    @IBOutlet weak var stage: UITextField!
    @IBOutlet weak var dateText:UITextField!
    @IBOutlet weak var teamText:UITextField!
    @IBOutlet weak var opponentText:UITextField!
    @IBOutlet weak var groundText:UITextField!
    @IBOutlet weak var oversText:UITextField!
    @IBOutlet weak var tournamentText:UITextField!
    @IBOutlet weak var venueText: UITextField!
    @IBOutlet weak var ageGroup: UITextField!
    @IBOutlet weak var playingLevel: UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBInspectable var placeholderColor: UIColor = UIColor.blackColor()

    var teamOROpponentFieldChanged : Bool = false
    var selectedText:UITextField!
    var scrollViewTop:CGFloat!
    var existTeamName = ""
    var existOppName = ""
    let ctDatePicker = CTDatePicker()
    lazy var ctDataPicker = DataPicker()
    weak var parent:MatchParent?
    var data:[String:String]{
    
    var matchDateVal = ""
    if let val = dateText{
        matchDateVal = val.textVal
    }
    
    var teamVal = ""
    if let val = teamText{
        teamVal = val.textVal.trim()
    }
    
    var opponentVal = ""
    if let val = opponentText{
        opponentVal = val.textVal.trim()
    }
    
    var groundVal = ""
    if let val = groundText{
        groundVal = val.textVal.trim()
    }
    
    var oversVal = ""
    if let val = oversText{
        oversVal = val.textVal
    }
    
    var tournamentVal = ""
    if let val = tournamentText{
        tournamentVal = val.textVal.trim()
    }
    
    var ageGroupVal = ""
    if let val = ageGroup{
        ageGroupVal = val.textVal
    }
    
    var playingLevelVal = ""
    if let val = playingLevel{
        playingLevelVal = val.textVal
    }
    
    var stageVal = ""
    if let val = stage{
        stageVal = val.textVal
    }
    
    var venueVal = ""
    if let val = venueText{
        venueVal = val.textVal.trim()
    }
    
    return ["MatchDate":matchDateVal,"Team":teamVal,"Opponent":opponentVal,"Ground":groundVal,"MatchOvers":oversVal,"Tournament":tournamentVal, "AgeGroup":ageGroupVal, "Level": playingLevelVal, "MatchStage":stageVal, "Venue": venueVal]
    }
    
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((parent?.selecetedData) != nil){
            loadEditData()
        }
        else {
            loadDefaultData()
        }
        
        oversText.keyboardType = UIKeyboardType.NumberPad
        self.view.backgroundColor = UIColor.clearColor()
        
        self.stage.delegate = self
        self.dateText.delegate = self
        self.teamText.delegate = self
        self.opponentText.delegate = self
        self.groundText.delegate = self
        self.oversText.delegate = self
        self.tournamentText.delegate = self
        self.venueText.delegate = self
        self.ageGroup.delegate = self
        self.playingLevel.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
    }
    
    func keyboardWillShow(sender: NSNotification){
        
        if let userInfo = sender.userInfo {
            if  let  keyboardframe = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardHeight = keyboardframe.CGRectValue().height
                
                var contentInset:UIEdgeInsets = self.scrollView.contentInset
                contentInset.bottom = keyboardHeight + 10
                self.scrollView.contentInset = contentInset
            }
        }
    }

    func loadDefaultData(){
        let date = NSDate()
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let dob = profileData.DateOfBirth
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        let birthdayDate = dateFormater.dateFromString(dob)
       
        let calcAge = calendar.components(.Year, fromDate: birthdayDate!, toDate: date, options: [])
        let age = calcAge.year + 1
        
        var ageGroup1 = " "
        if age <= 10 {
             ageGroup1 = "Under 10"
        }
        else if age > 23 {
             ageGroup1 = "Seniors"
        }
        else {
             ageGroup1 = "Under \(age)"
        }
        ageGroup.textVal = ageGroup1
        
        let plLevel = "Club"
        playingLevel.textVal = plLevel
    }
    
    
    func loadEditData(){
        
        if  let selectedData = parent?.selecetedData{
            if let val = selectedData["MatchDate"] as? String{
                dateText.textVal = val
            }
            
            if let val = selectedData["Tournament"] as? String{
                tournamentText.textVal = val
            }
            
            if let val = selectedData["Team"] as? String{
                existTeamName = val
                teamText.textVal = val
            }
            
            if let val = selectedData["Opponent"] as? String{
                existOppName = val
                opponentText.textVal = val
            }
            
            if let val = selectedData["Ground"] as? String{
                groundText.textVal = val
            }
            
            if let val = selectedData["Venue"] as? String{
                venueText.textVal = val
            }
            
            if let val = selectedData["MatchOvers"] as? String{
                oversText.textVal = val
            }
                
            if let ag = selectedData["AgeGroup"] as? String{
                ageGroup.textVal = ag
            }

            if let pl = selectedData["Level"] as? String {
                playingLevel.textVal = pl
            }
            if let pl = selectedData["MatchStage"] as? String {
                stage.textVal = pl
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DETAILS")
    }
    
    var allRequiredFieldsHaveNotFilledProperly:Bool{
        
        if !(dateText.text?.hasDataPresent)!{
            return true
        }
        else if !(teamText.text?.hasDataPresent)!{
            
            return true
        }
        else if !(opponentText.text?.hasDataPresent)!{
            
            return true
        }
//        else if !(groundText.text?.hasDataPresent)!{
//            
//            return true
//        }
        
        return false
    }
}


extension MatchViewController:UITextFieldDelegate
{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedText = textField
        if textField == dateText{
            
            ctDatePicker.showPicker(self, inputText: textField)
        }
         if textField == ageGroup {
            ctDataPicker = DataPicker()
            let indexPos = AgeGroupData.indexOf(ageGroup.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: AgeGroupData,selectedValueIndex: indexPos)
           // ctDataPicker.showPicker(self, inputText: textField, data: AgeGroupData )
        }
        else if textField == playingLevel {
            ctDataPicker = DataPicker()
            let indexPos = PlayingLevels.indexOf(playingLevel.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingLevels,selectedValueIndex: indexPos)
           // ctDataPicker.showPicker(self, inputText: textField, data: PlayingLevels )
        }
        else if textField == teamText{
            addSuggstionBox(textField,dataSource: teamNames)
            self.teamOROpponentFieldChanged = true
        }
        else if textField == groundText{
            animateViewMoving(true, moveValue: 100)
            addSuggstionBox(textField,dataSource: groundNames)
        }
        else if textField == venueText{
             animateViewMoving(true, moveValue: 100)
            addSuggstionBox(textField,dataSource: venueNames)
        }
        else if textField == opponentText{
            addSuggstionBox(textField,dataSource: opponentTeams)
            self.teamOROpponentFieldChanged = true
        }
        else if textField == tournamentText{
            animateViewMoving(true, moveValue: 100)
            addSuggstionBox(textField,dataSource: tournaments)
        }
        else if textField == stage {
            ctDataPicker = DataPicker()
            let indexPos = MatchStage.indexOf(stage.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: MatchStage,selectedValueIndex: indexPos)
           // ctDataPicker.showPicker(self, inputText: textField, data: MatchStage )
        }
        else if textField == oversText {
             animateViewMoving(true, moveValue: 70)
            AddDoneButtonTo(textField)
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
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(MatchViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(MatchViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }

    func donePressed() {
        selectedText.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
         if textField == venueText || textField == tournamentText || textField == groundText {
            animateViewMoving(false, moveValue: 100)
        }
         else if textField == oversText {
           animateViewMoving(false, moveValue: 70)
        }
        
//        if textField.text?.trimWhiteSpace.length > 0{
//            
//            parent?.dataChangedAfterLastSave()
//        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField == teamText || textField == opponentText || textField == groundText || textField == venueText || textField == tournamentText {
            return newLength <= nameCharacterLimit // bool
        }
        else if textField == oversText {
            return newLength <= 3
        }
        else if textField == dateText || textField == ageGroup || textField == playingLevel || textField == stage {
            return false
        }
        else{
            return true // Bool
        }
    }
    
}

