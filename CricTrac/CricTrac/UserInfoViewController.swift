//
//  UserInfoViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XLPagerTabStrip

class UserInfoViewController: UIViewController,IndicatorInfoProvider  {
    
    lazy var ctDatePicker = CTDatePicker()
    lazy var ctCountryPicker = CTCountryPicker()
    lazy var ctStatePicker = CTStatePicker()
    
    @IBOutlet weak var scrollView:UIScrollView!
    
   
    @IBOutlet weak var genderText: UILabel!
    @IBAction func genderSelectionPressed(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.genderText.text = "Male"
        }
        else
        {
            self.genderText.text = "Female"
        }
        
    }
    
    
    var teamdata: [String]!
    var grounddata: [String]!
    var opponentdata: [String]!
    
    
    @IBOutlet weak var datePickerButton:UIButton!
    
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var playingRole: UITextField!
    @IBOutlet weak var battingStyle: UITextField!
    @IBOutlet weak var bowlingStyle: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var nickName: UITextField!
    
    var selectedText:UITextField?
    
    
    var lastSelectedTab:UIView?
    var scrollViewTop:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeView()
        // Do any additional setup after loading the view.
    }
    
    func initializeView(){
        
        dateOfBirth.delegate = self
        country.delegate = self
        state.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "USER")
    }
    
    
    
    func keyboardWillShow(sender: NSNotification){
        
        if let userInfo = sender.userInfo {
            if  let  keyboardframe = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardHeight = keyboardframe.CGRectValue().height
                
                if selectedText != nil {
                    let viewBottom = view.frame.maxY
                    let textDesiredPosition = viewBottom - keyboardHeight - (selectedText?.frame.height)! - scrollViewTop - 100.0
                    
                    if textDesiredPosition < selectedText?.frame.minY {
                        
                        let aPoint = CGPoint(x: 0, y: textDesiredPosition)
                        scrollView.setContentOffset(aPoint, animated: true)
                        
                    }
                }
            }
        }
    }
}

extension UserInfoViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedText = textField
        
        if textField == dateOfBirth{
            ctDatePicker.showPicker(self, inputText: textField)
        }
        else if textField == country {
            ctCountryPicker.showPicker(self, inputText: textField)
            state.text = String()
        }
        else if textField == state {
            ctStatePicker.showPicker(self, inputText: textField, iso: ctCountryPicker.SelectedISO)
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}



