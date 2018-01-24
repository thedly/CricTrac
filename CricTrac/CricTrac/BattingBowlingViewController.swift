//
//  BattingBowlingViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SkyFloatingLabelTextField

class BattingBowlingViewController: UIViewController,IndicatorInfoProvider,ThemeChangeable {
    
    var selectedText:UITextField!

    @IBOutlet weak var runsText: SkyFloatingLabelTextField!
    @IBOutlet weak var ballsPlayedText:UITextField!
    @IBOutlet weak var foursText:UITextField!
    @IBOutlet weak var sixesText:UITextField!
    @IBOutlet weak var strikeRateText:UITextField!
    @IBOutlet weak var positionText:UITextField!
    @IBOutlet weak var dismissalText:UITextField!
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var oversText:UITextField!
    @IBOutlet weak var wicketsText:UITextField!
    @IBOutlet weak var noballText:UITextField!
    @IBOutlet weak var widesText:UITextField!
    @IBOutlet weak var maidensText: UITextField!
    @IBOutlet weak var runsGivenText: UITextField!
    weak var parent:MatchParent?
    @IBOutlet weak var battingDetailsLabel: UILabel!
    @IBOutlet weak var bowlingdetailsLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    // FIELDING
    @IBOutlet weak var roleText: SkyFloatingLabelTextField!
    @IBOutlet weak var catchesText: SkyFloatingLabelTextField!
    @IBOutlet weak var stumpingsText: SkyFloatingLabelTextField!
    
    @IBOutlet weak var runoutsText: SkyFloatingLabelTextField!
    
    
    // SECOND INNINGS
    @IBOutlet weak var runsText2: SkyFloatingLabelTextField!
    @IBOutlet weak var ballsPlayedText2:UITextField!
    @IBOutlet weak var foursText2:UITextField!
    @IBOutlet weak var sixesText2:UITextField!
    @IBOutlet weak var positionText2:UITextField!
    @IBOutlet weak var dismissalText2:UITextField!
    @IBOutlet weak var oversText2:UITextField!
    @IBOutlet weak var wicketsText2:UITextField!
    @IBOutlet weak var noballText2:UITextField!
    @IBOutlet weak var widesText2:UITextField!
    @IBOutlet weak var maidensText2: UITextField!
    @IBOutlet weak var runsGivenText2: UITextField!
    @IBOutlet weak var secondInningsView: UIView!
    @IBOutlet weak var secondInningsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var baseView: NSLayoutConstraint!
   
    var bowledOvers: String!
    var WicketsTaken: String!
    var RunsGiven: String!
    var NoBalls: String!
    var Wides: String!
    var Maidens: String!
    
    var RunsTaken: String!
    var BallsFaced: String!
    var Fours: String!
    var Sixes: String!
    var Position: String!
    var Dismissal: String!
    
    // second innings
    
    var bowledOvers2: String!
    var WicketsTaken2: String!
    var RunsGiven2: String!
    var NoBalls2: String!
    var Wides2: String!
    var Maidens2: String!
    
    var RunsTaken2: String!
    var BallsFaced2: String!
    var Fours2: String!
    var Sixes2: String!
    var Position2: String!
    var Dismissal2: String!
    
    var FieldingRole: String!
    var catches: String!
    var stumpings: String!
    var runouts: String!
    
    
    
    
    var BowlingData:[String:String]{
        
        if (parent?.matchVC.matchFormat.text)! == "Single Innings" {
           return ["OversBowled":bowledOvers,"WicketsTaken":WicketsTaken,"RunsGiven":RunsGiven,"NoBalls":NoBalls,"Wides":Wides, "Maidens": Maidens]
        }
        else {
            return ["OversBowled":bowledOvers,"WicketsTaken":WicketsTaken,"RunsGiven":RunsGiven,"NoBalls":NoBalls,"Wides":Wides, "Maidens": Maidens,"OversBowled2":bowledOvers2,"WicketsTaken2":WicketsTaken2,"RunsGiven2":RunsGiven2,"NoBalls2":NoBalls2,"Wides2":Wides2, "Maidens2": Maidens2]
        }
        
    }
    
    
    var FieldingData:[String:String] {
        
        if roleText.text != ""{
            FieldingRole = roleText.text
        }
        else {
            FieldingRole = "-"
        }
        
        if catchesText.text != "" {
            catches = catchesText.text
        }
        else {
            catches = "0"
        }
        
        if stumpingsText.text != "" {
            stumpings = stumpingsText.text
        }
        else {
            stumpings = "0"
        }
        
        if runoutsText.text != "" {
            runouts = runoutsText.text
        }
        else {
           runouts = "0"
        }
       return["FieldingRole":FieldingRole,"Catches":catches,"Stumpings":stumpings,"Runouts":runouts]
    }
    
