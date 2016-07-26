//
//  NewMatchViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/23/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class NewMatchViewController: UIViewController {

    lazy var ctDatePicker = CTDatePicker()
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var matchView:UIView!
    
    @IBOutlet weak var batView:UIView!
    
    @IBOutlet weak var bowlView:UIView!
    
    @IBOutlet weak var extraView:UIView!
    
    @IBOutlet weak var dateTest: UITextField!
    
    @IBOutlet weak var datePickerButton:UIButton!
    
    
    @IBOutlet weak var teamText: UITextField!
    
    
    @IBOutlet weak var opponentText: UITextField!
    
    
    @IBOutlet weak var groundText: UITextField!
    
    
    @IBOutlet weak var OversText: UITextField!
    
    
    @IBOutlet weak var tournamnetText: UITextField!
    
    
    @IBOutlet weak var dismissText: UITextField!
    
    
    
    @IBOutlet weak var extraOverText: UITextField!
    
    
    @IBOutlet weak var wicketsText: UITextField!
    
    
    @IBOutlet weak var resultsText: UITextField!
    
    
    
    
    @IBOutlet weak var commentsText: UITextView!
    
    
    
    @IBOutlet weak var matchSelector: UIView!
    
    @IBOutlet weak var bowlingSelector: UIView!
    
   
    @IBOutlet weak var extraSelector: UIView!
    
    @IBOutlet weak var battingSelector: UIView!
    
    
    var lastSelectedTab:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedTab = matchSelector
 scrollView.setContentOffset(CGPointZero, animated: true)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    @IBAction func didTapCancel(sender: UIButton) {
        
        dismissViewControllerAnimated(true) {}
    }

    
    @IBAction func didTapMatch(sender: AnyObject) {
        matchSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = matchSelector
        scrollView.setContentOffset(CGPointZero, animated: true)
        matchView.hidden = false
        batView.hidden = true
        bowlView.hidden = true
        extraView.hidden = true
    }
  
    
    @IBAction func didTapBat(sender: AnyObject){
        battingSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = battingSelector
         scrollView.setContentOffset(CGPointZero, animated: true)
       batView.hidden = false
       matchView.hidden = true
       bowlView.hidden = true
       extraView.hidden = true
    }
    
    
    @IBAction func didTapBowl(sender: AnyObject) {
        bowlingSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = bowlingSelector
         scrollView.setContentOffset(CGPointZero, animated: true)
         bowlView.hidden = false
        batView.hidden = true
        matchView.hidden = true
        extraView.hidden = true

    }
    
    
    @IBAction func didTapExtra(sender: AnyObject) {
        extraSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = extraSelector
         scrollView.setContentOffset(CGPointZero, animated: true)
   extraView.hidden = false
        bowlView.hidden = true
        batView.hidden = true
        matchView.hidden = true
        
    }
    
    func hideAllSelectors(){
        matchSelector.hidden = true
        battingSelector.hidden = true
        bowlingSelector.hidden = true
        extraSelector.hidden = true
    }


}


extension NewMatchViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let origin = textField.frame.origin
        let aPoint = CGPoint(x: 0, y: origin.y)
    scrollView.setContentOffset(aPoint, animated: true)
        
        if textField == dateTest{
        ctDatePicker.showPicker(self, inputText: textField)
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
 
    
    
}
