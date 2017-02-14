//
//  AddMatchDetailsViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/5/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SCLAlertView
import KRProgressHUD

class AddMatchDetailsViewController: ButtonBarPagerTabStripViewController,MatchParent,ThemeChangeable  {
    
    var matchVC:MatchViewController!
    
    var battingBowlingViewController: BattingBowlingViewController!
    
    var resVC: MatchResultsViewController!
    
    var selecetedData:[String:AnyObject]?
    
    @IBOutlet weak var saveButton:UIButton!
    
    var dataHasChangedAfterLastSave = false
    var dataAdded = false
    var data = [String:String]()
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.boxColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        dataHasChangedAfterLastSave = false
        //setUIBackgroundTheme(self.view)
        setBackgroundColor()
    }
    
    func dataChangedAfterLastSave(){
        
        dataHasChangedAfterLastSave = true
        saveButton.setTitle("Save", forState: .Normal)
    }
    
    
    
    
    func getUserData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllUserData { (userData) in
            
            if let grounds = userData["Grounds"] as? [String:String]{
                
                groundNames = grounds.map({ (key,value) in value })
                
            }
            
            if let venue = userData["Venue"] as? [String: String]{
                venueNames = venue.map({ (key, value) in value })
            }
            
            if let grounds = userData["Teams"] as? [String:String]{
                
                teamNames = grounds.map({ (key,value) in value })
                
            }
            
            if let grounds = userData["Opponents"] as? [String:String]{
                
                opponentTeams = grounds.map({ (key,value) in value })
                
            }
            
            if let tournamnet = userData["Tournaments"] as? [String:String]{
                
                tournaments = tournamnet.map({ (key,value) in value })
            }
            KRProgressHUD.dismiss()
        }
        
        
    }
    
    
    @IBAction func DidtapCancelButton(sender: AnyObject) {
        
        if dataHasChangedAfterLastSave || dataAdded {
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("OK", target:self, selector:#selector(AddMatchDetailsViewController.continueToDismiss))
            
            alertView.addButton("Cancel", action: { })
            
            alertView.showNotice("Warning", subTitle: "All Data will be lost if you continue")
            
            
        }
        else{
            
            self.dismissViewControllerAnimated(true) {}
        }
        
    }
    
    
    func continueToDismiss(){
        
        self.dismissViewControllerAnimated(true) {}
    }
    
    
    @IBAction func didTapSave(sender: UIButton) {
        
        
        if validateMatchDetails() {
            
            
            if dataHasChangedAfterLastSave{
            
            if let _ =  matchVC?.view{
                
                data += matchVC.data
            }
            if let _ = battingBowlingViewController?.view{
                
                data += battingBowlingViewController.BattingData
                data += battingBowlingViewController.BowlingData
            }
            if let _ = resVC?.view{
               data += resVC.data
            }
        }
           
            var groundName = "-"
            
            if let ground = data["Ground"] {
                groundName = ground
            }
            
            var venueName = "-"
          
            if let venue = data["Venue"] {
                venueName = venue
            }
            
            //OppositTeams
            if !dataHasChangedAfterLastSave {
                if selecetedData == nil{
                    
                    addMatchData("date \(String(date))",data: data, callback: { dat in
                        
                        let teamName = self.data["Team"]!
                        if !teamNames.contains(teamName){
                            addNewTeamName(teamName)
                            teamNames.append(teamName)
                        }
                        
                        let oppoTeamName = self.data["Opponent"]!
                        if !opponentTeams.contains(oppoTeamName){
                            addNewOppoSitTeamName(oppoTeamName)
                            opponentTeams.append(oppoTeamName)
                        }
                        
                        let tournament = self.data["Tournament"]!
                        
                        if tournament != "-"{
                            if !tournaments.contains(tournament){
                                addNewTournamentName(tournament)
                                tournaments.append(tournament)
                            }
                        }
                        if groundName != "-"{
                            
                            if !groundNames.contains(groundName){
                                addNewGroundName(groundName)
                                groundNames.append(groundName)
                            }
                        }
                        if venueName != "-"{
                            
                            if !venueNames.contains(venueName){
                                addNewVenueName(venueName)
                                venueNames.append(venueName)
                            }
                        }
                        
                        
                        let window = getCurrentWindow()
                        
                        let DetailsViewController = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
                        
                        
                        DetailsViewController.battingViewHidden = (dat["RunsTaken"] as! String == "-")
                        DetailsViewController.bowlingViewHidden = (dat["RunsGiven"] as! String == "-")
                        
                        DetailsViewController.matchDetailsData = dat
                        window.rootViewController?.dismissViewControllerAnimated(false, completion: {
                            window.rootViewController?.presentViewController(DetailsViewController, animated: true, completion: nil)
                        })

                        
                    })
                    
                    
                    
                    
                }else{
                    
                    var key = ""
                    
                    if let keyValue = selecetedData!["key"] {
                     
                        key = keyValue as! String
                        
                    }
                    
                    if let keyValueAlt = selecetedData!["MatchId"] {
                        if key == "" {
                            key = keyValueAlt as! String
                        }
                        
                    }
                    
                    if key != "" {
                        updateMatchData(key, data: data, callback: { dat in
                            
                            var dataToBeModified = dat
                            
                            
                            dataToBeModified["MatchId"] = key
                            dataToBeModified["key"] = key
                            
                            
                            if let previousVC = getPreviousViewController(self) as? SummaryMatchDetailsViewController {
                                
                                previousVC.matchDetailsData = dataToBeModified
                                previousVC.viewDidLoad()
                                
                                
                                if let previousPreviousVC = getPreviousViewController(previousVC) as? MatchSummaryViewController {
                                    
                                    if let index = previousPreviousVC.matchDataSource.indexOf({ $0["MatchId"] as? String == self.selecetedData!["key"] as? String }) {
                                        
                                        
                                        let newSummaryData = previousPreviousVC.makeSummaryCell(dataToBeModified)
                                        
                                        
                                        previousPreviousVC.matches.removeAtIndex(index)
                                        previousPreviousVC.matches.insert(newSummaryData, atIndex: index)
                                        
                                        previousPreviousVC.matchSummaryTable.reloadData()
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            //                        var dataToBeModeified = dat
                            //
                            //                        dataToBeModeified["MatchId"] = self.selecetedData!["key"]!
                            //
                            //                        let matchObjectIndex = matchDataSource.indexOfObject(self.selecetedData!)
                            //
                            //                        matchDataSource.replaceObjectAtIndex(matchObjectIndex, withObject: dataToBeModeified)
                            //
                            //  
                            NSNotificationCenter.defaultCenter().postNotificationName("MatchDataChanged", object: self)
                            self.dismissViewControllerAnimated(true) {}
                            
                        })
                    }
                    
                    
                    
                    

                    
                    
                    
                }
                
                
                
                
                
            }
            else{
                
                saveButton.setTitle("Done", forState: .Normal)
                dataHasChangedAfterLastSave = false
            }
            
            dataAdded = true
        }
        
    }
    
    
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        matchVC = viewControllerFrom("Main", vcid: "MatchViewController") as! MatchViewController
        
//        battingVC = viewControllerFrom("Main", vcid: "BattingViewController") as! BattingViewController
//        
//        bowlingVC = viewControllerFrom("Main", vcid: "BowlingViewController") as! BowlingViewController
        
        battingBowlingViewController = viewControllerFrom("Main", vcid: "BattingBowlingViewController") as! BattingBowlingViewController
        
        //extraVC = viewControllerFrom("Main", vcid: "ExtraViewController") as! ExtraViewController
        
        resVC = viewControllerFrom("Main", vcid: "MatchResultsViewController") as! MatchResultsViewController
        
        //extraVC.matchDetails = matchVC
        matchVC.parent = self
        battingBowlingViewController.parent = self
        resVC.parent = self
        return [matchVC, battingBowlingViewController,resVC]
    }
    
    
    
    func validateMatchDetails()->Bool{
        
        var pageName = ""
        
        if matchVC.allRequiredFieldsHaveNotFilledProperly{
            
            pageName = "Match Details"
        }
        else if !battingBowlingViewController.allRequiredFieldsHaveFilledProperly {
            pageName = "Batting and Bowling Details"
        }
        else{
            return true
        }
        
        SCLAlertView().showWarning("Error", subTitle: "Some Fields are not filled properly in \(pageName). Plaese fill it and try saving")
        
        return false
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