    var allRequiredFieldsHaveFilledProperly: Bool {
        if let _ = runsText, let _ = oversText {
            ValidateScore()
            validateOvers()
            return true
        }
        return true
    }
    
    func ValidateScore() -> Void {
        if let runText = runsText.text {
            if runText.trimWhiteSpace.length > 0 && Int(runText)! >= 0  {
                RunsTaken = runText
                if let foursScored = foursText.text {
                    Fours = foursScored != "-" && foursScored.length > 0 ? foursScored : "0"
                }
                
                if let sixesScored = sixesText.text {
                    Sixes = sixesScored != "-" && sixesScored.length > 0 ? sixesScored : "0"
                }
                
                if let dismissal = dismissalText.text {
                    Dismissal = dismissal != "-" && dismissal.length > 0 ? dismissal : dismissals[0]
                }
                
                if let position = positionText.text {
                    Position = position != "-" && position.length > 0 ? position : "1"
                }
                
                if let ballsPlayed = ballsPlayedText.text {
                    BallsFaced = ballsPlayed != "-" && ballsPlayed.length > 0 ? ballsPlayed : runText
                }
                
                foursText.userInteractionEnabled = true
                sixesText.userInteractionEnabled = true
                positionText.userInteractionEnabled = true
                dismissalText.userInteractionEnabled = true
                ballsPlayedText.userInteractionEnabled = true
            }
            else
            {
                self.view.endEditing(true)
                RunsTaken = "-"
                Fours = "-"
                Sixes = "-"
                Dismissal = "-"
                Position = "-"
                BallsFaced = "-"
                
               // foursText.userInteractionEnabled = false
               // sixesText.userInteractionEnabled = false
               // dismissalText.userInteractionEnabled = false
               // positionText.userInteractionEnabled = false
               // ballsPlayedText.userInteractionEnabled = false
            }
        }
        
        
    // second innings
        
        if let runText = runsText2.text {
            if runText.trimWhiteSpace.length > 0 && Int(runText)! >= 0  {
                RunsTaken2 = runText
                if let foursScored = foursText2.text {
                    Fours2 = foursScored != "-" && foursScored.length > 0 ? foursScored : "0"
                }
                
                if let sixesScored = sixesText2.text {
                    Sixes2 = sixesScored != "-" && sixesScored.length > 0 ? sixesScored : "0"
                }
                
                if let dismissal = dismissalText2.text {
                    Dismissal2 = dismissal != "-" && dismissal.length > 0 ? dismissal : dismissals[0]
                }
                
                if let position = positionText2.text {
                    Position2 = position != "-" && position.length > 0 ? position : "1"
                }
                
                if let ballsPlayed = ballsPlayedText2.text {
                    BallsFaced2 = ballsPlayed != "-" && ballsPlayed.length > 0 ? ballsPlayed : runText
                }
                
                foursText2.userInteractionEnabled = true
                sixesText2.userInteractionEnabled = true
                positionText2.userInteractionEnabled = true
                dismissalText2.userInteractionEnabled = true
                ballsPlayedText2.userInteractionEnabled = true
            }
            else
            {
                self.view.endEditing(true)
                RunsTaken2 = "-"
                Fours2 = "-"
                Sixes2 = "-"
                Dismissal2 = "-"
                Position2 = "-"
                BallsFaced2 = "-"
                
                // foursText.userInteractionEnabled = false
                // sixesText.userInteractionEnabled = false
                // dismissalText.userInteractionEnabled = false
                // positionText.userInteractionEnabled = false
                // ballsPlayedText.userInteractionEnabled = false
            }
        }

    }
    
