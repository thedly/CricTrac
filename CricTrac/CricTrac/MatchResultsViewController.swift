//
//  MatchResultsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MatchResultsViewController: UIViewController, IndicatorInfoProvider,ThemeChangeable {

    @IBOutlet weak var firstTeamTitle: UILabel!
    @IBOutlet weak var secondTeamTitle: UILabel!
    @IBOutlet weak var firstTeamTossBtn: UIButton!
    @IBOutlet weak var secondTeamTossBtn: UIButton!
    @IBOutlet weak var AchievementsText: UITextField!
    @IBOutlet weak var FirstBattingView: UIView!
    @IBOutlet weak var SecondBattingView: UIView!
    
     lazy var ctDataPicker = DataPicker()
    
    var firstBatText: String!
    var secondBatText: String!
    var swapBtnVal: Int!
    //var resultsTab = 1
    var existFB = ""
    var existSB = ""
    var achievementText = [String]()
    
    private var inEditMode: Bool = false
    
    let fullRotation = CGFloat(M_PI * 2)
    
    @IBOutlet weak var refreshBtn: UIButton!

    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
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
        
        FirstBattingView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        FirstBattingView.alpha = 0.8
        SecondBattingView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        SecondBattingView.alpha = 0.8
        
        // Do any additional setup after loading the view.
        
        if swapBtnVal == nil {
            swapBtnVal = 0
        }
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
        
//        if let val = firstOversText?.text where val != ""{
//            firstOversVal = val
//        }
//        else{
//            firstOversVal = "0"
//        }
        
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

//        if let val = secondOversText?.text where val != ""{
//            secondOversVal = val
//        }
//        else{
//            secondOversVal = "0"
//        }
        
        var AchievementsVal = ""
        if let val = AchievementsText{
            AchievementsVal = val.textVal
        }
        
        return ["TossWonBy":tossVal,"FirstBatting":firstBatVal,"FirstBattingScore":firstScoreVal,"FirstBattingWickets":firstWicketsVal,"SecondBatting":secondBatVal, "SecondBattingScore":secondScoreVal,"SecondBattingWickets":secondWicketsVal,"Result":resultVal,"FirstBattingOvers":firstOversVal,"SecondBattingOvers":secondOversVal,"Achievements":AchievementsVal]
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

    override func viewDidAppear(animated: Bool) {
        setTeamData()
      //  AchievementsText?.text = achievementText.joinWithSeparator("\n")
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
        
        AchievementsText.text = parent?.selecetedData!["Achievements"] as? String ?? "-"
        
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
            }
        }
        
        //sajith - added if condition to fix the issue while in Edit mode
        if inEditMode && !parent!.matchVC.teamOROpponentFieldChanged {
            //if swapBtnVal == 0 {
                firstTeamTitle.text = parent!.selecetedData!["FirstBatting"]! as? String
                secondTeamTitle.text = parent!.selecetedData!["SecondBatting"]! as? String
//            }
//            else {
//                firstTeamTitle.text = secondBatText
//                secondTeamTitle.text = firstBatText
//            }
        }
        
        if inEditMode && parent!.matchVC.teamOROpponentFieldChanged , let matchVCInstance = parent?.matchVC {
            //if swapBtnVal == 0 {
                if matchVCInstance.existTeamName == parent!.selecetedData!["FirstBatting"]! as? String {
                    firstTeamTitle.text = matchVCInstance.teamText.text
                    secondTeamTitle.text = matchVCInstance.opponentText.text
                }
                else {
                    firstTeamTitle.text = matchVCInstance.opponentText.text
                    secondTeamTitle.text = matchVCInstance.teamText.text
                }
//            }
//            else {
//                if matchVCInstance.existTeamName == parent!.selecetedData!["FirstBatting"]! as? String {
//                    firstTeamTitle.text = matchVCInstance.opponentText.text
//                    secondTeamTitle.text = matchVCInstance.teamText.text
//                }
//                else {
//                    firstTeamTitle.text = matchVCInstance.teamText.text
//                    secondTeamTitle.text = matchVCInstance.opponentText.text
//                }
//            }
//            if swapBtnVal == 0 {
//                firstTeamTitle.text = matchVCInstance.teamText.text
//                secondTeamTitle.text = matchVCInstance.opponentText.text
//            }
//            else {
//                firstTeamTitle.text = matchVCInstance.opponentText.text
//                secondTeamTitle.text = matchVCInstance.teamText.text
//            }

        }
        
        
        //commented by sajith
        //        if inEditMode && parent!.matchVC.teamOROpponentFieldChanged , let matchVCInstance = parent?.matchVC {
        //            firstTeamTitle.text = matchVCInstance.teamText.text
        //            secondTeamTitle.text = matchVCInstance.opponentText.text
        //        }
        
//        if resultsTab == 1 {
//            firstBatText = firstTeamTitle.text
//            secondBatText = secondTeamTitle.text
//        }
        
        firstBatText = firstTeamTitle.text
        secondBatText = secondTeamTitle.text
        
        if parent!.matchVC.teamOROpponentFieldChanged , let matchVCInstance = parent?.matchVC {
            if swapBtnVal == 0 {
                tossText = matchVCInstance.teamText.text
                firstTeamTossBtn.alpha = 1.0
                secondTeamTossBtn.alpha = 0.2
            }
            else {
                tossText = matchVCInstance.opponentText.text
                firstTeamTossBtn.alpha = 0.2
                secondTeamTossBtn.alpha = 1.0
            }
        }
        else {
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
}

extension MatchResultsViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == resultText{
            ctDataPicker = DataPicker()
            let indexPos = results.indexOf(resultText.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: results,selectedValueIndex: indexPos)
        // showPicker(self, inputText: textField, data: results)
           
        }
        else if textField == AchievementsText {
            ctDataPicker = DataPicker()
            let indexPos = Achievements.indexOf(AchievementsText.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: Achievements,selectedValueIndex: indexPos)
            //showPicker(self, inputText: textField, data: Achievements)
            
            //let AchievementVC = viewControllerFrom("Main", vcid:"AchievementListViewController") as! AchievementListViewController
            //self.presentViewController(AchievementVC, animated: true) {}
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        if textField.text?.trimWhiteSpace.length > 0{
//            
//            //parent?.dataChangedAfterLastSave()
//        }
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
