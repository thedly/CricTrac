//
//  ProfileViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 27/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var ctDatePicker = CTDatePicker()
    
    @IBOutlet weak var scrollView:UIScrollView!
    var imgPicker = UIImagePickerController()
    
    
    @IBOutlet weak var miscTblView: UITableView!
    
    @IBOutlet weak var profileImg: UIImageView!
    
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
        imgPicker.delegate = self
        scrollView.setContentOffset(CGPointZero, animated: true)
        
        
        // Do any additional setup after loading the view.
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
    
    
    @IBAction func didTapCancel(sender: UIButton) {
 dismissViewControllerAnimated(true) {}
    }
    
    
    @IBAction func didTapPersonal(sender: AnyObject) {
        
        scrollView.setContentOffset(CGPointZero, animated: true)
       miscTblView.hidden = true
        scrollView.hidden = false
    }
    
    
    @IBAction func didTapTeam(sender: AnyObject){
        scrollView.setContentOffset(CGPointZero, animated: true)
        miscTblView.hidden = false
        scrollView.hidden = true
    }
    
    
    @IBAction func didTapGround(sender: AnyObject) {
        scrollView.setContentOffset(CGPointZero, animated: true)
        miscTblView.hidden = false
        scrollView.hidden = true
        
    }
    
    
    @IBAction func didTapOpponent(sender: AnyObject) {
        scrollView.setContentOffset(CGPointZero, animated: true)
        miscTblView.hidden = false
        scrollView.hidden = true
    }
    
    func hideAllSelectors(){
        matchSelector.hidden = true
        battingSelector.hidden = true
        bowlingSelector.hidden = true
        extraSelector.hidden = true
    }
    
    
}


extension ProfileViewController:UITextFieldDelegate{
    
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
