//
//  UserInfoViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField

class UserInfoViewController: UIViewController,IndicatorInfoProvider  {
    
    lazy var ctDatePicker = CTDatePicker()
    lazy var ctCountryPicker = CTCountryPicker()
    lazy var ctStatePicker = CTStatePicker()
    lazy var ctHeightPicker = HeightPicker()
    lazy var ctDataPicker = DataPicker()
    var profileDetailsExists:Bool = false
    @IBOutlet weak var scrollView:UIScrollView!
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var playingRole: UITextField!
    @IBOutlet weak var battingStyle: UITextField!
    @IBOutlet weak var bowlingStyle: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    var selectedText:UITextField?
    
    
    var lastSelectedTab:UIView?
    var scrollViewTop:CGFloat!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeView()
        // Do any additional setup after loading the view.
    }
    
    
    var data:[String:String]{
        
        return ["FirstName":firstName.textVal,"LastName":lastName.textVal,"DateOfBirth":dateOfBirth.textVal,"Email":emailId.textVal,"Mobile":mobile.textVal,"Gender":gender.textVal,"PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"Country":country.textVal,"State":state.textVal,"City":city.textVal,"TeamName":teamName.textVal]
    }
    
    
    func initializeView(){
        
        dateOfBirth.delegate = self
        country.delegate = self
        state.delegate = self
        gender.delegate = self
        playingRole.delegate = self
        battingStyle.delegate = self
        bowlingStyle.delegate = self
        city.delegate = self
        emailId.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        teamName.delegate = self
        
        loadInitialProfileValues()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
            
            getAllProfileData { (data) in
                
                profileData = data as! [String:String]
                
                if profileData.count > 0 {
                    
                    
                    self.profileDetailsExists = true
                    
                    self.firstName.text = profileData["FirstName"]
                    self.lastName.text = profileData["LastName"]
                    self.dateOfBirth.text = profileData["DateOfBirth"]
                    self.emailId.text = profileData["Email"]
                    self.mobile.text = profileData["Mobile"]
                    self.gender.text = profileData["Gender"]
                    self.playingRole.text = profileData["PlayingRole"]
                    self.battingStyle.text = profileData["BattingStyle"]
                    self.bowlingStyle.text = profileData["BowlingStyle"]
                    self.country.text = profileData["Country"]
                    self.state.text = profileData["State"]
                    self.city.text = profileData["City"]
                    self.teamName.text = profileData["TeamName"]
                    
                    self.ctCountryPicker.SelectedCountry = profileData["Country"]!
                    
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
    
    @IBAction func addUserBtnPressed(sender: AnyObject) {
        if validateProfileData() {
            let data = self.data
            addUserProfileData(data, sucessBlock: {data in
                profileDataChanged = true
            })
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func validateProfileData() -> Bool {
        //var detailsValid = true
        if !(firstName.text?.hasDataPresent)! || firstName.text?.length > 25 {
            (firstName as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (firstName as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            firstName.becomeFirstResponder()
            return false
        }
        else
        {
            (firstName as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
            (firstName as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
        }
        
        if !(dateOfBirth.text?.hasDataPresent)! || dateOfBirth.text?.length > 25 {
            (dateOfBirth as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (dateOfBirth as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            dateOfBirth.becomeFirstResponder()
            return false
        }
        else
        {
            (dateOfBirth as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
            (dateOfBirth as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
        }
        
        if !(emailId.text?.hasDataPresent)! {
            (emailId as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (emailId as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            emailId.becomeFirstResponder()
            return false
        }
        else
        {
            (emailId as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
            (emailId as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
        }
        
        if !(mobile.text?.hasDataPresent)! || mobile.text?.length != 10 {
            (mobile as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (mobile as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            mobile.becomeFirstResponder()
            return false
        }
        else
        {
            (mobile as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
            (mobile as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
        }
        
//        if !(country.text?.hasDataPresent)! || country.text?.length > 50 {
//            (country as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
//            (country as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
//            country.becomeFirstResponder()
//            return false
//        }
//        else
//        {
//            (country as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
//            (country as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
//        }
        
//        if !(state.text?.hasDataPresent)! || state.text?.length > 25 {
//            (state as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
//            (state as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
//            state.becomeFirstResponder()
//            return false
//        }
//        else
//        {
//            (state as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
//            (state as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
//        }
        
        if !(city.text?.hasDataPresent)! || city.text?.length > 25 {
            (city as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (city as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            city.becomeFirstResponder()
            return false
        }
        else
        {
            (city as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#D4D4D4")
            (city as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
        }
        return true
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "USER")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
}

extension UserInfoViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedText = textField
        
        if textField == dateOfBirth{
            ctDatePicker.showPicker(self, inputText: textField)
        }
        else if textField == country {
            ctCountryPicker.showPicker(self, inputText: textField)
            //state.text = String()
        }
        else if textField == state {
            ctStatePicker.showPicker(self, inputText: textField, iso: ctCountryPicker.SelectedISO)
        }
        else if  textField == gender{
            ctDataPicker = DataPicker()
            let indexPos = genders.indexOf(gender.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: genders,selectedValueIndex: indexPos)
        }
        else if  textField == playingRole{
            ctDataPicker = DataPicker()
            let indexPos = PlayingRoles.indexOf(playingRole.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingRoles, selectedValueIndex: indexPos)
        }
        else if  textField == battingStyle{
            ctDataPicker = DataPicker()
            let indexPos = BattingStyles.indexOf(battingStyle.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: BattingStyles,selectedValueIndex: indexPos)
        }
        else if  textField == bowlingStyle{
            ctDataPicker = DataPicker()
            let indexPos = BowlingStyles.indexOf(bowlingStyle.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: BowlingStyles, selectedValueIndex: indexPos)
        }
    }
    
    
   
    
    
}