    func validateOvers() -> Void {
        if let overText = oversText.text {
            if overText.length > 0 && Float(overText) > 0 {
                bowledOvers = oversText.text
                
                //check the decimal part of OversBowled
                let floatOvers = bowledOvers.componentsSeparatedByString(".")
                if floatOvers.count > 1 {
                    let intOvers = floatOvers[0]
                    var decOvers = "0"
                    if floatOvers[1].length != 0 {
                        decOvers = floatOvers[1]
                    }
                        
                    if decOvers == "0" {
                        bowledOvers = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        bowledOvers = String(newIntOvers)
                    }
                    else {
                        bowledOvers = oversText.text
                    }
                }
                
                if let wides = widesText.text {
                    Wides = wides != "-" && wides.length > 0  ? wides : "0"
                }
                
                if let noball = noballText.text {
                    NoBalls = noball != "-" && noball.length > 0 ? noball : "0"
                }
                
                if let wickets = wicketsText.text {
                    WicketsTaken = wickets != "-" && wickets.length > 0 ? wickets : "0"
                }
                
                if let maidens = maidensText.text {
                    Maidens = maidens != "-" && maidens.length > 0 ? maidens : "0"
                }
                
                if let runsgiven = runsGivenText.text {
                    RunsGiven = runsgiven != "-" && runsgiven.length > 0 ? runsgiven : "0"
                }
                
                widesText.userInteractionEnabled = true
                noballText.userInteractionEnabled = true
                wicketsText.userInteractionEnabled = true
                maidensText.userInteractionEnabled = true
                runsGivenText.userInteractionEnabled = true
            }
            else
            {
                self.view.endEditing(true)
                Wides = "-"
                NoBalls = "-"
                WicketsTaken = "-"
                Maidens = "-"
                RunsGiven = "-"
                bowledOvers = "-"
                
//                widesText.userInteractionEnabled = false
//                noballText.userInteractionEnabled = false
//                wicketsText.userInteractionEnabled = false
//                maidensText.userInteractionEnabled = false
//                runsGivenText.userInteractionEnabled = false
            }
        }
        
        // second innings
        
        if let overText2 = oversText2.text {
            if overText2.length > 0 && Float(overText2) > 0 {
                bowledOvers2 = oversText2.text
                
                //check the decimal part of OversBowled
                let floatOvers2 = bowledOvers2.componentsSeparatedByString(".")
                if floatOvers2.count > 1 {
                    let intOvers = floatOvers2[0]
                    var decOvers = "0"
                    if floatOvers2[1].length != 0 {
                        decOvers = floatOvers2[1]
                    }
                    
                    if decOvers == "0" {
                        bowledOvers2 = intOvers
                    }
                    else if Int(decOvers) > 5 {
                        let newIntOvers = (Int(intOvers) ?? 0) + 1
                        bowledOvers2 = String(newIntOvers)
                    }
                    else {
                        bowledOvers2 = oversText2.text
                    }
                }
                
                if let wides = widesText2.text {
                    Wides2 = wides != "-" && wides.length > 0  ? wides : "0"
                }
                
                if let noball = noballText2.text {
                    NoBalls2 = noball != "-" && noball.length > 0 ? noball : "0"
                }
                
                if let wickets = wicketsText2.text {
                    WicketsTaken2 = wickets != "-" && wickets.length > 0 ? wickets : "0"
                }
                
                if let maidens = maidensText2.text {
                    Maidens2 = maidens != "-" && maidens.length > 0 ? maidens : "0"
                }
                
                if let runsgiven = runsGivenText2.text {
                    RunsGiven2 = runsgiven != "-" && runsgiven.length > 0 ? runsgiven : "0"
                }
                
                widesText2.userInteractionEnabled = true
                noballText2.userInteractionEnabled = true
                wicketsText2.userInteractionEnabled = true
                maidensText2.userInteractionEnabled = true
                runsGivenText2.userInteractionEnabled = true
            }
            else
            {
                self.view.endEditing(true)
                Wides2 = "-"
                NoBalls2 = "-"
                WicketsTaken2 = "-"
                Maidens2 = "-"
                RunsGiven2 = "-"
                bowledOvers2 = "-"
                
                //                widesText.userInteractionEnabled = false
                //                noballText.userInteractionEnabled = false
                //                wicketsText.userInteractionEnabled = false
                //                maidensText.userInteractionEnabled = false
                //                runsGivenText.userInteractionEnabled = false
            }
        }

    }
    
    @IBAction func decrementMaidens(sender: UIButton) {
        self.incrementDecrementOperation(maidensText, isIncrement: false)
    }
    @IBAction func incrementMaidens(sender: UIButton) {
        self.incrementDecrementOperation(maidensText, isIncrement: true)
    }
    @IBAction func incrementPosition(sender: AnyObject) {
        self.incrementDecrementOperation(positionText, isIncrement: true)
    }
    
