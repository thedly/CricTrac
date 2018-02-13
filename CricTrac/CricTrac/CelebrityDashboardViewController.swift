//
//  CelebrityDashboardViewController.swift
//  CricTrac
//
//  Created by Arjun Innovations on 01/02/18.
//  Copyright © 2018 CricTrac. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CelebrityDashboardViewController: UIViewController,ThemeChangeable {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileImage: UIImageView!

    @IBOutlet weak var battingStyle: UILabel!
    @IBOutlet weak var playingRole: UILabel!
    @IBOutlet weak var bowlingStyle: UILabel!
    @IBOutlet weak var majorTeams: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    //batting
    @IBOutlet weak var BatTestsMat: UILabel!
    @IBOutlet weak var BatTestsInns: UILabel!
    @IBOutlet weak var BatTestsNO: UILabel!
    @IBOutlet weak var BatTestsRuns: UILabel!
    @IBOutlet weak var BatTestsHS: UILabel!
    @IBOutlet weak var BatTestsAve: UILabel!
    @IBOutlet weak var BatTestsBF: UILabel!
    @IBOutlet weak var BatTestsSR: UILabel!
    @IBOutlet weak var BatTests100: UILabel!
    @IBOutlet weak var BatTests50: UILabel!
    @IBOutlet weak var BatTests4s: UILabel!
    @IBOutlet weak var BatTests6s: UILabel!
    @IBOutlet weak var BatTestsCt: UILabel!
    @IBOutlet weak var BatTestsSt: UILabel!
    
    @IBOutlet weak var BatODIsMat: UILabel!
    @IBOutlet weak var BatODIsInns: UILabel!
    @IBOutlet weak var BatODIsNO: UILabel!
    @IBOutlet weak var BatODIsRuns: UILabel!
    @IBOutlet weak var BatODIsHS: UILabel!
    @IBOutlet weak var BatODIsAve: UILabel!
    @IBOutlet weak var BatODIsBF: UILabel!
    @IBOutlet weak var BatODIsSR: UILabel!
    @IBOutlet weak var BatODIs100: UILabel!
    @IBOutlet weak var BatODIs50: UILabel!
    @IBOutlet weak var BatODIs4s: UILabel!
    @IBOutlet weak var BatODIs6s: UILabel!
    @IBOutlet weak var BatODIsCt: UILabel!
    @IBOutlet weak var BatODIsSt: UILabel!
    
    @IBOutlet weak var BatT20IsMat: UILabel!
    @IBOutlet weak var BatT20IsInns: UILabel!
    @IBOutlet weak var BatT20IsNO: UILabel!
    @IBOutlet weak var BatT20IsRuns: UILabel!
    @IBOutlet weak var BatT20IsHS: UILabel!
    @IBOutlet weak var BatT20IsAve: UILabel!
    @IBOutlet weak var BatT20IsBF: UILabel!
    @IBOutlet weak var BatT20IsSR: UILabel!
    @IBOutlet weak var BatT20Is100: UILabel!
    @IBOutlet weak var BatT20Is50: UILabel!
    @IBOutlet weak var BatT20Is4s: UILabel!
    @IBOutlet weak var BatT20Is6s: UILabel!
    @IBOutlet weak var BatT20IsCt: UILabel!
    @IBOutlet weak var BatT20IsSt: UILabel!
    
    @IBOutlet weak var BatFirstclassMat: UILabel!
    @IBOutlet weak var BatFirstclassInns: UILabel!
    @IBOutlet weak var BatFirstclassNO: UILabel!
    @IBOutlet weak var BatFirstclassRuns: UILabel!
    @IBOutlet weak var BatFirstclassHS: UILabel!
    @IBOutlet weak var BatFirstclassAve: UILabel!
    @IBOutlet weak var BatFirstclassBF: UILabel!
    @IBOutlet weak var BatFirstclassSR: UILabel!
    @IBOutlet weak var BatFirstclass100: UILabel!
    @IBOutlet weak var BatFirstclass50: UILabel!
    @IBOutlet weak var BatFirstclass4s: UILabel!
    @IBOutlet weak var BatFirstclass6s: UILabel!
    @IBOutlet weak var BatFirstclassCt: UILabel!
    @IBOutlet weak var BatFirstclassSt: UILabel!
    
    @IBOutlet weak var BatListAMat: UILabel!
    @IBOutlet weak var BatListAInns: UILabel!
    @IBOutlet weak var BatListANO: UILabel!
    @IBOutlet weak var BatListARuns: UILabel!
    @IBOutlet weak var BatListAHS: UILabel!
    @IBOutlet weak var BatListAAve: UILabel!
    @IBOutlet weak var BatListABF: UILabel!
    @IBOutlet weak var BatListASR: UILabel!
    @IBOutlet weak var BatListA100: UILabel!
    @IBOutlet weak var BatListA50: UILabel!
    @IBOutlet weak var BatListA4s: UILabel!
    @IBOutlet weak var BatListA6s: UILabel!
    @IBOutlet weak var BatListACt: UILabel!
    @IBOutlet weak var BatListASt: UILabel!
    
    @IBOutlet weak var BatT20sMat: UILabel!
    @IBOutlet weak var BatT20sInns: UILabel!
    @IBOutlet weak var BatT20sNO: UILabel!
    @IBOutlet weak var BatT20sRuns: UILabel!
    @IBOutlet weak var BatT20sHS: UILabel!
    @IBOutlet weak var BatT20sAve: UILabel!
    @IBOutlet weak var BatT20sBF: UILabel!
    @IBOutlet weak var BatT20sSR: UILabel!
    @IBOutlet weak var BatT20s100: UILabel!
    @IBOutlet weak var BatT20s50: UILabel!
    @IBOutlet weak var BatT20s4s: UILabel!
    @IBOutlet weak var BatT20s6s: UILabel!
    @IBOutlet weak var BatT20sCt: UILabel!
    @IBOutlet weak var BatT20sSt: UILabel!
    @IBOutlet weak var battingAvgTextLabel: UILabel!
    @IBOutlet weak var battingView: UIView!
    
    //bowling
    @IBOutlet weak var BowlTestsMat: UILabel!
    @IBOutlet weak var BowlTestsInns: UILabel!
    @IBOutlet weak var BowlTestsBalls: UILabel!
    @IBOutlet weak var BowlTestsRuns: UILabel!
    @IBOutlet weak var BowlTestsWkts: UILabel!
    @IBOutlet weak var BowlTestsAve: UILabel!
    @IBOutlet weak var BowlTestsBBI: UILabel!
    @IBOutlet weak var BowlTestsSR: UILabel!
    @IBOutlet weak var BowlTestsBBM: UILabel!
    @IBOutlet weak var BowlTestsEcon: UILabel!
    @IBOutlet weak var BowlTests4w: UILabel!
    @IBOutlet weak var BowlTests5w: UILabel!
    @IBOutlet weak var BowlTests10w: UILabel!
    
    @IBOutlet weak var BowlODIsMat: UILabel!
    @IBOutlet weak var BowlODIsInns: UILabel!
    @IBOutlet weak var BowlODIsBalls: UILabel!
    @IBOutlet weak var BowlODIsRuns: UILabel!
    @IBOutlet weak var BowlODIsWkts: UILabel!
    @IBOutlet weak var BowlODIsAve: UILabel!
    @IBOutlet weak var BowlODIsBBI: UILabel!
    @IBOutlet weak var BowlODIsSR: UILabel!
    @IBOutlet weak var BowlODIsBBM: UILabel!
    @IBOutlet weak var BowlODIsEcon: UILabel!
    @IBOutlet weak var BowlODIs4w: UILabel!
    @IBOutlet weak var BowlODIs5w: UILabel!
    @IBOutlet weak var BowlODIs10w: UILabel!

    @IBOutlet weak var BowlT20IsMat: UILabel!
    @IBOutlet weak var BowlT20IsInns: UILabel!
    @IBOutlet weak var BowlT20IsBalls: UILabel!
    @IBOutlet weak var BowlT20IsRuns: UILabel!
    @IBOutlet weak var BowlT20IsWkts: UILabel!
    @IBOutlet weak var BowlT20IsAve: UILabel!
    @IBOutlet weak var BowlT20IsBBI: UILabel!
    @IBOutlet weak var BowlT20IsSR: UILabel!
    @IBOutlet weak var BowlT20IsBBM: UILabel!
    @IBOutlet weak var BowlT20IsEcon: UILabel!
    @IBOutlet weak var BowlT20Is4w: UILabel!
    @IBOutlet weak var BowlT20Is5w: UILabel!
    @IBOutlet weak var BowlT20Is10w: UILabel!
    
    @IBOutlet weak var BowlFirstclassMat: UILabel!
    @IBOutlet weak var BowlFirstclassInns: UILabel!
    @IBOutlet weak var BowlFirstclassBalls: UILabel!
    @IBOutlet weak var BowlFirstclassRuns: UILabel!
    @IBOutlet weak var BowlFirstclassWkts: UILabel!
    @IBOutlet weak var BowlFirstclassAve: UILabel!
    @IBOutlet weak var BowlFirstclassBBI: UILabel!
    @IBOutlet weak var BowlFirstclassSR: UILabel!
    @IBOutlet weak var BowlFirstclassBBM: UILabel!
    @IBOutlet weak var BowlFirstclassEcon: UILabel!
    @IBOutlet weak var BowlFirstclass4w: UILabel!
    @IBOutlet weak var BowlFirstclass5w: UILabel!
    @IBOutlet weak var BowlFirstclass10w: UILabel!
    
    @IBOutlet weak var BowlListAMat: UILabel!
    @IBOutlet weak var BowlListAInns: UILabel!
    @IBOutlet weak var BowlListABalls: UILabel!
    @IBOutlet weak var BowlListARuns: UILabel!
    @IBOutlet weak var BowlListAWkts: UILabel!
    @IBOutlet weak var BowlListAAve: UILabel!
    @IBOutlet weak var BowlListABBI: UILabel!
    @IBOutlet weak var BowlListASR: UILabel!
    @IBOutlet weak var BowlListABBM: UILabel!
    @IBOutlet weak var BowlListAEcon: UILabel!
    @IBOutlet weak var BowlListA4w: UILabel!
    @IBOutlet weak var BowlListA5w: UILabel!
    @IBOutlet weak var BowlListA10w: UILabel!
    
    @IBOutlet weak var BowlT20sMat: UILabel!
    @IBOutlet weak var BowlT20sInns: UILabel!
    @IBOutlet weak var BowlT20sBalls: UILabel!
    @IBOutlet weak var BowlT20sRuns: UILabel!
    @IBOutlet weak var BowlT20sWkts: UILabel!
    @IBOutlet weak var BowlT20sAve: UILabel!
    @IBOutlet weak var BowlT20sBBI: UILabel!
    @IBOutlet weak var BowlT20sSR: UILabel!
    @IBOutlet weak var BowlT20sBBM: UILabel!
    @IBOutlet weak var BowlT20sEcon: UILabel!
    @IBOutlet weak var BowlT20s4w: UILabel!
    @IBOutlet weak var BowlT20s5w: UILabel!
    @IBOutlet weak var BowlT20s10w: UILabel!
    @IBOutlet weak var bowlingView: UIView!

    //career
    @IBOutlet weak var TestDebut: UILabel!
    @IBOutlet weak var LastTest: UILabel!
    @IBOutlet weak var ODIDebut: UILabel!
    @IBOutlet weak var LastODI: UILabel!
    @IBOutlet weak var T20IDebut: UILabel!
    @IBOutlet weak var LastT20I: UILabel!
    @IBOutlet weak var FirstclassDebut: UILabel!
    @IBOutlet weak var LastFirstclass: UILabel!
    @IBOutlet weak var ListADebut: UILabel!
    @IBOutlet weak var LastListA: UILabel!
    @IBOutlet weak var T20sDebut: UILabel!
    @IBOutlet weak var LastT20s: UILabel!
    
    @IBOutlet weak var careerTestView: UIView!
    @IBOutlet weak var careerODIView: UIView!
    @IBOutlet weak var careerT20IView: UIView!
    @IBOutlet weak var careerFirstclassView: UIView!
    @IBOutlet weak var careerListA: UIView!
    @IBOutlet weak var careerT20sView: UIView!
    
    @IBOutlet weak var BatTestsView: UIView!
    @IBOutlet weak var BatODIsView: UIView!
    @IBOutlet weak var BatT20IsView: UIView!
    @IBOutlet weak var BatFirstclassView: UIView!
    @IBOutlet weak var BatListAView: UIView!
    @IBOutlet weak var BatT20sView: UIView!
    
    @IBOutlet weak var BowlTestsView: UIView!
    @IBOutlet weak var BowlODIsView: UIView!
    @IBOutlet weak var BowlT20IsView: UIView!
    @IBOutlet weak var BowlFirstclassView: UIView!
    @IBOutlet weak var BowlListAView: UIView!
    @IBOutlet weak var BowlT20sView: UIView!
    @IBOutlet weak var careerView: UIView!
    
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var careerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var BatViewWidth: NSLayoutConstraint!
    @IBOutlet weak var BowlViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var coverPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    
    var friendId:String? = nil
    var currentUserId = ""
    var isFriendDashboard = false
    
    var friendProfile:[String:AnyObject]?
    var userProfileData:Profile!
    
    @IBAction func imageViewBtn(sender: UIButton) {
        let profileImageVc = viewControllerFrom("Main", vcid: "ProfileImageExpandingVC") as! ProfileImageExpandingVC
        profileImageVc.imageString = userProfileData.ProfileImageURL
        if userProfileData.ProfileImageURL != "-" {
            self.presentViewController(profileImageVc, animated: true) {}
        }
    }
    
    @IBAction func closeBtn(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var celebrityData:Celebrity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        self.battingView.layer.cornerRadius = 10
        self.bowlingView.layer.cornerRadius = 10
        self.careerT20sView.layer.cornerRadius = 10
         self.careerFirstclassView.layer.cornerRadius = 10
         self.careerT20IView.layer.cornerRadius = 10
         self.careerODIView.layer.cornerRadius = 10
         self.careerListA.layer.cornerRadius = 10
         self.careerTestView.layer.cornerRadius = 10
                
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    func initView()  {
        if let value = friendProfile{
            userProfileData = Profile(usrObj: value)
            // closeButton.hidden = false
        }
        else{
            userProfileData = profileData
            // closeButton.hidden = true
        }
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        userProfileImage.clipsToBounds = true
        
        
        let currentCountryList = CountriesList.filter({$0.name == userProfileData.Country})
        let currentISO = currentCountryList[0].iso
        
        //calculating age
        let  dob = userProfileData.DateOfBirth
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        let birthdayDate = dateFormater.dateFromString(dob)
        
        let date = NSDate()
        
        let calender:NSCalendar  = NSCalendar.currentCalendar()
        
        let currentMonth = calender.component(.Month, fromDate: date)
        let birthmonth = calender.component(.Month, fromDate: birthdayDate!)
        
        var years = calender.component(.Year, fromDate: date) - calender.component(.Year, fromDate: birthdayDate!)
        
        var months = currentMonth - birthmonth
        
        if months < 0 {
            years = years - 1
            months = 12 - birthmonth + currentMonth
            if calender.component(.Day, fromDate: date) < calender.component(.Day, fromDate: birthdayDate!){
                months = months - 1
            }
        }
        else if months == 0 && calender.component(.Day, fromDate: date) < calender.component(.Day, fromDate: birthdayDate!)
        {
            years = years - 1
            months = 11
        }
        let ageString = "\(years) yrs \(months) months"
        
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.name.text = userProfileData.fullName
        let formattedString = NSMutableAttributedString()
        let locationText = formattedString.bold("\(userProfileData.City)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.State), ", fontName: appFont_black, fontSize: 15).bold("\(currentISO)\n", fontName: appFont_black, fontSize: 15).bold("\(userProfileData.DateOfBirth)\n", fontName: appFont_black, fontSize: 15).bold("Age: \(ageString)\n", fontName: appFont_black, fontSize: 15)
        self.city.attributedText = locationText
        
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
                self.profilePic.image = image
            }
            else{
                if let imageURL = NSURL(string:proPic!){
                    self.profilePic.kf_setImageWithURL(imageURL)
                }
            }
        })
        
        fetchCoverPhoto(currentUserId, sucess: { (result) in
            let coverPic = result["coverPic"]
            
            if coverPic! == "-"{
                let imageName = defaultCoverImage
                let image = UIImage(named: imageName)
                self.coverPic.image = image
            }
            else{
                if let imageURL = NSURL(string:coverPic!){
                    self.coverPic.kf_setImageWithURL(imageURL)
                }
            }
        })

        
        careerViewHeight.constant = 10
        BatViewWidth.constant = 80
        BowlViewWidth.constant = 80
        
        setDashboardData()
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
    
    func setDashboardData() {
        fireBaseRef.child("Celebrity").child(friendId!).child("Profile").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                //profile data
                let playingRole = data["PlayingRole"] as? String
                let bowlStyle = data["BowlingStyle"] as? String
                //self.playingRole.text = data["PlayingRole"] as? String
                self.battingStyle.text = ""
                self.majorTeams.text = data["MajorTeams"] as? String
                
                let profileDescription = data["Description"] as? String
                let lengthProfile = profileDescription?.characters.count
                var noOfLines = lengthProfile!/50
                
                if screensize == "1" { //iPhone 4
                    noOfLines = lengthProfile!/40
                }
                else if screensize == "2" { //iPhone 5
                    noOfLines = lengthProfile!/40
                }
                else if screensize == "3" {  //iPhone 6
                    noOfLines = lengthProfile!/50
                }
                else {  //iPhone Plus
                    noOfLines = lengthProfile!/60
                }
                
                self.profileViewHeightConstraint.constant += CGFloat(noOfLines) * 18
                self.baseViewHeightConstraint.constant += CGFloat(noOfLines) * 18
                self.profile.numberOfLines = noOfLines + 1
                
                self.profile.text = data["Description"] as? String
                
                let formattedStrBat = NSMutableAttributedString()
                let formattedStrBowl = NSMutableAttributedString()
                
                let batImageAttachment = NSTextAttachment()
                batImageAttachment.image = UIImage(named: "BatIcon")
                batImageAttachment.bounds = CGRect(x: 0, y: -2, width: 15, height: 15)
                let imageAttachmentString = NSAttributedString(attachment: batImageAttachment)
                formattedStrBat.appendAttributedString(imageAttachmentString)
                formattedStrBat.bold("\(playingRole!)   ", fontName: appFont_bold, fontSize: 15)
                
                let ballImageAttachment = NSTextAttachment()
                ballImageAttachment.image = UIImage(named: "BallIcon")
                ballImageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                let ballImageAttachmentString = NSAttributedString(attachment: ballImageAttachment)
                formattedStrBowl.appendAttributedString(ballImageAttachmentString)
                formattedStrBowl.bold("\(bowlStyle!)", fontName: appFont_bold, fontSize: 15)
                
                self.playingRole.attributedText = formattedStrBat
                self.bowlingStyle.attributedText = formattedStrBowl
                
                //career data
                if data["TestDebut"] as? String != "" {
                    self.TestDebut.text = data["TestDebut"] as? String
                    self.LastTest.text = data["LastTest"] as? String
                    self.careerTestView.hidden = false
                }
                else {
                    self.careerTestView.hidden = true
                    self.careerViewHeight.constant -= 55
                    self.baseViewHeightConstraint.constant -= 55
                }
                
                if data["ODIDebut"] as? String != "" {
                    self.ODIDebut.text = data["ODIDebut"] as? String
                    self.LastODI.text = data["LastODI"] as? String
                    self.careerODIView.hidden = false
                }
                else {
                    self.careerODIView.hidden = true
                    self.careerViewHeight.constant -= 55
                    self.baseViewHeightConstraint.constant -= 55
                }
                
                if data["T20IDebut"] as? String != "" {
                    self.T20IDebut.text = data["T20IDebut"] as? String
                    self.LastT20I.text = data["LastT20I"] as? String
                    self.careerT20IView.hidden = false
                }
                else {
                    self.careerT20IView.hidden = true
                    self.careerViewHeight.constant -= 55
                    self.baseViewHeightConstraint.constant -= 55
                }
                
                if data["FirstclassDebut"] as? String != "" {
                    self.FirstclassDebut.text = data["FirstclassDebut"] as? String
                    self.LastFirstclass.text = data["LastFirstclass"] as? String
                    self.careerFirstclassView.hidden = false
                }
                else {
                    self.careerFirstclassView.hidden = true
                    self.careerViewHeight.constant -= 55
                    self.baseViewHeightConstraint.constant -= 55
                }
                
                if data["ListADebut"] as? String != "" {
                    self.ListADebut.text = data["ListADebut"] as? String
                    self.LastListA.text = data["LastListA"] as? String
                    self.careerListA.hidden = false
                }
                else {
                    self.careerListA.hidden = true
                    self.careerViewHeight.constant -= 55
                    self.baseViewHeightConstraint.constant -= 55
                }
                
                if data["T20sDebut"] as? String != "" {
                    self.T20sDebut.text = data["T20sDebut"] as? String
                    self.LastT20s.text = data["LastT20s"] as? String
                    self.careerT20sView.hidden = false
                }
                else {
                    self.careerT20sView.hidden = true
                    self.careerViewHeight.constant -= 55
                    self.baseViewHeightConstraint.constant -= 55
                }
            }
        })
        
        //Batting data
        //Firstclass
        fireBaseRef.child("Celebrity").child(friendId!).child("Batting").child("Firstclass").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BatFirstclass50.text = data["50"] as? String
                    self.BatFirstclass100.text = data["100"] as? String
                    self.BatFirstclass4s.text = data["4s"] as? String
                    self.BatFirstclass6s.text = data["6s"] as? String
                    self.BatFirstclassAve.text = data["Ave"] as? String
                    self.BatFirstclassBF.text = data["BF"] as? String
                    self.BatFirstclassCt.text = data["Ct"] as? String
                    self.BatFirstclassHS.text = data["HS"] as? String
                    self.BatFirstclassInns.text = data["Inns"] as? String
                    self.BatFirstclassMat.text = data["Mat"] as? String
                    self.BatFirstclassNO.text = data["NO"] as? String
                    self.BatFirstclassRuns.text = data["Runs"] as? String
                    self.BatFirstclassSR.text = data["SR"] as? String
                    self.BatFirstclassSt.text = data["St"] as? String
                    
                    self.BatFirstclassView.hidden = false
                    self.BatViewWidth.constant += 80
                }
                else {
                    self.BatFirstclassView.hidden = true
                }
                
            }
        })
        
        //ListA
        fireBaseRef.child("Celebrity").child(friendId!).child("Batting").child("ListA").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BatListA50.text = data["50"] as? String
                    self.BatListA100.text = data["100"] as? String
                    self.BatListA4s.text = data["4s"] as? String
                    self.BatListA6s.text = data["6s"] as? String
                    self.BatListAAve.text = data["Ave"] as? String
                    self.BatListABF.text = data["BF"] as? String
                    self.BatListACt.text = data["Ct"] as? String
                    self.BatListAHS.text = data["HS"] as? String
                    self.BatListAInns.text = data["Inns"] as? String
                    self.BatListAMat.text = data["Mat"] as? String
                    self.BatListANO.text = data["NO"] as? String
                    self.BatListARuns.text = data["Runs"] as? String
                    self.BatListASR.text = data["SR"] as? String
                    self.BatListASt.text = data["St"] as? String
                    
                    self.BatListAView.hidden = false
                    self.BatViewWidth.constant += 80
                }
                else {
                    self.BatListAView.hidden = true
                }
            }
        })
        
        //ODIs
        fireBaseRef.child("Celebrity").child(friendId!).child("Batting").child("ODIs").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BatODIs50.text = data["50"] as? String
                    self.BatODIs100.text = data["100"] as? String
                    self.BatODIs4s.text = data["4s"] as? String
                    self.BatODIs6s.text = data["6s"] as? String
                    self.BatODIsAve.text = data["Ave"] as? String
                    self.BatODIsBF.text = data["BF"] as? String
                    self.BatODIsCt.text = data["Ct"] as? String
                    self.BatODIsHS.text = data["HS"] as? String
                    self.BatODIsInns.text = data["Inns"] as? String
                    self.BatODIsMat.text = data["Mat"] as? String
                    self.BatODIsNO.text = data["NO"] as? String
                    self.BatODIsRuns.text = data["Runs"] as? String
                    self.BatODIsSR.text = data["SR"] as? String
                    self.BatODIsSt.text = data["St"] as? String
                    
                    self.BatODIsView.hidden = false
                    self.BatViewWidth.constant += 80
                }
                else {
                    self.BatODIsView.hidden = true
                }
            }
        })
        
        //T20Is
        fireBaseRef.child("Celebrity").child(friendId!).child("Batting").child("T20Is").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BatT20Is50.text = data["50"] as? String
                    self.BatT20Is100.text = data["100"] as? String
                    self.BatT20Is4s.text = data["4s"] as? String
                    self.BatT20Is6s.text = data["6s"] as? String
                    self.BatT20IsAve.text = data["Ave"] as? String
                    self.BatT20IsBF.text = data["BF"] as? String
                    self.BatT20IsCt.text = data["Ct"] as? String
                    self.BatT20IsHS.text = data["HS"] as? String
                    self.BatT20IsInns.text = data["Inns"] as? String
                    self.BatT20IsMat.text = data["Mat"] as? String
                    self.BatT20IsNO.text = data["NO"] as? String
                    self.BatT20IsRuns.text = data["Runs"] as? String
                    self.BatT20IsSR.text = data["SR"] as? String
                    self.BatT20IsSt.text = data["St"] as? String
                    
                    self.BatT20IsView.hidden = false
                    self.BatViewWidth.constant += 80
                }
                else {
                    self.BatT20IsView.hidden = true
                }
            }
        })
        
        //T20s
        fireBaseRef.child("Celebrity").child(friendId!).child("Batting").child("T20s").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BatT20s50.text = data["50"] as? String
                    self.BatT20s100.text = data["100"] as? String
                    self.BatT20s4s.text = data["4s"] as? String
                    self.BatT20s6s.text = data["6s"] as? String
                    self.BatT20sAve.text = data["Ave"] as? String
                    self.BatT20sBF.text = data["BF"] as? String
                    self.BatT20sCt.text = data["Ct"] as? String
                    self.BatT20sHS.text = data["HS"] as? String
                    self.BatT20sInns.text = data["Inns"] as? String
                    self.BatT20sMat.text = data["Mat"] as? String
                    self.BatT20sNO.text = data["NO"] as? String
                    self.BatT20sRuns.text = data["Runs"] as? String
                    self.BatT20sSR.text = data["SR"] as? String
                    self.BatT20sSt.text = data["St"] as? String
                    
                    self.BatT20sView.hidden = false
                    self.BatViewWidth.constant += 80
                }
                else {
                    self.BatT20sView.hidden = true
                }
            }
        })
        
        //Tests
        fireBaseRef.child("Celebrity").child(friendId!).child("Batting").child("Tests").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BatTests50.text = data["50"] as? String
                    self.BatTests100.text = data["100"] as? String
                    self.BatTests4s.text = data["4s"] as? String
                    self.BatTests6s.text = data["6s"] as? String
                    self.BatTestsAve.text = data["Ave"] as? String
                    self.BatTestsBF.text = data["BF"] as? String
                    self.BatTestsCt.text = data["Ct"] as? String
                    self.BatTestsHS.text = data["HS"] as? String
                    self.BatTestsInns.text = data["Inns"] as? String
                    self.BatTestsMat.text = data["Mat"] as? String
                    self.BatTestsNO.text = data["NO"] as? String
                    self.BatTestsRuns.text = data["Runs"] as? String
                    self.BatTestsSR.text = data["SR"] as? String
                    self.BatTestsSt.text = data["St"] as? String
                    
                    self.BatTestsView.hidden = false
                    self.BatViewWidth.constant += 80
                }
                else {
                    self.BatTestsView.hidden = true
                }
            }
        })
        
        //Bowling data
        //Firstclass
        fireBaseRef.child("Celebrity").child(friendId!).child("Bowling").child("Firstclass").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BowlFirstclass10w.text = data["10w"] as? String
                    self.BowlFirstclass5w.text = data["5w"] as? String
                    self.BowlFirstclass4w.text = data["4w"] as? String
                    self.BowlFirstclassAve.text = data["Ave"] as? String
                    self.BowlFirstclassBBI.text = data["BBI"] as? String
                    self.BowlFirstclassBBM.text = data["BBM"] as? String
                    self.BowlFirstclassBalls.text = data["Balls"] as? String
                    self.BowlFirstclassEcon.text = data["Econ"] as? String
                    self.BowlFirstclassInns.text = data["Inns"] as? String
                    self.BowlFirstclassMat.text = data["Mat"] as? String
                    self.BowlFirstclassRuns.text = data["Runs"] as? String
                    self.BowlFirstclassSR.text = data["SR"] as? String
                    self.BowlFirstclassWkts.text = data["Wkts"] as? String
                    
                    self.BowlFirstclassView.hidden = false
                    self.BowlViewWidth.constant += 80
                }
                else {
                    self.BowlFirstclassView.hidden = true
                }
            }
        })
        
        //ListA
        fireBaseRef.child("Celebrity").child(friendId!).child("Bowling").child("ListA").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BowlListA10w.text = data["10w"] as? String
                    self.BowlListA5w.text = data["5w"] as? String
                    self.BowlListA4w.text = data["4w"] as? String
                    self.BowlListAAve.text = data["Ave"] as? String
                    self.BowlListABBI.text = data["BBI"] as? String
                    self.BowlListABBM.text = data["BBM"] as? String
                    self.BowlListABalls.text = data["Balls"] as? String
                    self.BowlListAEcon.text = data["Econ"] as? String
                    self.BowlListAInns.text = data["Inns"] as? String
                    self.BowlListAMat.text = data["Mat"] as? String
                    self.BowlListARuns.text = data["Runs"] as? String
                    self.BowlListASR.text = data["SR"] as? String
                    self.BowlListAWkts.text = data["Wkts"] as? String
                    
                    self.BowlListAView.hidden = false
                    self.BowlViewWidth.constant += 80
                }
                else {
                    self.BowlListAView.hidden = true
                }
            }
        })
        
        //ODIs
        fireBaseRef.child("Celebrity").child(friendId!).child("Bowling").child("ODIs").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BowlODIs10w.text = data["10w"] as? String
                    self.BowlODIs5w.text = data["5w"] as? String
                    self.BowlODIs4w.text = data["4w"] as? String
                    self.BowlODIsAve.text = data["Ave"] as? String
                    self.BowlODIsBBI.text = data["BBI"] as? String
                    self.BowlODIsBBM.text = data["BBM"] as? String
                    self.BowlODIsBalls.text = data["Balls"] as? String
                    self.BowlODIsEcon.text = data["Econ"] as? String
                    self.BowlODIsInns.text = data["Inns"] as? String
                    self.BowlODIsMat.text = data["Mat"] as? String
                    self.BowlODIsRuns.text = data["Runs"] as? String
                    self.BowlODIsSR.text = data["SR"] as? String
                    self.BowlODIsWkts.text = data["Wkts"] as? String
                    
                    self.BowlODIsView.hidden = false
                    self.BowlViewWidth.constant += 80
                }
                else {
                    self.BowlODIsView.hidden = true
                }
            }
        })
        
        //T20Is
        fireBaseRef.child("Celebrity").child(friendId!).child("Bowling").child("T20Is").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BowlT20Is10w.text = data["10w"] as? String
                    self.BowlT20Is5w.text = data["5w"] as? String
                    self.BowlT20Is4w.text = data["4w"] as? String
                    self.BowlT20IsAve.text = data["Ave"] as? String
                    self.BowlT20IsBBI.text = data["BBI"] as? String
                    self.BowlT20IsBBM.text = data["BBM"] as? String
                    self.BowlT20IsBalls.text = data["Balls"] as? String
                    self.BowlT20IsEcon.text = data["Econ"] as? String
                    self.BowlT20IsInns.text = data["Inns"] as? String
                    self.BowlT20IsMat.text = data["Mat"] as? String
                    self.BowlT20IsRuns.text = data["Runs"] as? String
                    self.BowlT20IsSR.text = data["SR"] as? String
                    self.BowlT20IsWkts.text = data["Wkts"] as? String
                    
                    self.BowlT20IsView.hidden = false
                    self.BowlViewWidth.constant += 80
                }
                else {
                    self.BowlT20IsView.hidden = true
                }
            }
        })
        
        //T20s
        fireBaseRef.child("Celebrity").child(friendId!).child("Bowling").child("T20s").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BowlT20s10w.text = data["10w"] as? String
                    self.BowlT20s5w.text = data["5w"] as? String
                    self.BowlT20s4w.text = data["4w"] as? String
                    self.BowlT20sAve.text = data["Ave"] as? String
                    self.BowlT20sBBI.text = data["BBI"] as? String
                    self.BowlT20sBBM.text = data["BBM"] as? String
                    self.BowlT20sBalls.text = data["Balls"] as? String
                    self.BowlT20sEcon.text = data["Econ"] as? String
                    self.BowlT20sInns.text = data["Inns"] as? String
                    self.BowlT20sMat.text = data["Mat"] as? String
                    self.BowlT20sRuns.text = data["Runs"] as? String
                    self.BowlT20sSR.text = data["SR"] as? String
                    self.BowlT20sWkts.text = data["Wkts"] as? String
                    
                    self.BowlT20sView.hidden = false
                    self.BowlViewWidth.constant += 80
                }
                else {
                    self.BowlT20sView.hidden = true
                }
            }
        })
        
        //Tests
        fireBaseRef.child("Celebrity").child(friendId!).child("Bowling").child("Tests").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value! as? [String:AnyObject]{
                if data["Mat"] as? String != "" {
                    self.BowlTests10w.text = data["10w"] as? String
                    self.BowlTests5w.text = data["5w"] as? String
                    self.BowlTests4w.text = data["4w"] as? String
                    self.BowlTestsAve.text = data["Ave"] as? String
                    self.BowlTestsBBI.text = data["BBI"] as? String
                    self.BowlTestsBBM.text = data["BBM"] as? String
                    self.BowlTestsBalls.text = data["Balls"] as? String
                    self.BowlTestsEcon.text = data["Econ"] as? String
                    self.BowlTestsInns.text = data["Inns"] as? String
                    self.BowlTestsMat.text = data["Mat"] as? String
                    self.BowlTestsRuns.text = data["Runs"] as? String
                    self.BowlTestsSR.text = data["SR"] as? String
                    self.BowlTestsWkts.text = data["Wkts"] as? String
                    
                    self.BowlTestsView.hidden = false
                    self.BowlViewWidth.constant += 80
                }
                else {
                    self.BowlTestsView.hidden = true
                }
            }
        })
    }

    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        topBarView.backgroundColor = currentTheme.topColor
        currentTheme.boxColor
        self.view.backgroundColor = currentTheme.topColor
        self.battingView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(battingView, color: currentTheme.bottomColor.CGColor)
        
        self.bowlingView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(bowlingView, color: currentTheme.bottomColor.CGColor)
        
        self.careerTestView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(careerTestView, color: currentTheme.bottomColor.CGColor)
        
        self.careerListA.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(careerListA, color: currentTheme.bottomColor.CGColor)
        
        self.careerODIView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(careerODIView, color: currentTheme.bottomColor.CGColor)
        
        self.careerT20IView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(careerT20IView, color: currentTheme.bottomColor.CGColor)
        
        self.careerT20sView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(careerT20sView, color: currentTheme.bottomColor.CGColor)
        
        self.careerFirstclassView.backgroundColor =  currentTheme.bottomColor
        setPlainShadow(careerFirstclassView, color: currentTheme.bottomColor.CGColor)
        
    }
    
    
    
    

}
