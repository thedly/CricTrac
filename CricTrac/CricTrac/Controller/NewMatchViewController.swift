//
//  NewMatchViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/23/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class NewMatchViewController: UIViewController {

    @IBOutlet weak var dateTest: UITextField!
    
    @IBOutlet weak var datePickerButton:UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var teamText: UITextField!
    
    @IBOutlet weak var teamLabel: UILabel!
    
    @IBOutlet weak var opponentText: UITextField!
    
    @IBOutlet weak var opponentLabel: UILabel!
    
    @IBOutlet weak var groundText: UITextField!
    
    @IBOutlet weak var groundLabel: UILabel!
    
    @IBOutlet weak var OversText: UITextField!
    
    @IBOutlet weak var OversLabel: UILabel!
    
    @IBOutlet weak var tournamnetText: UITextField!
    
    @IBOutlet weak var tournamentLabel: UILabel!
    
    @IBOutlet weak var dismissText: UITextField!
    
    @IBOutlet weak var dismissLabel: UILabel!
    
    
    @IBOutlet weak var extraOverText: UITextField!
    
    @IBOutlet weak var extraOverLabel: UILabel!
    
    @IBOutlet weak var wicketsText: UITextField!
    
    @IBOutlet weak var wicketLabel: UILabel!
    
    @IBOutlet weak var resultsText: UITextField!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var commentsText: UITextView!
    
    @IBOutlet weak var matchWonSwitch: UISwitch!
    
    
    @IBOutlet weak var matchSelector: UIView!
    
    @IBOutlet weak var bowlingSelector: UIView!
    
   
    @IBOutlet weak var extraSelector: UIView!
    
    @IBOutlet weak var battingSelector: UIView!
    
    var lastSelectedTab:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedTab = matchSelector
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func didTapCancel(sender: UIButton) {
        
        dismissViewControllerAnimated(true) {}
    }

    
    @IBAction func didTapMatch(sender: AnyObject) {
        matchSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = matchSelector
        
        datePickerButton.hidden = false
        dateLabel.text = "Date:"
        teamLabel.text = "Team:"
        opponentLabel.text = "Opponent:"
        groundLabel.text = "Ground:"
        OversLabel.text = "Overs:"
        tournamentLabel.text = "Tournament:"
        dismissLabel.hidden = true
        dismissText.hidden = true
        
        extraOverLabel.hidden = true
        extraOverText.hidden = true
        wicketLabel.hidden = true
        resultsLabel.hidden = true
        resultsText.hidden = true
        matchWonSwitch.hidden = true
        commentsText.hidden = true
        commentsLabel.hidden = true
    }
  
    
    @IBAction func didTapBat(sender: AnyObject){
        battingSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = battingSelector
        
        datePickerButton.hidden = true
        dateLabel.text = "Runs:"
        teamLabel.text = "Balls:"
        opponentLabel.text = "4S:"
        groundLabel.text = "6S:"
        OversLabel.text = "Strike Rate:"
        tournamentLabel.text = "Position:"
        dismissLabel.hidden = false
        dismissText.hidden = false
        
        extraOverLabel.hidden = true
        extraOverText.hidden = true
        wicketLabel.hidden = true
        resultsLabel.hidden = true
        resultsText.hidden = true
        matchWonSwitch.hidden = true
        commentsText.hidden = true
        commentsLabel.hidden = true
    }
    
    
    @IBAction func didTapBowl(sender: AnyObject) {
        bowlingSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = bowlingSelector
        
        datePickerButton.hidden = true
        dateLabel.text = "Overs:"
        teamLabel.text = "Wickets:"
        opponentLabel.text = "Runs:"
        groundLabel.text = "No Balls:"
        OversLabel.text = "Wides:"
        tournamentLabel.text = "Economy:"
        dismissLabel.hidden = true
        dismissText.hidden = true
        
        extraOverLabel.hidden = true
        extraOverText.hidden = true
        wicketLabel.hidden = true
        resultsLabel.hidden = true
        resultsText.hidden = true
        matchWonSwitch.hidden = true
        commentsText.hidden = true
        commentsLabel.hidden = true
    }
    
    
    @IBAction func didTapExtra(sender: AnyObject) {
        extraSelector.hidden = false
        lastSelectedTab?.hidden = true
        lastSelectedTab = extraSelector
        
        datePickerButton.hidden = true
        dateLabel.text = "Toss:"
        teamLabel.text = "First Batting:"
        opponentLabel.text = "Score:"
        groundLabel.text = "Over:"
        OversLabel.text = "Wickets:"
        tournamentLabel.text = "Second Batting:"
        dismissLabel.hidden = false
        dismissText.hidden = false
        dismissLabel.text = "Score"
        extraOverLabel.hidden = false
        extraOverText.hidden = false
        wicketLabel.hidden = false
        resultsLabel.hidden = false
        resultsText.hidden = false
        matchWonSwitch.hidden = false
        commentsText.hidden = false
        commentsLabel.hidden = false
        
    }
    
    func hideAllSelectors(){
        matchSelector.hidden = true
        battingSelector.hidden = true
        bowlingSelector.hidden = true
        extraSelector.hidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
