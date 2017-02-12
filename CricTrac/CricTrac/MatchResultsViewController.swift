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
    
    var firstBatText: String!
    var secondBatText: String!
    
    private var inEditMode: Bool = false
    
    let fullRotation = CGFloat(M_PI * 2)
    
    @IBOutlet weak var refreshBtn: UIButton!


    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        firstOversText.delegate = self
        firstScoreText.delegate = self
        firstWicketsText.delegate = self
        secondOversText.delegate = self
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "RESULTS")
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
        
        return ["TossWonBy":tossText.trim() ?? "-","FirstBatting":firstBatText.trim(),"FirstBattingScore":firstScoreText.textVal,"FirstBattingWickets":firstWicketsText.textVal,"SecondBatting":secondBatText.trim(), "SecondBattingScore":secondScoreText.textVal,"SecondBattingWickets":secondWicketsText.textVal,"Result":resultText.textVal,"FirstBattingOvers":firstOversText.textVal,"SecondBattingOvers":secondOversText.textVal,"Achievements": AchievementsText.textVal]
    }
    
    
    @IBAction func FirstTeamWicketsIncrement(sender: AnyObject) {
        incrementDecrementOperation(firstWicketsText, isIncrement: true)
    }
    
    
    @IBAction func FirstTeamWicketsDecrement(sender: AnyObject) {
        incrementDecrementOperation(firstWicketsText, isIncrement: false)
    }
    
    @IBAction func SecondTeamWicketsDecrement(sender: AnyObject) {
        incrementDecrementOperation(secondWicketsText, isIncrement: false)
    }
    @IBAction func SecondTeamWicketsIncrement(sender: AnyObject) {
        incrementDecrementOperation(secondWicketsText, isIncrement: true)
    }
    @IBAction func tossBtnTapped(sender: UIButton) {
        
        parent?.dataChangedAfterLastSave()
        
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
    }
    
    func loadEditData(){
        
        tossText = "-"
        if let toss = parent!.selecetedData!["TossWonBy"] {
            tossText = toss as! String
        }
        
        firstBatText = parent!.selecetedData!["FirstBatting"]! as! String ?? "-"
        firstScoreText.textVal = parent!.selecetedData!["FirstBattingScore"]! as! String ?? "-"
        firstWicketsText.textVal = parent!.selecetedData!["FirstBattingWickets"]! as! String ?? "-"
        secondBatText = parent!.selecetedData!["SecondBatting"]! as! String ?? "-"
        
        AchievementsText.text = parent?.selecetedData!["Achievements"] as! String ?? "-"
        
        firstTeamTitle.text = firstBatText
        secondTeamTitle.text = secondBatText
        
        
        firstOversText.text = parent!.selecetedData!["FirstBattingOvers"] as! String ?? "-"
        
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
        
        secondScoreText.textVal = parent!.selecetedData!["SecondBattingScore"]! as! String ?? "-"
        
        secondOversText.textVal = parent!.selecetedData!["SecondBattingOvers"] as! String ?? "-"
        
        secondWicketsText.textVal = parent!.selecetedData!["SecondBattingWickets"]! as! String ?? "-"
        resultText.textVal = parent!.selecetedData!["Result"]! as! String ?? "-"
    }
    
    func allRequiredFieldsHaveFilledProperly()->Bool{
        
        return false
    }
    
    func setTeamData(){
        
        if !inEditMode, let matchVCInstance = parent?.matchVC {
            firstTeamTitle.text = matchVCInstance.teamText.text
            secondTeamTitle.text = matchVCInstance.opponentText.text
        }
        
        firstBatText = firstTeamTitle.text
        secondBatText = secondTeamTitle.text
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
                if currentValue >= 0 {
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
        
        if (self.firstBatText != "-" && self.firstBatText != "") {
            firstBatText = firstTeamTitle.text
            secondBatText = secondTeamTitle.text
            
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
            
            parent?.dataChangedAfterLastSave()
            
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
            showPicker(self, inputText: textField, data: results)
        }
        else if textField == AchievementsText {
            showPicker(self, inputText: textField, data: Achievements)
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.trimWhiteSpace.length > 0{
            
            parent?.dataChangedAfterLastSave()
        }
    }
}
