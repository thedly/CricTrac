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

class AddMatchDetailsViewController: ButtonBarPagerTabStripViewController  {

    var matchVC:MatchViewController!
    var battingVC:BattingViewController!
    var bowlingVC:BowlingViewController!
    var extraVC:ExtraViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
        settings.style.buttonBarItemTitleColor = UIColor(hex: "#667815")
        buttonBarView.selectedBar.backgroundColor = UIColor(hex: "#B12420")
        settings.style.buttonBarItemFont = UIFont(name: "SFUIText-Regular", size: 15)!
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
            KRProgressHUD.dismiss()
        }
        
        
    }
    
    
    @IBAction func DidtapCancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {}
    }
    
    
    @IBAction func didTapSave(sender: UIButton) {
        
        
        if validateMatchDetails(){
            
            var data = [String:String]()
            if let _ = matchVC?.view{
                
                data += matchVC.data
            }
            if let _ = battingVC?.view{
                
                data += battingVC.data
            }
            if let _ = bowlingVC?.view{
                
                data += bowlingVC.data
            }
            if let _ = extraVC?.view{
                
                data += extraVC.data
            }

            let teamName = data["Team"]!
            if !teamNames.contains(teamName){
                addNewTeamName(teamName)
            }
            
            let oppoTeamName = data["Team"]!
            if !opponentTeams.contains(oppoTeamName){
                addNewOppoSitTeamName(oppoTeamName)
            }
            
            let groundName = data["Ground"]!
            
            if groundName != "NA"{
            
            if !groundNames.contains(groundName){
                addNewGroundName(groundName)
                }
            }
            
            //OppositTeams
            
            addMatchData("date \(String(date))",data: data)
            self.dismissViewControllerAnimated(true) {}
    
        }
        
    }
    
   
    
    override  func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        matchVC = viewControllerFrom("Main", vcid: "MatchViewController") as! MatchViewController
        
        battingVC = viewControllerFrom("Main", vcid: "BattingViewController") as! BattingViewController
        
        bowlingVC = viewControllerFrom("Main", vcid: "BowlingViewController") as! BowlingViewController
        
         extraVC = viewControllerFrom("Main", vcid: "ExtraViewController") as! ExtraViewController
        
        return [matchVC, battingVC,bowlingVC,extraVC]
    }

    
    
    func validateMatchDetails()->Bool{
        
        var pageName = ""
        
        if matchVC.allRequiredFieldsHaveNotFilledProperly{
            
           pageName = "Match Details"
        }
        else{
            return true
        }
        
         SCLAlertView().showWarning("Error", subTitle: "Some Fields are not filled properly in \(pageName). Plaese fill it and try saving")
        
        return false
    }
    
    func validateBattingInfo()->Bool{
        
        return false
    }
    func validateBawlingInfo()->Bool{
        
        return false
    }
    
    func validateExtraInfo()->Bool{
        
        return false
    }
    
    func validateBasicInfo()->Bool{
        
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
