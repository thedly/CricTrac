//
//  ProfileViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 27/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    lazy var ctDatePicker = CTDatePicker()
    
    @IBOutlet weak var scrollView:UIScrollView!
    var imgPicker = UIImagePickerController()
    
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var miscTblView: UITableView!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    var teamdata: [String]!
    var grounddata: [String]!
    var opponentdata: [String]!
    
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
    
    
    
    @IBOutlet weak var personalSelector: UIView!
    
    @IBOutlet weak var teamSelector: UIView!
    
   
    @IBOutlet weak var groundSelector: UIView!
    
    
    @IBOutlet weak var opponentSelector: UIView!
    
    var lastSelectedTab:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeView()
        // Do any additional setup after loading the view.
    }
    
    func initializeView(){
        lastSelectedTab = personalSelector
        imgPicker.delegate = self
        miscTblView.dataSource = self
        miscTblView.delegate = self
        scrollView.setContentOffset(CGPointZero, animated: true)
        profileImg.layer.cornerRadius = 10
        profileImg.clipsToBounds = true
        getMiscDetails()
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
    
    
    
    
    // MARk: - Table delegate functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch lastSelectedTab! {
        case opponentSelector:
            return opponentdata.count
        case teamSelector:
            return teamdata.count
        case groundSelector:
            return grounddata.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch lastSelectedTab! {
        case groundSelector:
            cell.textLabel?.text = grounddata[indexPath.row]
        case teamSelector:
            cell.textLabel?.text = teamdata[indexPath.row]
        case opponentSelector:
            cell.textLabel?.text = opponentdata[indexPath.row]
        default:
            break
        }
        return cell
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            print("edit button tapped")
        }
        edit.backgroundColor = UIColor.lightGrayColor()
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("delete button tapped")
        }
        delete.backgroundColor = UIColor.redColor()
        return [delete, edit]
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
    
    // MARK: - Service calls
    
    
    func getMiscDetails() {
        teamdata = ["JOJO", "DPS", "INHS"]
        grounddata = ["D-Pitch, Indiranagar", "St.John's college, Koramangala "]
        opponentdata = []
    }

}