    @IBAction func decrementPosition(sender: UIButton) {
        self.incrementDecrementOperation(positionText, isIncrement: false)
    }
    @IBAction func incrementWickets(sender: AnyObject) {
        self.incrementDecrementOperation(wicketsText, isIncrement: true)
    }
    
    @IBAction func decrementWickets(sender: AnyObject) {
        self.incrementDecrementOperation(wicketsText, isIncrement: false)
    }
    
    @IBAction func incrementNoBalls(sender: AnyObject) {
        self.incrementDecrementOperation(noballText, isIncrement: true)
    }
    
    @IBAction func decrementNoBalls(sender: AnyObject) {
        self.incrementDecrementOperation(noballText, isIncrement: false)
    }
    
    @IBAction func incrementWides(sender: AnyObject) {
        self.incrementDecrementOperation(widesText, isIncrement: true)
    }
   
    @IBAction func decrementWides(sender: AnyObject) {
        self.incrementDecrementOperation(widesText, isIncrement: false)
    }
    
    @IBAction func incrementSixes(sender: AnyObject) {
        self.incrementDecrementOperation(sixesText, isIncrement: true)
    }
    
    @IBAction func decrementSixes(sender: AnyObject) {
        self.incrementDecrementOperation(sixesText, isIncrement: false)
    }
    
    @IBAction func incrementFours(sender: AnyObject) {
        self.incrementDecrementOperation(foursText, isIncrement: true)
    }
    
    @IBAction func decrementFours(sender: AnyObject) {
        self.incrementDecrementOperation(foursText, isIncrement: false)
    }
    
    @IBAction func incrementCatches(sender: AnyObject) {
        self.incrementDecrementOperation(catchesText, isIncrement: true)
    }
    
    @IBAction func decrementCatches(sender: AnyObject) {
        self.incrementDecrementOperation(catchesText, isIncrement: false)
    }
    
    @IBAction func incrementStumpings(sender: AnyObject) {
        self.incrementDecrementOperation(stumpingsText, isIncrement: true)
    }
    
    @IBAction func decrementStumpings(sender: AnyObject) {
        self.incrementDecrementOperation(stumpingsText, isIncrement: false)
    }
    
    @IBAction func incrementRunouts(sender: AnyObject) {
        self.incrementDecrementOperation(runoutsText, isIncrement: true)
    }
    
    @IBAction func decrementRunouts(sender: AnyObject) {
        self.incrementDecrementOperation(runoutsText, isIncrement: false)
    }
    
    // for second innings
    
    @IBAction func decrementMaidens2(sender: UIButton) {
        self.incrementDecrementOperation(maidensText2, isIncrement: false)
    }
    @IBAction func incrementMaidens2(sender: UIButton) {
        self.incrementDecrementOperation(maidensText2, isIncrement: true)
    }
    @IBAction func incrementPosition2(sender: AnyObject) {
        self.incrementDecrementOperation(positionText2, isIncrement: true)
    }
    
    @IBAction func decrementPosition2(sender: UIButton) {
        self.incrementDecrementOperation(positionText2, isIncrement: false)
    }
    @IBAction func incrementWickets2(sender: AnyObject) {
        self.incrementDecrementOperation(wicketsText2, isIncrement: true)
    }
    
    @IBAction func decrementWickets2(sender: AnyObject) {
        self.incrementDecrementOperation(wicketsText2, isIncrement: false)
    }
    
    @IBAction func incrementNoBalls2(sender: AnyObject) {
        self.incrementDecrementOperation(noballText2, isIncrement: true)
    }
    
    @IBAction func decrementNoBalls2(sender: AnyObject) {
        self.incrementDecrementOperation(noballText2, isIncrement: false)
    }
    
    @IBAction func incrementWides2(sender: AnyObject) {
        self.incrementDecrementOperation(widesText2, isIncrement: true)
    }
    
    @IBAction func decrementWides2(sender: AnyObject) {
        self.incrementDecrementOperation(widesText2, isIncrement: false)
    }
    
    @IBAction func incrementSixes2(sender: AnyObject) {
        self.incrementDecrementOperation(sixesText2, isIncrement: true)
    }
    
