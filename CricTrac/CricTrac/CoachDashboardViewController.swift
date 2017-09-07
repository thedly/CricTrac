//
//  CoachDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 21/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD
import FirebaseAuth
import GoogleMobileAds
import Kingfisher
import SwiftCountryPicker

class CoachDashboardViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, ThemeChangeable,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    // for teams
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coachTeams: UICollectionView!
    @IBOutlet weak var coachTeamsHeightConstraint: NSLayoutConstraint!
    
    var myCoachFrndNodeId = ""
    var myPlayersFrndNodeId = ""
    
    
    // for new features
    @IBOutlet weak var totalPlayers: UILabel!
    @IBOutlet weak var totalBatsmen: UILabel!
    @IBOutlet weak var totalBowlers: UILabel!
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var totalAllRounders: UILabel!
    @IBOutlet weak var totalAvgAge: UILabel!
    @IBOutlet weak var topBowlingTableView: UITableView!
    @IBOutlet weak var topBattingtableView: UITableView!
    @IBOutlet weak var coachFrndButton: UIButton!
    @IBOutlet weak var pendingRequests: UIButton!
    @IBOutlet weak var coachFrndBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var battingTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bowlingTableViewHeightConstraint: NSLayoutConstraint!
    
    var topBattingnames = ["Arjun Kumar","Kushal Rajiv","Krit Gupta","Noel Phlip","Lochan goudal"]
    
    @IBAction func CloseDashboardPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    var coverOrProfile = ""
    var friendId:String? = nil
    var currentUserId = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        coachTeams.reloadData()
        
        setBackgroundColor()
        initView()
        updateCoachDashboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        let currentTheme = cricTracTheme.currentTheme

        pendingRequests.layer.cornerRadius = 10
        pendingRequests.clipsToBounds = true
        pendingRequests.backgroundColor = currentTheme.bottomColor
        pendingRequests.layer.borderWidth = 2.0
        pendingRequests.layer.borderColor = UIColor.whiteColor().CGColor
        
        coachFrndButton.layer.cornerRadius = 10
        coachFrndButton.clipsToBounds = true
        coachFrndButton.backgroundColor = currentTheme.bottomColor
        coachFrndButton.layer.borderWidth = 2.0
        coachFrndButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        coachTeams.delegate = self
        coachTeams.dataSource = self
    }
    
    func loadBannerAds() {
        if showAds == "1" {
            self.bannerViewHeightConstraint.constant = 50
            bannerView.adUnitID = adUnitId
            bannerView.rootViewController = self
            bannerView.loadRequest(GADRequest())
        }
        else {
            self.bannerViewHeightConstraint.constant = 0
        }
    }
    
    func coachValidation() {
        
        if profileData.UserProfile == "Player" {
            
            coachFrndBtnHeightConstraint.constant = 30
            pendingRequests.hidden = true
            var coachExist = 0
            getMyCoaches({ (result) in
                for (_, req) in result {
                    if let data = req as? [String : AnyObject] {
                        let coachID = String(data["CoachID"]!)
                        let isAccepted = String(data["isAccepted"]!)
                        self.myCoachFrndNodeId = String(data["CoachNodeIdOther"]!)
                        self.myPlayersFrndNodeId = String(data["PlayerNodeID"]!)
                        if coachID == self.currentUserId {
                            coachExist = 1

                            if isAccepted == "0" {
                                
                                self.coachFrndButton.setTitle("Cancel Request", forState: .Normal)
                            }
                            else{
                                self.coachFrndButton.setTitle("Remove Coach", forState: .Normal)
                            }
                            break
                        }
                    }
                }
            })
            if coachExist == 0 {
                self.coachFrndButton.setTitle("Mark as my Coach", forState: .Normal)
            }
            
        }
       
        else if profileData.UserProfile == "Coach" {
            coachFrndButton.setTitle("My Players", forState: .Normal)
//            coachFrndBtnHeightConstraint.constant = 30
//            pendingRequests.hidden = false
            
        }
        else if profileData.UserProfile == "Cricket Fan" {
            coachFrndBtnHeightConstraint.constant = 0
            coachFrndButton.hidden = true
            pendingRequests.hidden = true
        }

    }
    
    func initView() {
        
        coachValidation()
        
        if let value = friendProfile{
            if profileData.UserProfile == "Coach" {
                coachFrndButton.hidden = true
                pendingRequests.hidden = true
                coachFrndBtnHeightConstraint.constant = 0
            }
          userProfileData = Profile(usrObj: value)
        }
        else{
            coachFrndButton.hidden = false
            pendingRequests.hidden = false
            coachFrndBtnHeightConstraint.constant = 30
            userProfileData = profileData
        }
        
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        userProfileImage.clipsToBounds = true
        
        let currentCountryList = CountriesList.filter({$0.name == userProfileData.Country})
        let currentISO = currentCountryList[0].iso
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.PlayerName.text = userProfileData.fullName.uppercaseString
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State), ", fontName: appFont_black, fontSize: 15).bold("\(currentISO) ", fontName: appFont_black, fontSize: 15)
        self.PlayerLocation.attributedText = locationText
        
        if friendId == nil {
            currentUserId = (currentUser?.uid)!
        }
        else {
            currentUserId = friendId!
        }
        
        fetchBasicProfile(currentUserId, sucess: { (result) in
            let proPic = result["proPic"]
            
            if proPic! == "-"{
                let imageName = defaultProfileImage
                let image = UIImage(named: imageName)
                self.userProfileImage.image = image
            }
            else{
                if let imageURL = NSURL(string:proPic!){
                    self.userProfileImage.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        fetchCoverPhoto(currentUserId, sucess: { (result) in
            let coverPic = result["coverPic"]
            
            if coverPic! == "-"{
                let imageName = defaultCoverImage
                let image = UIImage(named: imageName)
                self.imgCoverPhoto.image = image
            }
            else{
                if let imageURL = NSURL(string:coverPic!){
                    self.imgCoverPhoto.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        setNavigationBarProperties()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCoverPhoto))
        tapGesture.numberOfTapsRequired = 1
        imgCoverPhoto.addGestureRecognizer(tapGesture)
    }
    
    
    // Only players can see this button
    @IBAction func coachActionBtnTapped(sender: UIButton) {
        
        switch coachFrndButton.currentTitle! {
        case "Mark as my Coach":
            
                markMyCoach(currentUserId)
               
                let alert = UIAlertController(title: "", message:"Coach Request Sent", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                 coachValidation()

                break
            
        case "Cancel Request":
        
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Cancel this request?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let unfriendAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                fireBaseRef.child("Users").child(self.currentUserId).child("MyPlayers").child(self.myPlayersFrndNodeId).removeValue()
                fireBaseRef.child("Users").child((currentUser?.uid)!).child("MyCoaches").child(self.myCoachFrndNodeId).removeValue()
                self.coachValidation()
                
            }
            actionSheetController.addAction(unfriendAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        
            break
            
        case "Remove Coach":
            
           
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to Remove this coach?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                // Just dismiss the action sheet
                actionSheetController.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheetController.addAction(cancelAction)
            
            let unfriendAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                fireBaseRef.child("Users").child(self.currentUserId).child("MyPlayers").child(self.myPlayersFrndNodeId).removeValue()
                fireBaseRef.child("Users").child((currentUser?.uid)!).child("MyCoaches").child(self.myCoachFrndNodeId).removeValue()
                self.coachFrndButton.setTitle("Mark as my Coach", forState: .Normal)
                
            }
            actionSheetController.addAction(unfriendAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
            break

            
        default:
            
            let dashBoard = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
            self.presentViewController(dashBoard, animated: false, completion: nil)
            break

        }

    }
    
    
    var alertMessage = "Change picture"
    
    func tapCoverPhoto()  {
        if friendId == nil {
            alertMessage = "Change your cover photo"
            self.photoOptionsToCoverPic("CoverPhoto")
            coverOrProfile = "Cover"
        }
    }
    
    @IBAction func editImageBtnPressed(sender: AnyObject) {
        if friendId == nil {
            alertMessage = "Change your profile photo"
            self.photoOptions("ProfilePhoto")
            coverOrProfile = "Profile"
        }
        else{
            let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
            
            profileImageVc.imageString = userProfileData.ProfileImageURL
            if userProfileData.ProfileImageURL != "-" {
                self.presentViewController(profileImageVc, animated: true) {}
            }
        }
    }
    
    func photoOptionsToCoverPic(option:String)  {
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .ActionSheet)
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
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }

    
    func photoOptions(option:String)  {
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .ActionSheet)
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
       
        let viewPhotoAction = UIAlertAction(title: "View Photo", style: .Default) { (action) in
            
            self.viewImage(option)
        }
        
        alertController.addAction(viewPhotoAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func viewImage(option:String){
        
        let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
        
        profileImageVc.imageString = profileData.ProfileImageURL
        if profileData.ProfileImageURL != "-" {
            self.presentViewController(profileImageVc, animated: true) {}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeThemeSettigs() {
       // let currentTheme = cricTracTheme.currentTheme
       
        topBattingtableView.backgroundColor = UIColor.clearColor()
    }

    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if coverOrProfile == "Profile" {
            self.userProfileImage.image = image
            self.dismissViewControllerAnimated(true) {
                addProfileImageData(self.resizeImage(image, newWidth: 200))
            }
        }else {
            self.imgCoverPhoto.image = image
            self.dismissViewControllerAnimated(true) {
                addCoverImageData(self.resizeImage(image, newWidth: 800))
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
//    func viewImage(option:String){
//        let newImageView = UIImageView()
//        if option == "CoverPhoto" {
//            newImageView.image = imgCoverPhoto.image
//        }else {
//            newImageView.image = userProfileImage.image
//        }
//        newImageView.frame = self.view.frame
//        newImageView.backgroundColor = .blackColor()
//        newImageView.contentMode = .ScaleAspectFit
//        newImageView.userInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(CoachDashboardViewController.dismissFullscreenImage(_:)))
//        newImageView.addGestureRecognizer(tap)
//        //        self.view.addSubview(navBarView)
//        self.view.addSubview(newImageView)
//    }
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(CoachDashboardViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        //        self.view.addSubview(navBarView)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.titleLabel?.font = UIFont(name: appFont_black, size: 16)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        if let navigation = navigationController{
          //  navigation.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
          //  title = "SIGHTSCREEN"
            if let navigation = navigationController{
                topBarHeightConstraint.constant = 0
                
                navigation.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
                title = "SIGHTSCREEN"
            }
            else {
                topBarHeightConstraint.constant = 56
                self.topBarView.backgroundColor = currentTheme.topColor
            }
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //// navigationController!.navigationBar.titleTextAttributes = titleDict
        }
    }
    
    //Sravani mark: For coach Teams
    func updateCoachDashboard(){
                if (userProfileData.CoachCurrentTeams.count) + (userProfileData.CoachPastTeams.count) == 0 {
                    self.coachTeamsHeightConstraint.constant = 0
                }
                else {
                    self.coachTeamsHeightConstraint.constant = 130
                }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var valueToReturn = 0
        valueToReturn = (userProfileData.CoachCurrentTeams.count) + userProfileData.CoachPastTeams.count
        return valueToReturn
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var teamNameToReturn = ""
                    // teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
                    if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("CoachCurrentTeamsViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
                        //aCell.TeamImage.image = UIImage()
        
                        if indexPath.row < (userProfileData.CoachCurrentTeams.count) {
                            teamNameToReturn = userProfileData.CoachCurrentTeams[indexPath.row]
        
                            aCell.baseView.backgroundColor = cricTracTheme.currentTheme.bottomColor
                            aCell.baseView.alpha = 1
                            aCell.TeamAbbr.textColor = UIColor.whiteColor()
                        }
                        else if (indexPath.row - (userProfileData.CoachCurrentTeams.count)) < (userProfileData.CoachPastTeams.count) {
                            teamNameToReturn = userProfileData.CoachPastTeams[(indexPath.row - userProfileData.CoachCurrentTeams.count)]
                            aCell.baseView.backgroundColor = UIColor.grayColor()
                            aCell.TeamAbbr.textColor = UIColor.blackColor()
                        }
        
                        if teamNameToReturn != "" {
                            aCell.TeamName.text = teamNameToReturn
                            let teamName = teamNameToReturn.componentsSeparatedByString(" ")
                            if teamName.count == 1 {
                                aCell.TeamAbbr.text = "\(teamName[0].characters.first!)"
                            }
                            else if teamName.count == 2 {
                                aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)"
                            }
                            else {
                                aCell.TeamAbbr.text = "\(teamName[0].characters.first!)\(teamName[1].characters.first!)\(teamName[2].characters.first!)"
                            }
                        }
                        return aCell
                    }
                    return ThemeColorsCollectionViewCell()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        baseViewHeightConstraint.constant = 927
         baseViewHeightConstraint.constant += CGFloat(8 * 70)
        
    }
    
    // tableview functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == topBattingtableView {
            return 4
        }
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = UIView()
        aView.backgroundColor = UIColor.clearColor()
        return aView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.backgroundColor = UIColor.clearColor()
        //let currentTheme = cricTracTheme.currentTheme
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if tableView == topBattingtableView {
            
                let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
             battingTableViewHeightConstraint.constant = CGFloat(4 * 80)
            return cell
        }
       if tableView == topBowlingTableView {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CoachTopBattingBowlingTableViewCell
            cell.topBowlingPlayerName.text = topBattingnames[indexPath.section]
             cell.backgroundColor = cricTracTheme.currentTheme.bottomColor
        bowlingTableViewHeightConstraint.constant = CGFloat(4 * 80)
       
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            return cell
        }
        return cell!
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    // For Coach can see dis button
//    @IBAction func MyPlayersButtonTapped(sender: AnyObject) {
//        let dashBoard = viewControllerFrom("Main", vcid: "CoachPlayersListViewController") as! CoachPlayersListViewController
//        self.presentViewController(dashBoard, animated: false, completion: nil)
//
//    }
    
    @IBAction func pendingRequestsButtonTapped(sender: AnyObject) {
        let pendingRequests = viewControllerFrom("Main", vcid: "CoachPendingRequetsVC") as! CoachPendingRequetsVC
        self.presentViewController(pendingRequests, animated: false, completion: nil)
    }
    
    
}
