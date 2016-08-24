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
    lazy var ctHeightPicker = HeightPicker()
    lazy var ctDataPicker = DataPicker()
    @IBOutlet weak var scrollView:UIScrollView!
    
    
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
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var playingLevel: UITextField!
    
    @IBOutlet weak var mobile: UITextField!
    
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
        height.delegate = self
        gender.delegate = self
        playingRole.delegate = self
        battingStyle.delegate = self
        bowlingStyle.delegate = self
        playingLevel.delegate = self
        
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
                    let textDesiredPosition = viewBottom - keyboardHeight - (selectedText?.frame.height)! - scrollViewTop
                    
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
        else if textField == height{
            ctHeightPicker.showPicker(self, inputText: textField)
        }
        else if  textField == gender{
            ctDataPicker.showPicker(self, inputText: textField, data: genders)
        }
        else if  textField == playingRole{
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingRoles)
        }
        else if  textField == battingStyle{
            ctDataPicker.showPicker(self, inputText: textField, data: BattingStyles)
        }
        else if  textField == bowlingStyle{
            ctDataPicker.showPicker(self, inputText: textField, data: BowlingStyles)
        }
        else if textField == playingLevel {
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingLevels)
        }

    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}



