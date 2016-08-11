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

class MatchViewController: UIViewController,IndicatorInfoProvider {
    
    
    @IBOutlet weak var dateText:UITextField!
    @IBOutlet weak var teamText:UITextField!
    @IBOutlet weak var opponentText:UITextField!
    @IBOutlet weak var groundText:UITextField!
    @IBOutlet weak var oversText:UITextField!
    @IBOutlet weak var tournamentText:UITextField!
    
    
    let ctDatePicker = CTDatePicker()
    
    //var data = ["key1":"value1","key2":"value2","key3":"value3","key4":"value4"]
    
    var data:[String:String]{
        
        return ["Date":dateText.text!,"Team":teamText.text!,"Opponent":opponentText.text!,"Ground":groundText.text!,"Overs":oversText.text!,"Tournamnet":tournamentText.text!]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // commentsText.type = .multiline
        // commentsText.style =  CustomTextInputStyle()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MATCH")
    }
    
}


extension MatchViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if textField == dateText{
            ctDatePicker.showPicker(self, inputText: textField)
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

