//
//  NewMatchViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/23/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class NewMatchViewController: UIViewController {

    
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var matchView:UIView!
    
    @IBOutlet weak var batView:UIView!
    
    @IBOutlet weak var bowlView:UIView!
    
    @IBOutlet weak var extraView:UIView!
    
    @IBOutlet weak var dateTest: FloatLabelTextField!
    
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
    
    var datePicker : UIDatePicker!
    
    var lastSelectedTab:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedTab = matchSelector
 scrollView.setContentOffset(CGPointZero, animated: true)
        
        dateTest.inputView = datePicker
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPickerValueChange(sender:UIDatePicker){
        
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
        
        self.pickUpDate(textField)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
 
    
    func pickUpDate(textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRectMake(0, 0, self.view.frame.size.width, 216))
        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(NewMatchViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(NewMatchViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick() {
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .MediumStyle
        dateFormatter1.timeStyle = .NoStyle
        //textField_Date.text = dateFormatter1.stringFromDate(datePicker.date)
        //textField_Date.resignFirstResponder()
    }
    func cancelClick() {
        dateTest.resignFirstResponder()
    }
    
}
