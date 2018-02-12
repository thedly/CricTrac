//
//  MatchResultsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MatchResultsViewController: UIViewController, IndicatorInfoProvider,ThemeChangeable, AchievementsTextProtocol,UITextViewDelegate {

    @IBOutlet weak var firstTeamTitle: UILabel!
    @IBOutlet weak var secondTeamTitle: UILabel!
    @IBOutlet weak var firstTeamTossBtn: UIButton!
    @IBOutlet weak var secondTeamTossBtn: UIButton!
    @IBOutlet weak var AchievementsText: UITextField!
    @IBOutlet weak var FirstBattingView: UIView!
    @IBOutlet weak var SecondBattingView: UIView!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var screenShotHeight: NSLayoutConstraint!
    
    //player and coach analysis
    @IBOutlet weak var selfAnalysisView: UIView!
    @IBOutlet weak var selfAnalysisViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfAnalysisTextView: UITextView!
    @IBOutlet weak var selfAnalysisHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisTextView: UITextView!
    @IBOutlet weak var coachAnalysisTextViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisView: UIView!
    var achievementsTextValue :String?
    
    //second innings
    @IBOutlet weak var secondInningsView1: UIView!
    @IBOutlet weak var secondInningsViewHeightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var secondInningsView2: UIView!
    @IBOutlet weak var secondInningsViewHeightConstarint2: NSLayoutConstraint!
    @IBOutlet weak var secondBattingHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var firstBattingHeightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var firstBattingDeclaredBtn1: UIButton!
    @IBOutlet weak var firstBattingDeclaredLabel1: UILabel!
    @IBOutlet weak var firstBattingDeclaredBtn2: UIButton!
    @IBOutlet weak var firstBattingDeclaredLabel2: UILabel!
    @IBOutlet weak var secondBattingDeclaredBtn1: UIButton!
    @IBOutlet weak var secondBattingDeclaredBtn2: UIButton!
    
    lazy var ctDataPicker = DataPicker()
    
    var firstBatText: String!
    var secondBatText: String!
    var swapBtnVal: Int!
    //var resultsTab = 1
    var existFB = ""
    var existSB = ""
    var achievementText = [String]()
    let placeHolderTextForSelfAnalysis = "Enter learnings and improvements from the match."
    let placeHolderTextForCoachAnalysis = "Enter reviews and feedback for the player."
    
    private var inEditMode: Bool = false
    
    let fullRotation = CGFloat(M_PI * 2)
    
    @IBOutlet weak var refreshBtn: UIButton!

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        firstScoreText.resignFirstResponder()
        secondScoreText.resignFirstResponder()
        
        firstOversText.resignFirstResponder()
        secondOversText.resignFirstResponder()
        setNavigationProperties()
        //layoutSubViewForAnalysis()
        
        //second innings
        let matchVCInstance = parent?.matchVC
        let matchFormat = matchVCInstance?.matchFormat.text
        
        if matchFormat! == "Single Innings" || matchFormat! == "" {
            secondInningsViewHeightConstraint1.constant = 0
            secondInningsViewHeightConstarint2.constant = 0
            secondInningsView1.hidden = true
            secondInningsView2.hidden = true
            firstBattingHeightConstraint1.constant = 295
            secondBattingHeightConstarint.constant = 295
            screenShotHeight.constant = 662
        }
        else {
            secondInningsViewHeightConstraint1.constant = 125
            secondInningsViewHeightConstarint2.constant = 125
            secondInningsView1.hidden = false
            secondInningsView2.hidden = false
            firstBattingHeightConstraint1.constant = 420
            secondBattingHeightConstarint.constant = 420
            screenShotHeight.constant = 787
        }
    }
   
    func setNavigationProperties() {
        if profileData.UserProfile == "Coach" {
            selfAnalysisView.hidden = true
            selfAnalysisViewHeightConstraint.constant = 0
            coachAnalysisView.hidden = false
            
            _ = coachAnalysisTextView.text
            let contentSize = coachAnalysisTextView.sizeThatFits(coachAnalysisTextView.bounds.size)
            var frame = coachAnalysisTextView.frame
            frame.size.height = contentSize.height
            coachAnalysisTextView.frame = frame
            coachAnalysisTextViewHeightConstarint.constant = contentSize.height
            coachAnalysisViewHeightConstarint.constant = contentSize.height + 15
        }
        else {
            selfAnalysisView.hidden = false
            coachAnalysisView.hidden = true
            coachAnalysisViewHeightConstarint.constant = 0
            
            _ = selfAnalysisTextView.text
            let contentSize = selfAnalysisTextView.sizeThatFits(selfAnalysisTextView.bounds.size)
            var frame = selfAnalysisTextView.frame
            frame.size.height = contentSize.height
            selfAnalysisTextView.frame = frame
            selfAnalysisHeightConstarint.constant = contentSize.height
            selfAnalysisViewHeightConstraint.constant = contentSize.height + 15
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstOversText.delegate = self
        firstOversText.keyboardType = UIKeyboardType.DecimalPad
        firstScoreText.delegate = self
        firstWicketsText.delegate = self
        secondOversText.delegate = self
        secondOversText.keyboardType = UIKeyboardType.DecimalPad
        secondScoreText.delegate = self
        secondWicketsText.delegate = self
        resultText.delegate = self
        AchievementsText.delegate = self
        firstOversText2.delegate = self
        firstOversText2.keyboardType = UIKeyboardType.DecimalPad
        firstScoreText2.delegate = self
        firstWicketsText2.delegate = self
        secondOversText2.delegate = self
        secondOversText2.keyboardType = UIKeyboardType.DecimalPad
        secondScoreText2.delegate = self
        secondWicketsText2.delegate = self
        
        let resultsViewHolder = UIView(frame: CGRectMake(0, 30, UIScreen.mainScreen().bounds.width, 100))
        resultsViewHolder.backgroundColor = UIColor.redColor()
        
        let firstBattingText = NSMutableAttributedString()
        let secondBattingText = NSMutableAttributedString()
        let battingText = NSMutableAttributedString()
        var firstBattingformattedStringCollection = [NSMutableAttributedString]()
        var secondBattingformattedStringCollection = [NSMutableAttributedString]()
        
        battingText.normal("BATTING", fontName: appFont_bold, fontSize: 17)
        firstBattingText.bold("1", fontName: appFont_black, fontSize: 30).normal("st", fontName: appFont_bold, fontSize: 12)
        secondBattingText.bold("2", fontName: appFont_black, fontSize: 30).normal("nd", fontName: appFont_bold, fontSize: 12)
        firstBattingformattedStringCollection.append(firstBattingText)
        firstBattingformattedStringCollection.append(battingText)
        secondBattingformattedStringCollection.append(secondBattingText)
        secondBattingformattedStringCollection.append(battingText)
        firstBattingHeaderText.attributedText = firstBattingformattedStringCollection.joinWithSeparator("\n")
        secondBattingHeaderText.attributedText = secondBattingformattedStringCollection.joinWithSeparator("\n")
        
        if ((parent?.selecetedData) != nil){ inEditMode = true; loadEditData() }
        //setBackgroundColor()
        self.view.backgroundColor = UIColor.clearColor()
        //setUIBackgroundTheme(self.view)
        
        FirstBattingView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        self.FirstBattingView.alpha = 1
        SecondBattingView.backgroundColor = cricTracTheme.currentTheme.bottomColor
        self.SecondBattingView.alpha = 1
        
        if swapBtnVal == nil {
            swapBtnVal = 0
        }
        
        if resultText.text == "" {
            resultText.text = "Won"
        }
        
        playerAndCoachAnalysis()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RESULT")
    }
    
    var tossText: String! = "-"
    
    @IBOutlet weak var isTeambattingSetBtn: UIImageView!
    @IBOutlet weak var secondBattingHeaderText: UILabel!
    @IBOutlet weak var firstBattingHeaderText: UILabel!
    @IBOutlet weak var firstOversText: UITextField!
    @IBOutlet weak var firstScoreText:UITextField!
    @IBOutlet weak var firstWicketsText:UITextField!
    @IBOutlet weak var secondOversText:UITextField!
    @IBOutlet weak var secondScoreText:UITextField!
    @IBOutlet weak var secondWicketsText:UITextField!
    @IBOutlet weak var resultText:UITextField!
    @IBOutlet weak var firstOversText2: UITextField!
    @IBOutlet weak var firstScoreText2:UITextField!
    @IBOutlet weak var firstWicketsText2:UITextField!
    @IBOutlet weak var secondOversText2:UITextField!
    @IBOutlet weak var secondScoreText2:UITextField!
    @IBOutlet weak var secondWicketsText2:UITextField!
    
    weak var matchDetails:MatchDetailsTrackable?
    var teams = [String]()
    weak var parent:MatchParent?
    
//    var firstBattingDeclared1 = "0"
//    var firstBattingDeclared2 = "0"
//    var secondBattingDeclared1 = "0"
//    var secondBattingDeclared2 = "0"
    
    var firstBatDec1 = "0"
    var firstBatDec2 = "0"
    var secBatDec1 = "0"
    var secBatDec2 = "0"

    var data:[String:String]{
        
        var tossVal = ""
        if let val = tossText{
            tossVal = val.trim()
        }
        
        var firstBatVal = ""
        if let val = firstBatText{
            firstBatVal = val.trim()
        }
        
        var firstScoreVal = ""
        if let val = firstScoreText?.text where val != ""{
            firstScoreVal = val
        }
        else{
            firstScoreVal = "0"
        }
        
        var firstWicketsVal = "0"
        if let val = firstWicketsText?.text where val != ""{
            firstWicketsVal = val
        }
        else{
            firstWicketsVal = "0"
        }
        
        var secondBatVal = ""
        if let val = secondBatText{
            secondBatVal = val.trim()
        }
        
        var secondScoreVal = ""
        if let val = secondScoreText?.text where val != ""{
            secondScoreVal = val
        }
        else{
            secondScoreVal = "0"
        }
        
        var secondWicketsVal = "0"
        if let val = secondWicketsText?.text where val != ""{
            secondWicketsVal = val
        }
        else{
            secondWicketsVal = "0"
        }
        
        var firstScoreVal2 = ""
        if let val = firstScoreText2?.text where val != ""{
            firstScoreVal2 = val
        }
        else{
            firstScoreVal2 = "0"
        }
        
        var firstWicketsVal2 = "0"
        if let val = firstWicketsText2?.text where val != ""{
            firstWicketsVal2 = val
        }
        else {
            firstWicketsVal2 = "0"
        }
        
        var secondScoreVal2 = ""
        if let val = secondScoreText2?.text where val != ""{
            secondScoreVal2 = val
        }
        else{
            secondScoreVal2 = "0"
        }
        
        var secondWicketsVal2 = "0"
        if let val = secondWicketsText2?.text where val != ""{
            secondWicketsVal2 = val
        }
        else{
            secondWicketsVal2 = "0"
        }
        
        if firstBattingDeclaredBtn1.alpha == 1  {
            firstBatDec1 = "1"
        }
        else{
            firstBatDec1 = "0"
        }
        
        if firstBattingDeclaredBtn2.alpha == 1  {
            firstBatDec2 = "1"
        }
        else{
            firstBatDec2 = "0"
        }
        
        if secondBattingDeclaredBtn1.alpha == 1  {
            secBatDec1 = "1"
        }
        else{
            secBatDec1 = "0"
        }
        
        if secondBattingDeclaredBtn2.alpha == 1  {
            secBatDec2 = "1"
        }
        else{
            secBatDec2 = "0"
        }
       
        var resultVal = ""
        if let val = resultText{
            resultVal = val.textVal
        }
        
        var firstOversVal = "0"
        //sajith - added code for checking the Decimal value for Overs
        if let firstOvers = firstOversText.text  {
            if firstOvers.length > 0 && Float(firstOvers) >= 0 {
                firstOversVal = firstOversText.text!
                
                //check the decimal part of OversBowled
                let floatOvers = firstOversVal.componentsSeparatedByString(".")
                if floatOvers.count > 1 {
                    let intOvers = floatOvers[0]
                    var decOvers = "0"
                    if floatOvers[1].length != 0 {
                        decOvers = floatOvers[1]
                    }

                    if decOvers == "0" {
                        firstOversVal = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        firstOversVal = String(newIntOvers)
                    }
                    else {
                        firstOversVal = firstOversText.text!
                    }
                }
            }
        }
        
        var secondOversVal = "0"
        //sajith - added code for checking the Decimal value for Overs
        if let secondOvers = secondOversText.text {
            if secondOvers.length > 0 && Float(secondOvers) >= 0 {
                secondOversVal = secondOversText.text!
                
                //check the decimal part of OversBowled
                let floatOvers = secondOversVal.componentsSeparatedByString(".")
                if floatOvers.count > 1 {
                    let intOvers = floatOvers[0]
                    var decOvers = "0"
                    if floatOvers[1].length != 0 {
                        decOvers = floatOvers[1]
                    }
                    
                    if decOvers == "0" {
                        secondOversVal = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        secondOversVal = String(newIntOvers)
                    }
                    else {
                        secondOversVal = secondOversText.text!
                    }
                }
            }
        }
        
        //second innings
        var firstOversVal2 = "0"
        //sajith - added code for checking the Decimal value for Overs
        if let firstOvers = firstOversText2.text  {
            if firstOvers.length > 0 && Float(firstOvers) >= 0 {
                firstOversVal2 = firstOversText2.text!
                
                //check the decimal part of OversBowled
                let floatOvers = firstOversVal2.componentsSeparatedByString(".")
                if floatOvers.count > 1 {
                    let intOvers = floatOvers[0]
                    var decOvers = "0"
                    if floatOvers[1].length != 0 {
                        decOvers = floatOvers[1]
                    }
                    
                    if decOvers == "0" {
                        firstOversVal2 = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        firstOversVal2 = String(newIntOvers)
                    }
                    else {
                        firstOversVal2 = firstOversText2.text!
                    }
                }
            }
        }
        
        var secondOversVal2 = "0"
        //sajith - added code for checking the Decimal value for Overs
        if let secondOvers = secondOversText2.text {
            if secondOvers.length > 0 && Float(secondOvers) >= 0 {
                secondOversVal2 = secondOversText2.text!
                
                //check the decimal part of OversBowled
                let floatOvers = secondOversVal2.componentsSeparatedByString(".")
                if floatOvers.count > 1 {
                    let intOvers = floatOvers[0]
                    var decOvers = "0"
                    if floatOvers[1].length != 0 {
                        decOvers = floatOvers[1]
                    }
                    
                    if decOvers == "0" {
                        secondOversVal2 = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        secondOversVal2 = String(newIntOvers)
                    }
                    else {
                        secondOversVal2 = secondOversText2.text!
                    }
                }
            }
        }

        var AchievementsVal = ""
        if let val = AchievementsText{
            AchievementsVal = val.text!
        }
        
        var selfAnalysis = ""
        if let val = selfAnalysisTextView {
            if selfAnalysisTextView.text != placeHolderTextForSelfAnalysis {
                selfAnalysis = val.text!
            }
            else {
                selfAnalysis = ""
            }
        }
        var coachAnalysis = ""
        if let val = coachAnalysisTextView {
            if coachAnalysisTextView.text != placeHolderTextForCoachAnalysis{
                coachAnalysis = val.text!
            }
            else {
                coachAnalysis = ""
            }
        }
        
        if (parent?.matchVC.matchFormat.text)! == "Single Innings" {
            return ["TossWonBy":tossVal,"FirstBatting":firstBatVal,"FirstBattingScore":firstScoreVal,"FirstBattingWickets":firstWicketsVal,"SecondBatting":secondBatVal, "SecondBattingScore":secondScoreVal,"SecondBattingWickets":secondWicketsVal,"Result":resultVal,"FirstBattingOvers":firstOversVal,"SecondBattingOvers":secondOversVal,"Achievements":AchievementsVal,"SelfAnalysis": selfAnalysis,"CoachAnalysis":coachAnalysis]
        }
        else {
            return ["TossWonBy":tossVal,"FirstBatting":firstBatVal,"FirstBattingScore":firstScoreVal,"FirstBattingWickets":firstWicketsVal,"SecondBatting":secondBatVal, "SecondBattingScore":secondScoreVal,"SecondBattingWickets":secondWicketsVal,"Result":resultVal,"FirstBattingOvers":firstOversVal,"SecondBattingOvers":secondOversVal,"Achievements":AchievementsVal,"SelfAnalysis": selfAnalysis,"CoachAnalysis":coachAnalysis,"FirstBattingScore2":firstScoreVal2,"FirstBattingWickets2":firstWicketsVal2,"FirstBattingOvers2":firstOversVal2,"SecondBattingScore2":secondScoreVal2,"SecondBattingWickets2":secondWicketsVal2,"SecondBattingOvers2":secondOversVal2,"FirstBattingDeclared1":firstBatDec1,"FirstBattingDeclared2":firstBatDec2,"SecondBattingDeclared1":secBatDec1,"SecondBattingDeclared2":secBatDec2]
        }
    }
    
    @IBAction func FirstTeamWicketsIncrement(sender: AnyObject) {
        if swapBtnVal == 0 {
            incrementDecrementOperation(firstWicketsText, isIncrement: true)
        }
        else {
           incrementDecrementOperation(secondWicketsText, isIncrement: true)
        }
    }
    
    @IBAction func FirstTeamWicketsDecrement(sender: AnyObject) {
        if swapBtnVal == 0 {
            incrementDecrementOperation(firstWicketsText, isIncrement: false)
        }
        else {
            incrementDecrementOperation(secondWicketsText, isIncrement: false)
        }
    }
    
    @IBAction func SecondTeamWicketsIncrement(sender: AnyObject) {
        if swapBtnVal == 0 {
            incrementDecrementOperation(secondWicketsText, isIncrement: true)
        }
        else{
           incrementDecrementOperation(firstWicketsText, isIncrement: true)
        }
    }
    
    @IBAction func SecondTeamWicketsDecrement(sender: AnyObject) {
        if swapBtnVal == 0 {
           incrementDecrementOperation(secondWicketsText, isIncrement: false)
        }
        else {
            incrementDecrementOperation(firstWicketsText, isIncrement: false)
        }
    }
    
    @IBAction func tossBtnTapped(sender: UIButton) {
       // parent?.dataChangedAfterLastSave()
        firstTeamTossBtn.alpha = 0.2
        secondTeamTossBtn.alpha = 0.2
        sender.alpha = 1.0
        
        if sender.tag == 1 {
            tossText = firstTeamTitle.text
        }
        else
        {
            tossText = secondTeamTitle.text
        }
    }
    
    func setDeclaredData() {
        if inEditMode {
            if (parent?.matchVC.matchFormat.text)! == "Single Innings" {
                firstBattingDeclaredBtn1.hidden = true
                firstBattingDeclaredBtn2.hidden = true
                firstBattingDeclaredLabel1.hidden = true
                firstBattingDeclaredLabel2.hidden = true
            }
            else {
                firstBattingDeclaredBtn1.hidden = false
                firstBattingDeclaredBtn2.hidden = false
                firstBattingDeclaredLabel1.hidden = false
                firstBattingDeclaredLabel2.hidden = false
                
                let firstBatDecVal1 = parent?.selecetedData!["FirstBattingDeclared1"] as? String ?? ""
                let firstBatDecVal2 = parent?.selecetedData!["FirstBattingDeclared2"] as? String ?? ""
                let secBatDecVal1 = parent?.selecetedData!["SecondBattingDeclared1"] as? String ?? ""
                let secBatDecVal2 = parent?.selecetedData!["SecondBattingDeclared2"] as? String ?? ""
                
                if firstBatDecVal1 == "1" {
                    firstBattingDeclaredBtn1.alpha = 1
                }
                else {
                    firstBattingDeclaredBtn1.alpha = 0.2
                }
                
                if firstBatDecVal2 == "1" {
                    firstBattingDeclaredBtn2.alpha = 1
                }
                else {
                    firstBattingDeclaredBtn2.alpha = 0.2
                }
                
                if secBatDecVal1 == "1" {
                    secondBattingDeclaredBtn1.alpha = 1
                }
                else {
                    secondBattingDeclaredBtn1.alpha = 0.2
                }
                
                if secBatDecVal2 == "1" {
                    secondBattingDeclaredBtn2.alpha = 1
                }
                else {
                    secondBattingDeclaredBtn2.alpha = 0.2
                }
            }
        }
        else {
            if (parent?.matchVC.matchFormat.text)! == "Single Innings" {
                firstBattingDeclaredBtn1.hidden = true
                firstBattingDeclaredBtn2.hidden = true
                firstBattingDeclaredLabel1.hidden = true
                firstBattingDeclaredLabel2.hidden = true
            }
            else {
                firstBattingDeclaredBtn1.hidden = false
                firstBattingDeclaredBtn2.hidden = false
                firstBattingDeclaredLabel1.hidden = false
                firstBattingDeclaredLabel2.hidden = false
                
                if firstBattingDeclaredBtn1.alpha == 1 {
                    firstBattingDeclaredBtn1.alpha = 1
                }
                else {
                    firstBattingDeclaredBtn1.alpha = 0.2
                }
                if firstBattingDeclaredBtn2.alpha == 1 {
                    firstBattingDeclaredBtn2.alpha = 1
                }
                else {
                    firstBattingDeclaredBtn2.alpha = 0.2
                }
                if secondBattingDeclaredBtn1.alpha == 1 {
                    secondBattingDeclaredBtn1.alpha = 1
                }
                else {
                    secondBattingDeclaredBtn1.alpha = 0.2
                }
                if secondBattingDeclaredBtn2.alpha == 1 {
                    secondBattingDeclaredBtn2.alpha = 1
                }
                else {
                    secondBattingDeclaredBtn2.alpha = 0.2
                }
            }
        }
    }
    
    @IBAction func declaredBtnTapped(sender: UIButton) {
        if sender.tag == 1 {
            if firstBattingDeclaredBtn1.alpha == 1 {
                firstBattingDeclaredBtn1.alpha = 0.2
            }
            else {
                firstBattingDeclaredBtn1.alpha = 1
            }
        }
        
        if sender.tag == 2 {
            if firstBattingDeclaredBtn2.alpha == 1 {
                firstBattingDeclaredBtn2.alpha = 0.2
            }
            else {
                firstBattingDeclaredBtn2.alpha = 1
            }
        }
        
        if sender.tag == 3 {
            if secondBattingDeclaredBtn1.alpha == 1 {
                secondBattingDeclaredBtn1.alpha = 0.2
            }
            else {
                secondBattingDeclaredBtn1.alpha = 1
            }
        }
        
        if sender.tag == 4 {
            if secondBattingDeclaredBtn2.alpha == 1 {
                secondBattingDeclaredBtn2.alpha = 0.2
            }
            else {
                secondBattingDeclaredBtn2.alpha = 1
            }
        }
    }
    
    func setValueFromMultiSelectAchievements(valueSent: String)
    {
        AchievementsText.text = valueSent
    }
    
    override func viewDidAppear(animated: Bool) {
        setTeamData()
        setDeclaredData()
    }
    
    func loadEditData(){
        tossText = "-"
        if let toss = parent!.selecetedData!["TossWonBy"] {
            tossText = toss as! String
        }
        
        firstBatText = parent!.selecetedData!["FirstBatting"]! as? String ?? "-"
        firstScoreText.textVal = parent!.selecetedData!["FirstBattingScore"]! as? String ?? "-"
        firstWicketsText.textVal = parent!.selecetedData!["FirstBattingWickets"]! as? String ?? "-"
        secondBatText = parent!.selecetedData!["SecondBatting"]! as? String ?? "-"
        
        existFB = firstBatText
        existSB = secondBatText
        
        AchievementsText.text = parent?.selecetedData!["Achievements"] as? String ?? ""
        selfAnalysisTextView.text = parent?.selecetedData!["SelfAnalysis"] as? String ?? ""
        coachAnalysisTextView.text = parent?.selecetedData!["CoachAnalysis"] as? String ?? ""
        
        firstTeamTitle.text = firstBatText
        secondTeamTitle.text = secondBatText
        
        firstOversText.text = parent!.selecetedData!["FirstBattingOvers"] as? String ?? "-"
        
        firstTeamTossBtn.alpha = 0.2
        secondTeamTossBtn.alpha = 0.2
        isTeambattingSetBtn.alpha = 0.3
        
        if tossText.trim() == firstBatText.trim() {
            firstTeamTossBtn.alpha = 1.0
        }
        else if tossText.trim() == secondBatText.trim()
        {
            secondTeamTossBtn.alpha = 1.0
        }
        
        if firstBatText != "-" {
            self.isTeambattingSetBtn.alpha = 1.0
        }
        
        secondScoreText.textVal = parent!.selecetedData!["SecondBattingScore"]! as? String ?? "-"
        secondOversText.textVal = parent!.selecetedData!["SecondBattingOvers"] as? String ?? "-"
        secondWicketsText.textVal = parent!.selecetedData!["SecondBattingWickets"]! as? String ?? "-"
        resultText.textVal = parent!.selecetedData!["Result"]! as? String ?? "-"
        
        if  parent!.selecetedData!["MatchFormat"] as? String == "Double Innings" && parent!.selecetedData!["MatchFormat"]  != nil {
            
            firstScoreText2.textVal = parent!.selecetedData!["FirstBattingScore2"]! as? String ?? "-"
            firstWicketsText2.textVal = parent!.selecetedData!["FirstBattingWickets2"]! as? String ?? "-"
            firstOversText2.text = parent!.selecetedData!["FirstBattingOvers2"] as? String ?? "-"
            
            secondScoreText2.textVal = parent!.selecetedData!["SecondBattingScore2"]! as? String ?? "-"
            secondOversText2.textVal = parent!.selecetedData!["SecondBattingOvers2"] as? String ?? "-"
            secondWicketsText2.textVal = parent!.selecetedData!["SecondBattingWickets2"]! as? String ?? "-"
        }
    }
    
    func allRequiredFieldsHaveFilledProperly()->Bool{
        return false
    }
    
    func setTeamData(){
        if !inEditMode {
            if let matchVCInstance = parent?.matchVC {
                firstTeamTitle.text = matchVCInstance.teamText.text
                secondTeamTitle.text = matchVCInstance.opponentText.text
                
                if tossText == "" || tossText == "-" {
                    tossText = matchVCInstance.teamText.text
                    firstTeamTossBtn.alpha = 1.0
                    secondTeamTossBtn.alpha = 0.2
                }
                else {
                    if data["TossWonBy"] == matchVCInstance.teamText.text {
                        firstTeamTossBtn.alpha = 1.0
                        secondTeamTossBtn.alpha = 0.2
                    }
                    else
                    {
                        firstTeamTossBtn.alpha = 0.2
                        secondTeamTossBtn.alpha = 1.0
                    }
                }
            }
        }
        
        //sajith - added if condition to fix the issue while in Edit mode
        if inEditMode && !parent!.matchVC.teamOROpponentFieldChanged {
            firstTeamTitle.text = parent!.selecetedData!["FirstBatting"]! as? String
            secondTeamTitle.text = parent!.selecetedData!["SecondBatting"]! as? String
        }
        
        if inEditMode && parent!.matchVC.teamOROpponentFieldChanged , let matchVCInstance = parent?.matchVC {
            if matchVCInstance.existTeamName == parent!.selecetedData!["FirstBatting"]! as? String {
                firstTeamTitle.text = matchVCInstance.teamText.text
                secondTeamTitle.text = matchVCInstance.opponentText.text
            }
            else {
                firstTeamTitle.text = matchVCInstance.opponentText.text
                secondTeamTitle.text = matchVCInstance.teamText.text
            }
        }
        
        firstBatText = firstTeamTitle.text
        secondBatText = secondTeamTitle.text
        
        if !parent!.matchVC.teamOROpponentFieldChanged , let matchVCInstance = parent?.matchVC {
            if tossText == "" || tossText == "-" {
                tossText = firstBatText
            }
            
            if tossText == firstBatText {
                firstTeamTossBtn.alpha = 1.0
                secondTeamTossBtn.alpha = 0.2
            }
            else
            {
                firstTeamTossBtn.alpha = 0.2
                secondTeamTossBtn.alpha = 1.0
            }
        }
    
        self.isTeambattingSetBtn.alpha = (firstBatText == "-" || firstBatText == "") ? 0.3 : 1.0
        
        teams.removeAll()
        if matchDetails?.opponentText.text?.trimWhiteSpace.length > 0{
            if matchDetails?.teamText.text?.trimWhiteSpace.length > 0{
                teams.append((matchDetails?.teamText.text?.trimWhiteSpace)!)
                teams.append((matchDetails?.opponentText.text?.trimWhiteSpace)!)
            }
        }
    }
    
    func incrementDecrementOperation(controlText: UITextField, isIncrement: Bool) {
        if isIncrement {
            if let currentValue = Int(controlText.text!) {
                if currentValue < 99 {
                    controlText.text = String(currentValue + 1)
                }
            }
        }
        else
        {
            if let currentValue = Int(controlText.text!) {
                if currentValue > 0 {
                    controlText.text = String(currentValue - 1)
                }
            }
        }
        
        textFieldDidEndEditing(controlText)
    }

    @IBAction func swapBtnPressed(sender: AnyObject) {
        
        if swapBtnVal == 0 {
            swapBtnVal = 1
        }
        else {
            swapBtnVal = 0
        }
        
        if (self.firstBatText != "-" && self.firstBatText != "") {
            if swapBtnVal == 0 {
                firstBatText = firstTeamTitle.text
                secondBatText = secondTeamTitle.text
            }
            else {
                firstBatText = secondTeamTitle.text
                secondBatText = firstTeamTitle.text
            }
            
            let tempbattingtext = firstBatText
            firstBatText = secondBatText
            secondBatText = tempbattingtext
            
            let tempOvers = firstOversText
            firstOversText = secondOversText
            secondOversText = tempOvers
            
            let tempScore = firstScoreText
            firstScoreText = secondScoreText
            secondScoreText = tempScore
            
            let tempWickets = firstWicketsText
            firstWicketsText = secondWicketsText
            secondWicketsText = tempWickets
            
            let tempOvers2 = firstOversText2
            firstOversText2 = secondOversText2
            secondOversText2 = tempOvers2
            
            let tempScore2 = firstScoreText2
            firstScoreText2 = secondScoreText2
            secondScoreText2 = tempScore2
            
            let tempWickets2 = firstWicketsText2
            firstWicketsText2 = secondWicketsText2
            secondWicketsText2 = tempWickets2
            
            let tempFirstBatDec1 = firstBattingDeclaredBtn1
            firstBattingDeclaredBtn1 = firstBattingDeclaredBtn2
            firstBattingDeclaredBtn2 = tempFirstBatDec1
            
            let tempSecondBatDec1 = secondBattingDeclaredBtn1
            secondBattingDeclaredBtn1 = secondBattingDeclaredBtn2
            secondBattingDeclaredBtn2 = tempSecondBatDec1
            
            let tempPt = FirstBattingView.center
            
           // parent?.dataChangedAfterLastSave()
            
            UIView.animateWithDuration(1.0,
                                       delay: 0.0,
                                       options: .AllowUserInteraction,
                                       animations: {
                                        self.FirstBattingView.center = self.SecondBattingView.center
                },
                                       completion: { finished in
            })
            
            UIView.animateWithDuration(1.0,
                                       delay: 0.0,
                                       options: .AllowUserInteraction,
                                       animations: {
                                        self.SecondBattingView.center = tempPt
                },
                                       completion: { finished in
            })
            
            animateBtn();
        }
        
        
//        FirstBattingView.layer.addAnimation(animateSwap(SecondBattingView.center), forKey: "animate position along path")
//        
//        SecondBattingView.layer.addAnimation(animateSwap(tempPt), forKey: "animate position along path")
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func animateBtn() {
    let duration = 1.0
    let delay = 0.0
    let options = UIViewKeyframeAnimationOptions.CalculationModePaced
    
    UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
    
    // note that we've set relativeStartTime and relativeDuration to zero.
    // Because we're using `CalculationModePaced` these values are ignored
    // and iOS figures out values that are needed to create a smooth constant transition
    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
    self.refreshBtn.transform = CGAffineTransformMakeRotation(1/3 * self.fullRotation)
    })
    
    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
    self.refreshBtn.transform = CGAffineTransformMakeRotation(2/3 * self.fullRotation)
    })
    
    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
    self.refreshBtn.transform = CGAffineTransformMakeRotation(3/3 * self.fullRotation)
    })
    
        }, completion: {_ in
            self.isTeambattingSetBtn.alpha = (self.firstBatText == "-" || self.firstBatText == "") ? 0.3 : 1.0
    })
    }
    
    func animateSwap(pointToMoveTo: CGPoint) -> CAKeyframeAnimation {
        let path = UIBezierPath()
        path.moveToPoint(pointToMoveTo)
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = path.CGPath
        anim.duration = 2.0
        return anim
    }
    
    // Fro player and coach analysis
    
    func playerAndCoachAnalysis() {
        if selfAnalysisTextView.text == "" {
            selfAnalysisTextView.text = placeHolderTextForSelfAnalysis
            selfAnalysisTextView.alpha = 0.7
        }
        if coachAnalysisTextView.text == "" {
            coachAnalysisTextView.text = placeHolderTextForCoachAnalysis
            coachAnalysisTextView.alpha = 0.7
        }
    }
   // textView delegates
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView == selfAnalysisTextView {
            if selfAnalysisTextView.text == placeHolderTextForSelfAnalysis {
                selfAnalysisTextView.text = ""
                selfAnalysisTextView.alpha = 1

            }
        }
        if textView == coachAnalysisTextView {
            if coachAnalysisTextView.text == placeHolderTextForCoachAnalysis {
                coachAnalysisTextView.text = ""
                coachAnalysisTextView.alpha = 1
            }
        }
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView == selfAnalysisTextView {
            if selfAnalysisTextView.text == "" {
                selfAnalysisTextView.text = placeHolderTextForSelfAnalysis
            }
        }
        if textView == coachAnalysisTextView {
            if coachAnalysisTextView.text == "" {
                coachAnalysisTextView.text = placeHolderTextForCoachAnalysis
            }
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == selfAnalysisTextView {
            if selfAnalysisHeightConstarint.constant >= 50 {
                screenShotHeight.constant += 35
            }
        }
        if textView == coachAnalysisTextView{
            if selfAnalysisHeightConstarint.constant >= 50 {
                screenShotHeight.constant += 35
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
       
        // selfAnalysis TextView
        if textView == selfAnalysisTextView {
            let newLength = textView.text.characters.count + text.characters.count - range.length

            if newLength <= 300 {
                    _ = textView.text
                let contentSize = textView.sizeThatFits(textView.bounds.size)
                var frame = textView.frame
                frame.size.height = contentSize.height
                //if contentSize.height < 100 {
                    textView.frame = frame
                    selfAnalysisHeightConstarint.constant = contentSize.height
                    selfAnalysisViewHeightConstraint.constant = contentSize.height + 10
                //}
            }
           return newLength < 301
        }
        // coachAnalysis 
        
        if textView == coachAnalysisTextView {
            let newLength = textView.text.characters.count + text.characters.count - range.length
            if newLength <= 300 {
                _ = textView.text
                let contentSize = textView.sizeThatFits(textView.bounds.size)
                var frame = textView.frame
                frame.size.height = contentSize.height
                if contentSize.height < 100 {
                    textView.frame = frame
                    coachAnalysisViewHeightConstarint.constant = contentSize.height
                    coachAnalysisTextViewHeightConstarint.constant = contentSize.height
                }
            }
             return newLength <= 301
        }
        
        return true
    }
}

extension MatchResultsViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == firstScoreText || textField == secondScoreText {
          animateViewMoving(true, moveValue: 100)
        }
        
        if textField == firstOversText || textField == secondOversText {
            animateViewMoving(true, moveValue: 210)
        }
        
        if textField == firstWicketsText || textField == secondWicketsText || textField == firstWicketsText2 || textField == secondWicketsText2 {
             showPicker(self, inputText: textField, data: maxWickets)
        }

        
        if textField == resultText{
             //resultText.becomeFirstResponder()
            ctDataPicker = DataPicker()
            let indexPos = results.indexOf(resultText.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: results,selectedValueIndex: indexPos)
        // showPicker(self, inputText: textField, data: results)
            AchievementsText.userInteractionEnabled = false
           
        }
        else if textField == AchievementsText {
//            ctDataPicker = DataPicker()
//            let indexPos = Achievements.indexOf(AchievementsText.text!) ?? 0
//            ctDataPicker.showPicker(self, inputText: textField, data: Achievements,selectedValueIndex: indexPos)
            //showPicker(self, inputText: textField, data: Achievements)
            
           // resultText.resignFirstResponder()
            AchievementsText.resignFirstResponder()
            
            let AchievementVC = viewControllerFrom("Main", vcid:"AchievementListViewController") as! AchievementListViewController
            
            AchievementVC.delegate = self
            //AchievementVC.achievementData = AchievementsText.text!
            
            AchievementVC.selectedRows = (AchievementsText.text?.characters.split{$0 == ","}.map(String.init))!
            self.presentViewController(AchievementVC, animated: true) {}
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == firstScoreText || textField == secondScoreText{
            animateViewMoving(false, moveValue: 100)
        }
        
        if textField == firstOversText || textField == secondOversText {
            animateViewMoving(false, moveValue: 210)
        }
        
//        if textField == firstWicketsText {
//            animateViewMoving(false, moveValue: 160)
//        }
        
        if textField == resultText{
             AchievementsText.userInteractionEnabled = true
        }
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
   
   
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newlength = textField.text!.characters.count + string.characters.count - range.length
        if textField == firstScoreText || textField == secondScoreText || textField == firstScoreText2 || textField == secondScoreText2 {
           return newlength <= 4
        }
        else if textField == firstOversText || textField == secondOversText || textField == firstOversText2 || textField == secondOversText2 {
            return newlength <= 5
        }
        else if textField == firstWicketsText || textField == secondWicketsText || textField == firstWicketsText2 || textField == secondWicketsText2 {
            return newlength <= 2
        }
        else if textField == AchievementsText {
            return false
        }
        else if textField == resultText {
            return false
        }
            
        else {
            return true
        }
    }
}
