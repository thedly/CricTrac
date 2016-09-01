//
//  CollapsibleTableViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 14/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XLPagerTabStrip
import XMExpandableTableView

class CollapsibleTableViewController:XMExpandableTableView,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var mainTable: UITableView!
    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var battingStyle: UILabel!
    @IBOutlet weak var bowlingStyle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var alias: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var playingRole: UILabel!
    
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBAction func collapseBtnPressed(sender: AnyObject) {
        
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);  //slecting 0th row with 0th section
        
            self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect);
        
        
        
        
        
        
    }
    
    @IBOutlet weak var collapseBtnImg: UIImageView!
   
    var data:[[String]] = [["Xavier Merino", "BSc. Computer Engineering", "Enjoys coding in Swift as a hobby."], ["Chocolate Snail", "Chocolate Eater", "Eats chocolate all day long."], ["Non-Expandable Row"]]
    
    var pictures:[UIImage] = [UIImage(named: "sachin")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialValues()
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        activityInd.layer.cornerRadius = profileImage.frame.size.width/2
        activityInd.clipsToBounds = true
        
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
//        profileImage.userInteractionEnabled = true
//        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        setNavigationBarProperties()
        
        self.tableView.scrollEnabled = false
        
        // Adding rows to the model
        super.rowModel.addRow(0, collapsedHeight: 115, expandedHeight: 282)
        super.rowModel.standardCollapsedHeight = 44

        
        setUIValues()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    
    @IBOutlet weak var UserName: UILabel!
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
//        let navBarView = UIView(frame: CGRectMake(0, 0, (sender.view?.frame.size.width)!, 50))
//        navBarView.backgroundColor = UIColor(hex: "#D4D4D4")
//        let editBtn = UIButton(frame: CGRectMake((sender.view?.frame.size.width)! - 100, 10, 50, 20))
//        editBtn.setBackgroundImage(UIImage(named: "EditPencil-100"), forState: .Normal)
//        navBarView.addSubview(editBtn)
        
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "dismissFullscreenImage:")
        newImageView.addGestureRecognizer(tap)
//        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func editImageBtnPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: "Change your picture", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let TakePictureAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(TakePictureAction)
        
        let chooseExistingAction = UIAlertAction(title: "Choose Existing", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(chooseExistingAction)
        
        
        let chooseFromFacebookAction = UIAlertAction(title: "Choose Default", style: .Default) { (action) in
            
            self.activityInd.startAnimating()
            
            let image:UIImage = getImageFromFacebook()
            
            self.profileImage.image = image
            
            addProfileImageData(image)
            self.activityInd.stopAnimating()
        }
        
        alertController.addAction(chooseFromFacebookAction)
        
        
        let removePhotoAction = UIAlertAction(title: "Remove Photo", style: .Default) { (action) in
            
            let image:UIImage = UIImage(named: "User")!
            
            self.profileImage.image = image
            addProfileImageData(image)
            
        }
        
        alertController.addAction(removePhotoAction)
        
        
        
        
        
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)
        
        currentCell!.contentView.backgroundColor = UIColor.clearColor()
        
        
        
        // ExpandedRow will be -1 if no row is selected.
        let expandedRow = super.rowModel.getExpandedRow()
        
        var expandedCell:UITableViewCell
        
        // This if statement is here because we only have two expandable cells, which are rows 0 and 1.
        if indexPath.row < 1 {
            if expandedRow == -1 {
                expandedCell = tableView.cellForRowAtIndexPath(indexPath)!
                (expandedCell as! CollapsibleTableViewCell).expandingAccessory.image = UIImage(named: "down")!
                
                collapseBtnImg.image = UIImage(named: "down")
                
            } else {
                expandedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: expandedRow, inSection: 0))!
                (expandedCell as! CollapsibleTableViewCell).expandingAccessory.image = UIImage(named: "up")!
                
                collapseBtnImg.image = UIImage(named: "up")
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 1 {
            
            
            //return containerView.frame.size.height
            
            if super.rowModel.isRowExpanded(forRow: 0) {
                return UIScreen.mainScreen().bounds.size.height - super.rowModel.getExpandedHeight(forRow: 0) - 60 // header height
            }
            else
            {
                return UIScreen.mainScreen().bounds.size.height - super.rowModel.getCollapsedHeight(forRow: 0) - 60
            }
            
        }
        else
        {
            if super.rowModel.isRowExpanded(forRow: indexPath.row) {
                return super.rowModel.getExpandedHeight(forRow: indexPath.row)
            }
            else
            {
                return super.rowModel.getCollapsedHeight(forRow: indexPath.row)
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // This if statement is here because we only have two expandable cells, which are rows 0 and 1.
        if indexPath.row < 1 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! CollapsibleTableViewCell
            cell.expandingAccessory.image = UIImage(named: "down")!
        }
    }
    
    
    // MARK: - functions
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didNewMatchButtonTapp(){
        
        let newMatchVc = viewControllerFrom("Main", vcid: "AddMatchDetailsViewController")
        self.presentViewController(newMatchVc, animated: true) {}
    }

    
    @IBAction func editProfilePressed(sender: AnyObject) {
        let editProfileVc = viewControllerFrom("Main", vcid: "UserInfoViewController")
        self.presentViewController(editProfileVc, animated: true) {}
    }
    
    //MARK: - Image picker delegate
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print(image)
        profileImage.image = image
        
        addProfileImageData(image)
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Functions
    
    func setNavigationBarProperties(){
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("+", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 30)
        addNewMatchButton.addTarget(self, action: #selector(didNewMatchButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = UIColor(hex:"B12420")
        title = "Dashboard"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    func getAge(birthdate:String) -> String{
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.dateFromString(birthdate)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.Year, fromDate: birthdayDate!, toDate: now, options: [])
        let age = calcAge.year
        return String(age)
    }
    
    func setUIValues() {
        activityInd.startAnimating()
        getImageFromFirebase { (data) in
            self.profileImage.image = data
            self.activityInd.stopAnimating()
        }
        
        
        getAllProfileData { (data) in
            
            profileData = data as! [String:String]
                
                if profileData.count > 0 {
                    
                    
                    self.username.text = (profileData["FirstName"]! + " " + profileData["LastName"]!).capitalizedString
                    
                    let dob:String = profileData["DateOfBirth"]! as String
                    
                    self.age.text = self.getAge(dob)
                    
                    self.alias.text = profileData["NickName"]
                    self.playingRole.text = profileData["PlayingRole"]
                    self.battingStyle.text = profileData["BattingStyle"]
                    self.bowlingStyle.text = profileData["BowlingStyle"]
                    
                    self.location.text = profileData["City"]! + ", "+profileData["Country"]!
                
                }
            
            
            
            
            
            
        }
    }

    
}