    @IBAction func decrementSixes2(sender: AnyObject) {
        self.incrementDecrementOperation(sixesText2, isIncrement: false)
    }
    
    @IBAction func incrementFours2(sender: AnyObject) {
        self.incrementDecrementOperation(foursText2, isIncrement: true)
    }
    
    @IBAction func decrementFours2(sender: AnyObject) {
        self.incrementDecrementOperation(foursText2, isIncrement: false)
    }
    
    
    var BattingData:[String:String]{
        
        if (parent?.matchVC.matchFormat.text)! == "Single Innings" {
            return ["RunsTaken":RunsTaken,"BallsFaced":BallsFaced,"Fours":Fours,"Sixes":Sixes,"Position":Position,"Dismissal":Dismissal]
        }
        else {
            return ["RunsTaken":RunsTaken,"BallsFaced":BallsFaced,"Fours":Fours,"Sixes":Sixes,"Position":Position,"Dismissal":Dismissal,"RunsTaken2":RunsTaken2,"BallsFaced2":BallsFaced2,"Fours2":Fours2,"Sixes2":Sixes2,"Position2":Position2,"Dismissal2":Dismissal2]
        }
    }
    
    func loadEditData(){
        runsText.textVal = parent!.selecetedData!["RunsTaken"]! as! String
        ballsPlayedText.textVal = parent!.selecetedData!["BallsFaced"]! as! String
        foursText.textVal = parent!.selecetedData!["Fours"]! as! String
        sixesText.textVal = parent!.selecetedData!["Sixes"]! as! String
        strikeRateText.textVal = parent!.selecetedData!["Ground"]! as! String
        positionText.textVal = parent!.selecetedData!["Position"]! as! String
        dismissalText.textVal = parent!.selecetedData!["Dismissal"]! as! String
        
        oversText.textVal = parent!.selecetedData!["OversBowled"]! as! String
        wicketsText.textVal = parent!.selecetedData!["WicketsTaken"]! as! String
        runsGivenText.textVal = parent!.selecetedData!["RunsGiven"]! as! String
        noballText.textVal = parent!.selecetedData!["NoBalls"]! as! String
        widesText.textVal = parent!.selecetedData!["Wides"]! as! String
        maidensText.textVal = parent!.selecetedData!["Maidens"] as! String
        
        // second innings
        if parent!.selecetedData!["MatchFormat"] as? String == "Double Innings" && parent!.selecetedData!["MatchFormat"]  != nil {
        
            runsText2.textVal = parent!.selecetedData!["RunsTaken2"]! as! String
            ballsPlayedText2.textVal = parent!.selecetedData!["BallsFaced2"]! as! String
            foursText2.textVal = parent!.selecetedData!["Fours2"]! as! String
            sixesText2.textVal = parent!.selecetedData!["Sixes2"]! as! String
            positionText2.textVal = parent!.selecetedData!["Position2"]! as! String
            dismissalText2.textVal = parent!.selecetedData!["Dismissal2"]! as! String
            
            oversText2.textVal = parent!.selecetedData!["OversBowled2"]! as! String
            wicketsText2.textVal = parent!.selecetedData!["WicketsTaken2"]! as! String
            runsGivenText2.textVal = parent!.selecetedData!["RunsGiven2"]! as! String
            noballText2.textVal = parent!.selecetedData!["NoBalls2"]! as! String
            widesText2.textVal = parent!.selecetedData!["Wides2"]! as! String
            maidensText2.textVal = parent!.selecetedData!["Maidens2"]! as! String
        }
        
        if parent!.selecetedData!["FieldingRole"]  != nil {
            roleText.textVal = parent!.selecetedData!["FieldingRole"] as! String
        }
        if parent!.selecetedData!["Catches"] != nil {
            catchesText.textVal = parent!.selecetedData!["Catches"] as! String
        }
        if parent!.selecetedData!["Stumpings"] != nil {
            stumpingsText.textVal = parent!.selecetedData!["Stumpings"] as! String
        }
        if parent!.selecetedData!["Runouts"] != nil {
        runoutsText.textVal = parent!.selecetedData!["Runouts"] as! String
        }

    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        oversText.resignFirstResponder()
        runsGivenText.resignFirstResponder()
        
        let matchVCInstance = parent?.matchVC
        let matchFormat = matchVCInstance?.matchFormat.text
        
        if matchFormat! == "Single Innings" || matchFormat! == "" {
          secondInningsViewHeightConstraint.constant = 0
          secondInningsView.hidden = true
          baseView.constant = 736
        }
        else {
            secondInningsViewHeightConstraint.constant = 484
            secondInningsView.hidden = false
            baseView.constant = 1220
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        runsText.errorColor = UIColor.redColor()
        if ((parent?.selecetedData) != nil){ loadEditData() }
        
        setColorForViewsWithSameTag(lineView)
        setColorForViewsWithSameTag(battingDetailsLabel)
        
        //setBackgroundColor()
        self.view.backgroundColor = UIColor.clearColor()
        //setUIBackgroundTheme(self.view)
        // Do any additional setup after loading the view.
        
        bowledOvers = (parent?.selecetedData?["OversBowled"] ?? "-") as! String
        WicketsTaken = (parent?.selecetedData?["WicketsTaken"] ?? "-") as! String
        RunsGiven = (parent?.selecetedData?["RunsGiven"] ?? "-") as! String
        NoBalls = (parent?.selecetedData?["NoBalls"] ?? "-") as! String
        Wides = (parent?.selecetedData?["Wides"] ?? "-") as! String
        Maidens = (parent?.selecetedData?["Maidens"] ?? "-") as! String
        
        RunsTaken = (parent?.selecetedData?["RunsTaken"] ?? "-") as! String
        BallsFaced = (parent?.selecetedData?["BallsFaced"] ?? "-") as! String
        Fours = (parent?.selecetedData?["Fours"] ?? "-") as! String
        Sixes = (parent?.selecetedData?["Sixes"] ?? "-") as! String
        Position = (parent?.selecetedData?["Position"] ?? "-") as! String
        Dismissal = (parent?.selecetedData?["Dismissal"] ?? "-") as! String
        
        
        
        
        dismissalText.delegate = self
        runsText.delegate = self
        oversText.delegate = self
        oversText.keyboardType = UIKeyboardType.DecimalPad
        ballsPlayedText.delegate = self
        foursText.delegate = self
        sixesText.delegate = self
        strikeRateText.delegate = self
        positionText.delegate = self
        wicketsText.delegate = self
        noballText.delegate = self
        widesText.delegate = self
        maidensText.delegate = self
        runsGivenText.delegate = self
        
        //second innings
        
        bowledOvers2 = (parent?.selecetedData?["OversBowled2"] ?? "-") as! String
        WicketsTaken2 = (parent?.selecetedData?["WicketsTaken2"] ?? "-") as! String
        RunsGiven2 = (parent?.selecetedData?["RunsGiven2"] ?? "-") as! String
        NoBalls2 = (parent?.selecetedData?["NoBalls2"] ?? "-") as! String
        Wides2 = (parent?.selecetedData?["Wides2"] ?? "-") as! String
        Maidens2 = (parent?.selecetedData?["Maidens2"] ?? "-") as! String
        
        RunsTaken2 = (parent?.selecetedData?["RunsTaken2"] ?? "-") as! String
        BallsFaced2 = (parent?.selecetedData?["BallsFaced2"] ?? "-") as! String
        Fours2 = (parent?.selecetedData?["Fours2"] ?? "-") as! String
        Sixes2 = (parent?.selecetedData?["Sixes2"] ?? "-") as! String
        Position2 = (parent?.selecetedData?["Position2"] ?? "-") as! String
        Dismissal2 = (parent?.selecetedData?["Dismissal2"] ?? "-") as! String
        
        dismissalText2.delegate = self
        runsText2.delegate = self
        oversText2.delegate = self
        oversText2.keyboardType = UIKeyboardType.DecimalPad
        ballsPlayedText2.delegate = self
        foursText2.delegate = self
        sixesText2.delegate = self
        positionText2.delegate = self
        wicketsText2.delegate = self
        noballText2.delegate = self
        widesText2.delegate = self
        maidensText2.delegate = self
        runsGivenText2.delegate = self
        
        
        roleText.delegate = self
        catchesText.delegate = self
        stumpingsText.delegate = self
        runoutsText.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "BATTING & BOWLING")
    }
    
