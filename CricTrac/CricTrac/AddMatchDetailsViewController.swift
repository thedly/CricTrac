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
        self.view.backgroundColor = currentTheme.topColor
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        self.buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.buttonBarView.frame.size.height = 40
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        dataHasChangedAfterLastSave = false
        //setUIBackgroundTheme(self.view)
        setBackgroundColor()
        setNavigationBarProperties()
    }
    
    func dataChangedAfterLastSave(){
        
        dataHasChangedAfterLastSave = true
        let button = navigationItem.rightBarButtonItem
        let myBtn : UIButton?
        if((button!.customView?.isKindOfClass(UIButton)) != nil)
        {
            myBtn = button!.customView as? UIButton
            myBtn!.setTitle("SAVE", forState: .Normal)
        }
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
          if selecetedData == nil{
            menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
            menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
            title = "ADD MATCH"

          }else {
            menuButton.setImage(UIImage(named: "Back"), forState: UIControlState.Normal)
            menuButton.addTarget(self, action: #selector(popBack), forControlEvents: UIControlEvents.TouchUpInside)
            title = "EDIT MATCH"

        }
       
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("SAVE", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
        addNewMatchButton.addTarget(self, action: #selector(didTapSave), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        //let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    func popBack()  {
        self.navigationController?.popViewControllerAnimated(true)
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
                
                let button = navigationItem.rightBarButtonItem
                //(navigationItem.rightBarButtonItem.customView.subviews.lastObject)
                let myBtn : UIButton?
                if((button!.customView?.isKindOfClass(UIButton)) != nil)
                {
                    myBtn = button!.customView as? UIButton
                    myBtn!.setTitle("DONE", forState: .Normal)
                    
                }
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
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
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
