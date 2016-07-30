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
    var keyboardHeight:Int?
    var selectedText:UITextField?
    
    var scrollViewTop:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewMatchViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        lastSelectedTab = matchSelector
 scrollView.setContentOffset(CGPointZero, animated: true)
 scrollViewTop = scrollView.frame.origin.y
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(sender: NSNotification){
        
        if let userInfo = sender.userInfo {
            if  let  keyboardframe = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardHeight = keyboardframe.CGRectValue().height
                
                if selectedText != nil {
                let viewBottom = view.frame.maxY
                let textDesiredPosition = viewBottom - keyboardHeight - (selectedText?.frame.height)! - scrollViewTop
                
                    if textDesiredPosition < selectedText?.frame.minY {
                        
                        let aPoint = CGPoint(x: 0, y: textDesiredPosition)
                        scrollView.setContentOffset(aPoint, animated: true)
                        
                    }
                    
                
                }
                
                
            }
        }
        
        
        
    }

  
    @IBAction func didTapCancel(sender: UIButton) {
        
        dismissViewControllerAnimated(true) {}
    }

    
    @IBAction func didTapMatch(sender: AnyObject) {
        lastSelectedTab?.hidden = true
        matchSelector.hidden = false
        lastSelectedTab = matchSelector
        scrollView.setContentOffset(CGPointZero, animated: true)
        matchView.hidden = false
        batView.hidden = true
        bowlView.hidden = true
        extraView.hidden = true
    }
  
    
    @IBAction func didTapBat(sender: AnyObject){
        lastSelectedTab?.hidden = true
        battingSelector.hidden = false
        lastSelectedTab = battingSelector
         scrollView.setContentOffset(CGPointZero, animated: true)
       batView.hidden = false
       matchView.hidden = true
       bowlView.hidden = true
       extraView.hidden = true
    }
    
    
    @IBAction func didTapBowl(sender: AnyObject) {
        lastSelectedTab?.hidden = true
        bowlingSelector.hidden = false
        lastSelectedTab = bowlingSelector
         scrollView.setContentOffset(CGPointZero, animated: true)
         bowlView.hidden = false
        batView.hidden = true
        matchView.hidden = true
        extraView.hidden = true

    }
    
    
    @IBAction func didTapExtra(sender: AnyObject) {
         lastSelectedTab?.hidden = true
        extraSelector.hidden = false
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
        
        selectedText = textField

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
