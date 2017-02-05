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
    let DoneButtonClassInstance = DoneButtonClass()
    
    weak var parent:MatchParent?
    
    //var data = ["key1":"value1","key2":"value2","key3":"value3","key4":"value4"]
    
    var data:[String:String]{
        
        return ["MatchDate":dateText.textVal,"Team":teamText.textVal,"Opponent":opponentText.textVal,"Ground":groundText.textVal,"MatchOvers":oversText.textVal,"Tournament":tournamentText.textVal, "AgeGroup": ageGroup.textVal, "Level": playingLevel.textVal, "Stage": stage.textVal, "Venue": venueText.textVal ]
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        oversText.keyboardType = UIKeyboardType.DecimalPad
        DoneButtonClassInstance.AddDoneButtonTo(oversText)
        
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
        
        dateText.textVal = parent!.selecetedData!["MatchDate"]! as! String
        tournamentText.textVal = (parent!.selecetedData!["Tournament"] ?? "") as! String
        teamText.textVal = parent!.selecetedData!["Team"]! as! String
        opponentText.textVal = parent!.selecetedData!["Opponent"]! as! String
        groundText.textVal = parent!.selecetedData!["Ground"]! as! String
        
        venueText.textVal = parent!.selecetedData!["Venue"]! as! String
        
        oversText.textVal = parent!.selecetedData!["MatchOvers"]! as! String
        
        if let ag = parent!.selecetedData!["AgeGroup"] {
            ageGroup.textVal = ag as! String
        }

        if let pl = parent!.selecetedData!["Level"] {
            playingLevel.textVal = pl as! String
        }
        if let pl = parent!.selecetedData!["Stage"] {
            stage.textVal = pl as! String
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
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text?.trimWhiteSpace.length > 0{
            
            parent?.dataChangedAfterLastSave()
        }
    }
    
}