    func incrementDecrementOperation(controlText: UITextField, isIncrement: Bool) {
        if isIncrement {
            if controlText == foursText || controlText == sixesText || controlText == maidensText || controlText == widesText || controlText == noballText || controlText == foursText2 || controlText == sixesText2 || controlText == maidensText2 || controlText == widesText2 || controlText == noballText2 {
                if let currentValue = Int(controlText.text!) {
                    if currentValue < 999 {
                        controlText.text = String(currentValue + 1)
                    }
                }
                else
                {
                    controlText.text = String(1)
                }
            }
            else if controlText == positionText || controlText == wicketsText || controlText == positionText2 || controlText == wicketsText2 {
                if let currentValue = Int(controlText.text!) {
                    if currentValue < 15 {
                        controlText.text = String(currentValue + 1)
                    }
                }
                else
                {
                    controlText.text = String(1)
                }
            }
            
            else if controlText == catchesText || controlText == runoutsText || controlText == stumpingsText {
                if let currentValue = Int(controlText.text!) {
                    if currentValue < 99 {
                        controlText.text = String(currentValue + 1)
                    }
                }
                else
                {
                    controlText.text = String(1)
                }
            }
        }
        else
        {
            if let currentValue = Int(controlText.text!) {
                if controlText == positionText || controlText == positionText2 {
                    if currentValue > 1 {
                        controlText.text = String(currentValue - 1)
                    }
                }
                else if currentValue > 0 {
                    controlText.text = String(currentValue - 1)
                }
            }
            else
            {
                if controlText == positionText || controlText == positionText2 {
                    controlText.text = String(1)
                }
                else {
                controlText.text = String(0)
                }
            }
        }
        
        textFieldDidEndEditing(controlText)
    }

}




