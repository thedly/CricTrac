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

class MatchViewController: UIViewController,IndicatorInfoProvider,MatchDetailsTrackable {
    
    
    @IBOutlet weak var dateText:UITextField!
    @IBOutlet weak var teamText:UITextField!
    @IBOutlet weak var opponentText:UITextField!
    @IBOutlet weak var groundText:UITextField!
    @IBOutlet weak var oversText:UITextField!
    @IBOutlet weak var tournamentText:UITextField!
    
    @IBOutlet weak var ageGroup: UITextField!
    @IBOutlet weak var playingLevel: UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    
    var selectedText:UITextField!
    
    let ctDatePicker = CTDatePicker()
    let ctDataPicker = CTPicker()
    let DoneButtonClassInstance = DoneButtonClass()
    
    weak var parent:MatchParent?
    
    //var data = ["key1":"value1","key2":"value2","key3":"value3","key4":"value4"]
    
    var data:[String:String]{
        
        return ["MatchDate":dateText.textVal,"Team":teamText.textVal,"Opponent":opponentText.textVal,"Ground":groundText.textVal,"MatchOvers":oversText.textVal,"Tournamnet":tournamentText.textVal/*, "AgeGroup": ageGroup.textVal, "PlayingLevel": playingLevel.textVal*/]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        oversText.keyboardType = UIKeyboardType.DecimalPad
        DoneButtonClassInstance.AddDoneButtonTo(oversText)
        
        setUIBackgroundTheme(self.view)
    }
    
    
    func loadEditData(){
        
        dateText.textVal = parent!.selecetedData!["MatchDate"]!
        tournamentText.textVal = parent!.selecetedData!["Tournamnet"]!
        teamText.textVal = parent!.selecetedData!["Team"]!
        opponentText.textVal = parent!.selecetedData!["Opponent"]!
        groundText.textVal = parent!.selecetedData!["Ground"]!
        oversText.textVal = parent!.selecetedData!["MatchOvers"]!
        
//        if let ag = parent!.selecetedData!["AgeGroup"] {
//            ageGroup.textVal = ag
//        }
//        
//        if let pl = parent!.selecetedData!["PlayingLevel"] {
//            playingLevel.textVal = pl
//        }
        
        
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
        else if textField == opponentText{
            
            addSuggstionBox(textField,dataSource: opponentTeams)
        }
        else if textField == tournamentText{
            
            addSuggstionBox(textField,dataSource: tournaments)
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text?.trimWhiteSpace.length > 0{
            
            parent?.dataChangedAfterLastSave()
        }
    }
    
}

