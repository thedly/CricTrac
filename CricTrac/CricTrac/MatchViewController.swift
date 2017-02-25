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
    
    var selectedText:UITextField!
    var scrollViewTop:CGFloat!
    
    let ctDatePicker = CTDatePicker()
    let ctDataPicker = CTPicker()
    
    weak var parent:MatchParent?
    
    //var data = ["key1":"value1","key2":"value2","key3":"value3","key4":"value4"]
    
    var data:[String:String]{
        
        var matchDateVal = ""
        
        if let val = dateText{
            
            matchDateVal = val.textVal
        }
        
        var teamVal = ""
        
        if let val = teamText{
            
            teamVal = val.textVal
        }
        
        var opponentVal = ""
        
        if let val = opponentText{
            
            opponentVal = val.textVal
        }
        
        var groundVal = ""
        
        if let val = groundText{
            
            groundVal = val.textVal
        }
        var oversVal = ""
        
        if let val = oversText{
            
            oversVal = val.textVal
        }
        
        var tournamentVal = ""
        
        if let val = tournamentText{
            
            tournamentVal = val.textVal
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
            
            venueVal = val.textVal
        }
        return ["MatchDate":matchDateVal,"Team":teamVal,"Opponent":opponentVal,"Ground":groundVal,"MatchOvers":oversVal,"Tournament":tournamentVal, "AgeGroup":ageGroupVal, "Level": playingLevelVal, "Stage":stageVal, "Venue": venueVal]
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        oversText.keyboardType = UIKeyboardType.DecimalPad
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
        
        //setBackgroundColor()
        
        //setUIBackgroundTheme(self.view)
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
    
    func loadEditData(){
        
        if  let selectedData = parent?.selecetedData{
        
        
        if let val = selectedData["MatchDate"] as? String{
            
            dateText.textVal = val
        }
        
        if let val = selectedData["Tournament"] as? String{
            
            tournamentText.textVal = val
        }
        
        if let val = selectedData["Team"] as? String{
            
            teamText.textVal = val
        }
        
        if let val = selectedData["Opponent"] as? String{
            
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
        if let pl = selectedData["Stage"] as? String {
            stage.textVal = pl
        }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MATCH")
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
        
        return false
    }
    
}


extension MatchViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedText = textField
        if textField == dateText{
            ctDatePicker.showPicker(self, inputText: textField)
        }
        else if textField == ageGroup {
            ctDataPicker.showPicker(self, inputText: textField, data: AgeGroupData )
        }
        else if textField == playingLevel {
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingLevels )
        }
        else if textField == teamText{
            addSuggstionBox(textField,dataSource: teamNames)
        }
        else if textField == groundText{
            addSuggstionBox(textField,dataSource: groundNames)
        }
        else if textField == venueText{
            addSuggstionBox(textField,dataSource: venueNames)
        }
        else if textField == opponentText{
            addSuggstionBox(textField,dataSource: opponentTeams)
        }
        else if textField == tournamentText{
            addSuggstionBox(textField,dataSource: tournaments)
        }
        else if textField == stage {
            ctDataPicker.showPicker(self, inputText: textField, data: MatchStage )
        }
        else if textField == oversText {
            AddDoneButtonTo(textField)
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
        
        if textField.text?.trimWhiteSpace.length > 0{
            
            parent?.dataChangedAfterLastSave()
        }
    }
    
}