extension BattingBowlingViewController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.selectedText = textField
        
        if textField.accessibilityIdentifier == "textWithNumPad" {
            AddDoneButtonTo(textField)
        }
        
        if textField == oversText  {
           animateViewMoving(true, moveValue: 140)
        }
         if textField == runsGivenText {
           animateViewMoving(true, moveValue: 210)
        }
        
        if textField == dismissalText || textField == dismissalText2 {
           // addSuggstionBox(textField, dataSource: dismissals, showSuggestions: true)
            showPicker(self, inputText: textField, data: dismissals)
        }
        
        if textField == roleText {
            showPicker(self, inputText: textField, data: fieldingRole)

        }
        
       // parent?.dataChangedAfterLastSave()
        //textFieldDidEndEditing(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField){
       
        if textField == oversText  {
            animateViewMoving(false, moveValue: 140)
        }
        if textField == runsGivenText {
            animateViewMoving(false, moveValue: 210)
        }
        if textField == positionText || textField == positionText2 {
            if positionText.text == "0" || positionText.text == "00"  {
                positionText.text = "1"
            }
            if positionText2.text == "0" || positionText2.text == "00"  {
                positionText2.text = "1"
            }
        }

        if textField.tag == 1 {
            ValidateScore()
            
//            if textField.text?.trimWhiteSpace.length > 0{
//              //  parent?.dataChangedAfterLastSave()
//            }
        }
        else if textField.tag == 2 {
            validateOvers()
            
//            if textField.text?.trimWhiteSpace.length > 0{
//              //  parent?.dataChangedAfterLastSave()
//            }
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

    func AddDoneButtonTo(inputText:UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(BattingBowlingViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(BattingBowlingViewController.donePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        selectedText.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newlength = (textField.text!.characters.count) + string.characters.count - range.length
        
        //batting details
        if textField == runsText || textField == ballsPlayedText || textField == runsText2 || textField == ballsPlayedText2 {
            return newlength <= 4
        }
        else if textField == foursText || textField == sixesText || textField == foursText2 || textField == sixesText2 {
            return newlength <= 3
        }
        else if textField == positionText || textField == positionText2 {
            
            return newlength <= 2
        }
         // bowling details
        else if textField == oversText || textField == oversText2 {
            return newlength <= 5
        }
        else if textField == runsGivenText || textField == maidensText || textField == noballText || textField == widesText || textField == runsGivenText2 || textField == maidensText2 || textField == noballText2 || textField == widesText2 {
            return newlength <= 3
        }
        else if textField == wicketsText || textField == wicketsText2 {
            return newlength <= 2
        }
        else if textField == dismissalText || textField == dismissalText2 {
            return false
        }
        else if textField == roleText  {
            return false
        }
        else if textField == catchesText {
            return newlength <= 2
        }
        else if textField == stumpingsText {
            return newlength <= 2
        }
        else if textField == runoutsText {
            return newlength <= 2
        }
        else {
            return true
        }
    }
}
