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
    
    @IBOutlet weak var screenShotHeight: NSLayoutConstraint!
    // player and coach analysis
    
    @IBOutlet weak var selfAnalysisView: UIView!
    @IBOutlet weak var selfAnalysisViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfAnalysisTextView: UITextView!
    @IBOutlet weak var selfAnalysisHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisTextView: UITextView!
    @IBOutlet weak var coachAnalysisTextViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var coachAnalysisView: UIView!
    var achievementsTextValue :String?
    
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
        
    }
   
//    
//    func layoutSubViewForAnalysis() {
// 
//                _ = selfAnalysisTextView.text
//                let contentSize = selfAnalysisTextView.sizeThatFits(selfAnalysisTextView.bounds.size)
//                var frame = selfAnalysisTextView.frame
//                frame.size.height = contentSize.height
//                selfAnalysisTextView.frame = frame
//                selfAnalysisHeightConstarint.constant = contentSize.height
//                selfAnalysisViewHeightConstraint.constant = contentSize.height + 15
//    
//    }
    
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
        // Do any additional setup after loading the view.
        
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
    
    weak var matchDetails:MatchDetailsTrackable?
    var teams = [String]()
    weak var parent:MatchParent?

    
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
        
        var firstWicketsVal = ""
        if let val = firstWicketsText{
            firstWicketsVal = val.textVal
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
        
        var resultVal = ""
        if let val = resultText{
            resultVal = val.textVal
        }
        
        var firstOversVal = "0"
        //sajith - added code for checking the Decimal value for Overs
        if let firstOvers = firstOversText.text {
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
        
        return ["TossWonBy":tossVal,"FirstBatting":firstBatVal,"FirstBattingScore":firstScoreVal,"FirstBattingWickets":firstWicketsVal,"SecondBatting":secondBatVal, "SecondBattingScore":secondScoreVal,"SecondBattingWickets":secondWicketsVal,"Result":resultVal,"FirstBattingOvers":firstOversVal,"SecondBattingOvers":secondOversVal,"Achievements":AchievementsVal,"SelfAnalysis": selfAnalysis,"CoachAnalysis":coachAnalysis]
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

    func setValueFromMultiSelectAchievements(valueSent: String)
    {
        AchievementsText.text = valueSent
    }
    
    override func viewDidAppear(animated: Bool) {
        setTeamData()
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
            }
        }
        if textView == coachAnalysisTextView {
            if coachAnalysisTextView.text == placeHolderTextForCoachAnalysis {
                coachAnalysisTextView.text = ""
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
                screenShotHeight.constant = screenShotHeight.constant + 35
            }
        }
        if textView == coachAnalysisTextView{
            if selfAnalysisHeightConstarint.constant >= 50 {
                screenShotHeight.constant = screenShotHeight.constant + 35
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
       
        // selfAnalysis TextView
        if textView == selfAnalysisTextView {
            let newLength = textView.text.characters.count + text.characters.count - range.length

            if newLength <= 200 {
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
           return newLength < 201
        }
        // coachAnalysis 
        
        if textView == coachAnalysisTextView {
            let newLength = textView.text.characters.count + text.characters.count - range.length
            if newLength <= 200 {
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
             return newLength <= 200
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
        
//        if textField == firstWicketsText {
//            animateViewMoving(true, moveValue: 160)
//        }
        
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
        if textField == firstScoreText || textField == secondScoreText {
           return newlength <= 4
        }
        else if textField == firstOversText || textField == secondOversText {
            return newlength <= 5
        }
        else if textField == firstWicketsText || textField == secondWicketsText {
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
