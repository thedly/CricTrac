//
//  UserInfoViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XLPagerTabStrip
import SCLAlertView
import SkyFloatingLabelTextField

class UserInfoViewController: UIViewController,ThemeChangeable  {
    
    
    lazy var ctDatePicker = CTDatePicker()
    lazy var ctCountryPicker = CTCountryPicker()
    lazy var ctStatePicker = CTStatePicker()
    lazy var ctDataPicker = DataPicker()
    var profileDetailsExists:Bool = false
    
    var selectedText:UITextField!
    
    var userProfiles = [String]()
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var userProfileInfo: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
//    @IBOutlet weak var teamName: UITextField!
//    @IBOutlet weak var bowlingStyle: UITextField!
//    @IBOutlet weak var battingStyle: UITextField!
//    @IBOutlet weak var playingRole: UITextField!
    
    let transitionManager = TransitionManager.sharedInstance
    
    var lastSelectedTab:UIView?
    var scrollViewTop:CGFloat!
    
    var NextVC : UIViewController!
    
    var userProfile : String!
   
    var profileChanged: Bool! = false
    
    @IBAction func goPreviousPage(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        setNavigationBarProperties()
        initializeView()

       // self.navigationController?.interactivePopGestureRecognizer?.enabled = false
      //  sliderMenu.screenEdgePanGestreEnabled = false
        //setUIBackgroundTheme(self.view)
       // self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundColor()
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didTapCancel), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("NEXT", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
        addNewMatchButton.addTarget(self, action: #selector(addUserBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        if userProfileInfo != nil {
            title = "EDIT PROFILE"
        }else {
            title = "CREATE PROFILE"
        }
        
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    var data:[String:String]{
        
        return ["FirstName": firstName.textVal.trim(),"LastName":lastName.textVal.trim(),"DateOfBirth":dateOfBirth.textVal,"Email":emailId.textVal,"Mobile":mobile.textVal.trim(),"Gender":gender.textVal,"Country":country.textVal,"State":state.textVal,"City":city.textVal]
    }
    
    
    func initializeView(){
        
        dateOfBirth.delegate = self
        country.delegate = self
        state.delegate = self
        gender.delegate = self
        city.delegate = self
        emailId.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        mobile.delegate = self
        userProfileInfo.delegate = self
        
        
        emailId.userInteractionEnabled = false
        
        
        if userProfileInfo != nil {
            userProfiles.removeAll()
            for profile in userProfileType.allValues {
                userProfiles.append(profile.rawValue)
            }
            userProfileInfo.delegate = self
        }
        
        
//        playingRole.delegate = self
//        bowlingStyle.delegate = self
//        battingStyle.delegate = self
//        teamName.delegate = self
        
        
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//                    self.teamName.text = profileData.TeamName
//                    self.battingStyle.text = profileData.BattingStyle
//                    self.bowlingStyle.text = profileData.BowlingStyle
//                    self.playingRole.text = profileData.PlayingRole
                
        }
    
    func initialization()  {
        self.profileDetailsExists = true
        
        if let fName = profileData.FirstName as? String where fName.length > 0, let lName = profileData.LastName as? String where lName.length > 0 {
            self.firstName.text = fName
            self.lastName.text = lName
        }
        else
        {
            if let displayName = (currentUser?.displayName) where displayName.length > 0  {
                var fullNameArr = displayName.characters.split{$0 == " "}.map(String.init)
                self.firstName.text = fullNameArr[0]
                self.lastName.text = fullNameArr.count > 1 ? fullNameArr[1] : nil
            }
        }
        
        self.dateOfBirth.text = profileData.DateOfBirth
        self.emailId.text = currentUser?.email  //profileData.Email
        self.mobile.text = profileData.Mobile
        
        self.gender.text = profileData.Gender
        self.country.text = profileData.Country
        self.state.text = profileData.State
        self.city.text = profileData.City
        self.ctCountryPicker.SelectedCountry = profileData.Country
        
        if self.userProfileInfo != nil {
            self.userProfileInfo.text = profileData.UserProfile
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(sender: UIButton) {
        //dismissViewControllerAnimated(true) {}
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func addUserBtnPressed(sender: AnyObject) {
        
        self.continueToDismiss()
        
    }
    
//    @IBAction func addUserBtnPressed(sender: AnyObject) {
//        if validateProfileData() {
//            
////            if profileData.PlayingRole {
////
////            }
//            if userProfileInfo != nil {
//                if profileData.UserProfile != userProfileInfo.text {
//                    //profileData.UserProfile
//                    profileData.UserProfile = userProfileInfo.text!
//                    profileChanged = true
//                    let appearance = SCLAlertView.SCLAppearance(
//                        showCloseButton: false
//                    )
//                    
//                    let alertView = SCLAlertView(appearance: appearance)
//                    
//                    alertView.addButton("OK", target:self, selector:#selector(UserInfoViewController.continueToDismiss))
//                    
//                    alertView.addButton("Cancel", action: { })
//                    
//                    alertView.showNotice("Warning", subTitle: "Changing role will delete all existing data")
//                }else {
//                    profileChanged = false
//                    continueToDismiss()
//                }
//            }
//            else {
//                
//                if profileData.userExists {
//                    
//                    profileChanged = true
//                    let appearance = SCLAlertView.SCLAppearance(
//                        showCloseButton: false
//                    )
//                    
//                    let alertView = SCLAlertView(appearance: appearance)
//                    
//                    alertView.addButton("OK", target:self, selector:#selector(UserInfoViewController.continueToDismiss))
//                    
//                    alertView.addButton("Cancel", action: { })
//                    
//                    alertView.showNotice("Warning", subTitle: "Changing role will delete all existing data")
//                    
//                }
//                else
//                {
//                    profileChanged = false
//                    continueToDismiss()
//                }
//                
//            }
//            
//            
//        }
//        
//    }
//    
    func continueToDismiss() {
        profileData.FirstName = self.data["FirstName"]!
        profileData.LastName = self.data["LastName"]!
        profileData.DateOfBirth = self.data["DateOfBirth"]!
        profileData.Email = self.data["Email"]!
        profileData.Mobile = self.data["Mobile"]!
        profileData.Gender = self.data["Gender"]!
        profileData.Country = self.data["Country"]!
        profileData.State = self.data["State"]!
        profileData.City = self.data["City"]!
      //  profileData.UserProfile = self.data["UserProfile"]!
      
     //   if profileData != nil {
            switch profileData.UserProfile {
            case userProfileType.Player.rawValue :
                
                let vc = viewControllerFrom("Main", vcid: "PlayerExperienceViewController") as! PlayerExperienceViewController
                
                vc.profileChanged = self.profileChanged

                
                NextVC = vc
                
            case userProfileType.Coach.rawValue :
                
                let vc = viewControllerFrom("Main", vcid: "CoachingExperienceViewController") as! CoachingExperienceViewController
                
                vc.profileChanged = self.profileChanged

                
                NextVC = vc
            case userProfileType.Fan.rawValue :
                
                let vc = viewControllerFrom("Main", vcid: "CricketFanViewController") as! CricketFanViewController
                
                vc.profileChanged = self.profileChanged

                
                NextVC = vc
                
            default:
                
                let vc = viewControllerFrom("Main", vcid: "PlayerExperienceViewController") as! PlayerExperienceViewController
                
                vc.profileChanged = self.profileChanged


                NextVC = vc
            }
            
     //   }
        
        
        
        let toViewController = NextVC
      //  toViewController!.transitioningDelegate = self.transitionManager
        //presentViewController(toViewController!, animated: true, completion: nil)
        self.navigationController?.pushViewController(toViewController, animated: true)
        
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func validateProfileData() -> Bool {
        //var detailsValid = true
        if !(firstName.text?.hasDataPresent)! {
            (firstName as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (firstName as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            firstName.becomeFirstResponder()
            return false
        }
        else
        {
            (firstName as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (firstName as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#FFFFFF")
        }
        
        if !(dateOfBirth.text?.hasDataPresent)! {
            (dateOfBirth as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (dateOfBirth as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            dateOfBirth.becomeFirstResponder()
            return false
        }
        else
        {
            (dateOfBirth as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (dateOfBirth as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#FFFFFF")
        }
        
        if !(emailId.text?.hasDataPresent)! {
            (emailId as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (emailId as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            emailId.becomeFirstResponder()
            return false
        }
        else
        {
            (emailId as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (emailId as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#FFFFFF")
        }
        
        if !(mobile.text?.hasDataPresent)! {
            (mobile as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (mobile as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            mobile.becomeFirstResponder()
            return false
        }
        else
        {
            (mobile as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (mobile as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#FFFFFF")
        }
        
        if !(country.text?.hasDataPresent)! || country.text?.length > 50 {
            (country as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (country as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            country.becomeFirstResponder()
            return false
        }
        else
        {
            (country as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (country as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#FFFFFF")
        }
        
        if !(state.text?.hasDataPresent)! || state.text?.length > 50 {
            (state as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (state as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            state.becomeFirstResponder()
            return false
        }
        else
        {
            (state as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (state as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#6D9447")
        }
        
        if !(city.text?.hasDataPresent)! {
            (city as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#F00")
            (city as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#F00")
            city.becomeFirstResponder()
            return false
        }
        else
        {
            (city as! SkyFloatingLabelTextField).lineColor = UIColor(hex: "#FFFFFF")
            (city as! SkyFloatingLabelTextField).selectedLineColor = UIColor(hex: "#FFFFFF")
        }
        return true
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "USER")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == state || textField == country {
            return false
        }else {
              return true
        }
      
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
    
    
    func AddDoneButtonTo(inputText:UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(UserInfoViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(UserInfoViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }
    
    func donePressed() {
         selectedText.resignFirstResponder()
    }

  }

extension UserInfoViewController:UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedText = textField
        AddDoneButtonTo(textField)
        
        if textField == dateOfBirth{
            ctDatePicker.showPicker(self, inputText: textField)
        }
        else if textField == country {
            state.text = ""
            city.text = ""
            ctCountryPicker.showPicker(self, inputText: textField)
            //state.text = String()
        }
            
        else if userProfileInfo != nil && textField == userProfileInfo {
            ctDataPicker = DataPicker()
            let indexPos = userProfiles.indexOf(profileData.UserProfile) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: userProfiles,selectedValueIndex: indexPos)
        }
            
            
        else if textField == state {
            if country.text?.length >= 0 {
                state.userInteractionEnabled = true
                country.text = ""
                city.text = ""
                ctStatePicker.showPicker(self, inputText: textField, iso: ctCountryPicker.SelectedISO)
            }else {
               state.userInteractionEnabled = false
            }
            
        }
        else if  textField == gender{
            ctDataPicker = DataPicker()
            let indexPos = genders.indexOf(gender.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: genders,selectedValueIndex: indexPos)
        }
//        else if  textField == playingRole{
//            ctDataPicker = DataPicker()
//            let indexPos = PlayingRoles.indexOf(playingRole.text!) ?? 0
//            ctDataPicker.showPicker(self, inputText: textField, data: PlayingRoles,selectedValueIndex: indexPos)
//        }
//        else if  textField == battingStyle{
//            ctDataPicker = DataPicker()
//            let indexPos = BattingStyles.indexOf(battingStyle.text!) ?? 0
//            ctDataPicker.showPicker(self, inputText: textField, data: BattingStyles,selectedValueIndex: indexPos)
//        }
//        else if  textField == bowlingStyle{
//            ctDataPicker = DataPicker()
//            let indexPos = BowlingStyles.indexOf(bowlingStyle.text!) ?? 0
//            ctDataPicker.showPicker(self, inputText: textField, data: BowlingStyles,selectedValueIndex: indexPos)
//        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if validateProfileData() {
            if userProfileInfo != nil {
                if profileData.UserProfile != userProfileInfo.text {
                    
                    profileChanged = true
                    
                    let confirmAlert = UIAlertController(title: "Warning!" ,message:"Changing role will delete all existing role related data",preferredStyle: UIAlertControllerStyle.Alert)
                    confirmAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
                        
                       // self.continueToDismiss()
                        
                        
                    }))
                    
                    confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
                        
                        self.userProfileInfo.text = profileData.UserProfile
                        
                    }))
                    
                    self.presentViewController(confirmAlert, animated: true, completion: nil)
                }
//                else {
//                    
//                    profileChanged = false
//                    continueToDismiss()
//                }
            }
            
        }

        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if textField == firstName || textField == lastName || textField == city {
            return newLength <= nameCharacterLimit // Bool
        }else if textField == mobile {
            return newLength <= 15
        }
        else if textField == state || textField == country {
            return false
        }else {
            return true // Bool
        }
    }
    
}



