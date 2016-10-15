//
//  ExtraViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import AnimatedTextInput

class ExtraViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var commentsText:AnimatedTextInput!
    
    @IBOutlet weak var tossText:UITextField!
    @IBOutlet weak var firstBatText:UITextField!
    @IBOutlet weak var firstScoreText:UITextField!
    @IBOutlet weak var firstWicketsText:UITextField!
    @IBOutlet weak var secondBatText:UITextField!
    @IBOutlet weak var secondScoreText:UITextField!
    @IBOutlet weak var secondWicketsText:UITextField!
    @IBOutlet weak var resultText:UITextField!
    
    weak var matchDetails:MatchDetailsTrackable?
    var teams = [String]()
    
    weak var parent:MatchParent?
    
    var data:[String:String]{
        
        return ["Toss":tossText.textVal,"FirstBat":firstBatText.textVal,"FirstScore":firstScoreText.textVal,"FirstWickets":firstWicketsText.textVal,"SecondBat":secondBatText.textVal, "SecondScore":secondScoreText.textVal,"SecondWickets":secondWicketsText.textVal,"Result":resultText.textVal,"Comments":commentsText.text!]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsText.type = .multiline
        commentsText.style =  CustomTextInputStyle()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        setTeamData()
    }
    
    func loadEditData(){
        
        tossText.textVal = parent!.selecetedData!["Toss"]!
        firstBatText.textVal = parent!.selecetedData!["FirstBat"]!
        firstScoreText.textVal = parent!.selecetedData!["FirstScore"]!
        firstWicketsText.textVal = parent!.selecetedData!["FirstWickets"]!
        secondBatText.textVal = parent!.selecetedData!["SecondBat"]!
        
        secondScoreText.textVal = parent!.selecetedData!["SecondScore"]!
        secondWicketsText.textVal = parent!.selecetedData!["SecondWickets"]!
        resultText.textVal = parent!.selecetedData!["Result"]!
        commentsText.text = parent!.selecetedData!["Comments"]!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXTRA")
    }
    
    func allRequiredFieldsHaveFilledProperly()->Bool{
        
        return false
    }
    
    func setTeamData(){
        
        teams.removeAll()
        if matchDetails?.opponentText.text?.trimWhiteSpace.length > 0{
            
            if matchDetails?.teamText.text?.trimWhiteSpace.length > 0{
                
                teams.append((matchDetails?.teamText.text?.trimWhiteSpace)!)
                teams.append((matchDetails?.opponentText.text?.trimWhiteSpace)!)
            }
        }
    }
}

extension ExtraViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == tossText || textField == firstBatText || textField == secondBatText{
            if teams.count>0 {
                showPicker(self, inputText: textField, data: teams)
            }
        }
        else if textField == resultText{
            showPicker(self, inputText: textField, data: results)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.trimWhiteSpace.length > 0{
            
            parent?.dataChangedAfterLastSave()
        }
    }
}
