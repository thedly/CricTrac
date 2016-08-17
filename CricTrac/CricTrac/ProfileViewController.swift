//
//  ProfileViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 27/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var ctDatePicker = CTDatePicker()
    
    @IBOutlet weak var scrollView:UIScrollView!
    var imgPicker = UIImagePickerController()
    
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var miscTblView: UICollectionView!
    
    @IBOutlet weak var profileImg: UIImageView!
    
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
    
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    
    
    @IBOutlet weak var personalSelector: UIView!
    
    @IBOutlet weak var teamSelector: UIView!
    
    
    @IBOutlet weak var groundSelector: UIView!
    
    
    @IBOutlet weak var opponentSelector: UIView!
    
    var selectedText:UITextField?
    
    
    var lastSelectedTab:UIView?
    var scrollViewTop:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        miscTblView.dataSource = self
        miscTblView.delegate = self
        
        miscTblView.backgroundColor = UIColor.clearColor()
        
        
        //initializeView()
        // Do any additional setup after loading the view.
    }
    
    func initializeView(){
        lastSelectedTab = personalSelector
        imgPicker.delegate = self
        
        scrollView.setContentOffset(CGPointZero, animated: true)
        
        getMiscDetails()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        scrollView.setContentOffset(CGPointZero, animated: true)
        scrollViewTop = scrollView.frame.origin.y
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addPhotBtnPressed(sender: AnyObject) {
        
        presentViewController(imgPicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print(image)
        profileImg.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func scrollToTop(sender: AnyObject) {
        
        
        mainScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    @IBAction func scrollToBottom(sender: AnyObject) {
        
        var bottomOffset: CGPoint = CGPointMake(0, self.mainScrollView.contentSize.height - self.mainScrollView.bounds.size.height);
        
        mainScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    
    
    @IBAction func didTapCancel(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
    
    
    @IBAction func didTapPersonal(sender: AnyObject) {
        
        scrollView.setContentOffset(CGPointZero, animated: true)
        lastSelectedTab = personalSelector
        miscTblView.hidden = true
        scrollView.hidden = false
        noDataView.hidden = !scrollView.hidden
        hideAllSelectors()
        personalSelector.hidden = false
        miscTblView.reloadData()
    }
    
    
    @IBAction func didTapTeam(sender: AnyObject){
        scrollView.setContentOffset(CGPointZero, animated: true)
        miscTblView.hidden = teamdata.count == 0
        
        scrollView.hidden = true
        noDataView.hidden = !miscTblView.hidden
        
        lastSelectedTab = teamSelector
        hideAllSelectors()
        teamSelector.hidden = false
        miscTblView.reloadData()
    }
    
    
    @IBAction func didTapGround(sender: AnyObject) {
        scrollView.setContentOffset(CGPointZero, animated: true)
        miscTblView.hidden = grounddata.count == 0
        scrollView.hidden = true
        noDataView.hidden = !miscTblView.hidden
        lastSelectedTab = groundSelector
        hideAllSelectors()
        groundSelector.hidden = false
        miscTblView.reloadData()
    }
    
    
    @IBAction func didTapOpponent(sender: AnyObject) {
        scrollView.setContentOffset(CGPointZero, animated: true)
        miscTblView.hidden = opponentdata.count == 0
        scrollView.hidden = true
        noDataView.hidden = !miscTblView.hidden
        lastSelectedTab = opponentSelector
        hideAllSelectors()
        opponentSelector.hidden = false
        miscTblView.reloadData()
    }
    
    func hideAllSelectors(){
        personalSelector.hidden = true
        teamSelector.hidden = true
        opponentSelector.hidden = true
        groundSelector.hidden = true
        
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
    
    
    // MARk: - Table delegate functions
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell: FriendsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendsCollectionViewCell", forIndexPath: indexPath) as! FriendsCollectionViewCell {
            
            cell.configureCell("Sajith", friendTeamName: "hello", friendProfileImage: "")
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    
    
    // MARK: - Service calls
    func getMiscDetails() {
        teamdata = ["JOJO", "DPS", "INHS"]
        grounddata = ["D-Pitch, Indiranagar", "St.John's college, Koramangala "]
        opponentdata = []
    }
    
    
}



extension ProfileViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedText = textField
        
        if textField == dateOfBirth{
            ctDatePicker.showPicker(self, inputText: textField)
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}


