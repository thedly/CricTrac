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
    var profileDetailsExists:Bool = false
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
    
    var profileData:[String:AnyObject]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeView()
        // Do any additional setup after loading the view.
    }
    
    
    var data:[String:String]{
        
        return ["FirstName":firstName.textVal,"MiddleName":middleName.textVal,"LastName":lastName.textVal,"DateOfBirth":dateOfBirth.textVal,"Email":emailId.textVal,"Mobile":mobile.textVal,"Gender":gender.textVal,"PlayingLevel":playingLevel.textVal,"PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"Country":country.textVal,"State":state.textVal,"City":city.textVal,"Height":height.textVal,"NickName":nickName.textVal]
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
        city.delegate = self
        emailId.delegate = self
        nickName.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        middleName.delegate = self
        
        loadInitialProfileValues()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
        
        
        getAllProfileData { (data) in
            
            
            self.profileData = data
            
            for (_,val) in data{
                
                var dataDict = val as! [String:String]
                
                if dataDict.count > 0 {
                    
                    self.profileDetailsExists = true
                    
                    self.firstName.text = dataDict["FirstName"]
                    self.middleName.text = dataDict["MiddleName"]
                    self.lastName.text = dataDict["LastName"]
                    self.dateOfBirth.text = dataDict["DateOfBirth"]
                    self.emailId.text = dataDict["Email"]
                    self.mobile.text = dataDict["Mobile"]
                    self.gender.text = dataDict["Gender"]
                    self.playingLevel.text = dataDict["PlayingLevel"]
                    self.playingRole.text = dataDict["PlayingRole"]
                    self.battingStyle.text = dataDict["BattingStyle"]
                    self.bowlingStyle.text = dataDict["BowlingStyle"]
                    self.country.text = dataDict["Country"]
                    self.state.text = dataDict["State"]
                    self.city.text = dataDict["City"]
                    self.height.text = dataDict["Height"]
                    self.nickName.text = dataDict["NickName"]
                    
                }
                
                
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
        
        let data = self.data
        addUserProfileData(data, userExists: self.profileDetailsExists)
        

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
            state.text = String()
        }
        else if textField == state {
            ctStatePicker.showPicker(self, inputText: textField, iso: ctCountryPicker.SelectedISO)
        }
        else if textField == height{
            ctHeightPicker.showPicker(self, inputText: textField)
        }
        else if  textField == gender{
            resignFirstResponder()
            ctDataPicker.showPicker(self, inputText: textField, data: genders)
        }
        else if  textField == playingRole{
            ctDataPicker = DataPicker()
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingRoles)
        }
        else if  textField == battingStyle{
            ctDataPicker = DataPicker()
            ctDataPicker.showPicker(self, inputText: textField, data: BattingStyles)
        }
        else if  textField == bowlingStyle{
            ctDataPicker = DataPicker()
            ctDataPicker.showPicker(self, inputText: textField, data: BowlingStyles)
        }
        else if textField == playingLevel {
            ctDataPicker = DataPicker()
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingLevels)
        }

    }
    
    
    
    
}



