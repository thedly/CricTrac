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
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    var selectedText:UITextField!
    
    let ctDatePicker = CTDatePicker()
    
    //var data = ["key1":"value1","key2":"value2","key3":"value3","key4":"value4"]
    
    var data:[String:String]{
        
        return ["Date":dateText.textVal,"Team":teamText.textVal,"Opponent":opponentText.textVal,"Ground":groundText.textVal,"Overs":oversText.textVal,"Tournamnet":tournamentText.textVal]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        //scrollViewTop = scrollView.frame.origin.y
        
        
        // Do any additional setup after loading the view.
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
    
}
