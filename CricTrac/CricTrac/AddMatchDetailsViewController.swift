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

class AddMatchDetailsViewController: ButtonBarPagerTabStripViewController,MatchParent  {
    
    var matchVC:MatchViewController!
    
    var battingBowlingViewController: BattingBowlingViewController!
    
    var resVC: MatchResultsViewController!
    
    var selecetedData:[String:String]?
    
    @IBOutlet weak var saveButton:UIButton!
    
    var dataHasChangedAfterLastSave = false
    var dataAdded = false
    var data = [String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        dataHasChangedAfterLastSave = false
        setUIBackgroundTheme(self.view)
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
            
            if let grounds = userData["Teams"] as? [String:String]{
                
                teamNames = grounds.map({ (key,value) in value })
                
            }
            
            if let grounds = userData["OppositTeams"] as? [String:String]{
                
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
            
            if  matchVC?.view != nil{
                
                data += matchVC.data
            }
            if battingBowlingViewController?.view != nil{
                
                data += battingBowlingViewController.BattingData
                data += battingBowlingViewController.BowlingData
            }
            if resVC?.view != nil{
               data += resVC.data
            }
        }
           
            var groundName = "-"
            
            if let ground = data["Ground"] {
                groundName = ground
            }
            
          
            
            //OppositTeams
            if !dataHasChangedAfterLastSave {
                if selecetedData == nil{
                    addMatchData("date \(String(date))",data: data)
                    
                    let teamName = data["Team"]!
                    if !teamNames.contains(teamName){
                        addNewTeamName(teamName)
                        teamNames.append(teamName)
                    }
                    
                    let oppoTeamName = data["Opponent"]!
                    if !opponentTeams.contains(oppoTeamName){
                        addNewOppoSitTeamName(oppoTeamName)
                        opponentTeams.append(oppoTeamName)
                    }
                    
                    let tournament = data["Tournamnet"]!
                    
                    if tournament != "-"{
                        if !tournaments.contains(tournament){
                            addNewTournamnetName(tournament)
                            tournaments.append(tournament)
                        }
                    }
                    if groundName != "-"{
                        
                        if !groundNames.contains(groundName){
                            addNewGroundName(groundName)
                            groundNames.append(groundName)
                        }
                    }
                    
                    
                }else{
                    updateMatchData(selecetedData!["key"]!, data: data)
                    NSNotificationCenter.defaultCenter().postNotificationName("MatchDataChanged", object: self)
                }
                self.dismissViewControllerAnimated(true) {}
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
