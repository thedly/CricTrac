//
//  AddMatchDetailsViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/5/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip
//import SCLAlertView
import KRProgressHUD
import SwiftyStoreKit

class AddMatchDetailsViewController: ButtonBarPagerTabStripViewController,MatchParent,ThemeChangeable  {
    var matchVC:MatchViewController!
    var matchBeingEdited = false
    var battingBowlingViewController: BattingBowlingViewController!
    var resVC: MatchResultsViewController!
    var matchId:String?
    var selecetedData:[String:AnyObject]?
    var previous:previousRefershable?
    
    @IBOutlet weak var saveButton:UIButton!
    
    var dataHasChangedAfterLastSave = false
    var dataAdded = false
    var data = [String:String]()
    
    var userProfileData:Profile!
    var inAppProductPrice : String?
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileData = profileData
        //self.fetchProductInfo()
        
        //check Player Status
        if userProfileData.UserStatus != "Premium" {
            let userID = currentUser?.uid
            //get total match count
            fireBaseRef.child("Users").child(userID!).child("Matches").observeSingleEventOfType(.Value, withBlock: { snapshot in
                let matchCount = snapshot.childrenCount
                if matchCount >= 5 {
                    //In App Purchase
                    self.fetchProductInfo()
                }
            })
        }
        
        getUserData()
        if matchBeingEdited{
            if let val = selecetedData!["MatchId"] as? String{
                matchId = val
            }
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor()
        settings.style.buttonBarItemTitleColor = UIColor.whiteColor()
        
        buttonBarView.selectedBar.backgroundColor = UIColor.whiteColor()
        self.buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.buttonBarView.frame.size.height = 40
        settings.style.buttonBarItemFont = UIFont(name: appFont_bold, size: 15)!
        //dataHasChangedAfterLastSave = false
        //setUIBackgroundTheme(self.view)
        setBackgroundColor()
        setNavigationBarProperties()
       // containerView.setContentOffset(CGPointMake(pageOffsetForChildIndex(index: 0), -64), animated: true)
       // containerView.setContentOffset(CGPointMake(pageOffsetForChildIndex(index: 1), -64), animated: true)
       // containerView.setContentOffset(CGPointMake(pageOffsetForChildIndex(index: 2), -64), animated: true)
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
          }
          else {
            menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
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
            
            if let teams = userData["Teams"] as? [String:String]{
                teamNames = teams.map({ (key,value) in value })
            }
            
            if let opponents = userData["Opponents"] as? [String:String]{
                opponentTeams = opponents.map({ (key,value) in value })
            }
            
            if let tournamnet = userData["Tournaments"] as? [String:String]{
                tournaments = tournamnet.map({ (key,value) in value })
            }
            KRProgressHUD.dismiss()
        }
    }
    
//    @IBAction func DidtapCancelButton(sender: AnyObject) {
//        if dataHasChangedAfterLastSave || dataAdded {
//            let appearance = SCLAlertView.SCLAppearance(
//                showCloseButton: false
//            )
//            
//            let alertView = SCLAlertView(appearance: appearance)
//           
//            alertView.addButton("OK", target:self, selector:#selector(AddMatchDetailsViewController.continueToDismiss))
//            alertView.addButton("Cancel", action: { })
//            alertView.showNotice("Warning", subTitle: "All data will be lost if you continue")
//        }
//        else{
//           // self.dismissViewControllerAnimated(true) {}
//            moveToMatchSummary()
//        }
//    }
    
    func continueToDismiss(){
       // self.dismissViewControllerAnimated(true) {}
        moveToMatchSummary()
    }
    
    @IBAction func didTapSave(sender: UIButton) {
        /*if matchBeingEdited {
            dataHasChangedAfterLastSave = false
        }*/
        
        if validateMatchDetails() {
//          if dataHasChangedAfterLastSave || matchBeingEdited == true {
                data.removeAll()
                    
                if let _ =  matchVC?.view{
                    data += matchVC.data
                }
                    
                if let _ = battingBowlingViewController?.view {
                    data += battingBowlingViewController.BattingData
                    data += battingBowlingViewController.BowlingData
                }
                    
                if let _ = resVC?.view{
                   data += resVC.data
                }
//          }
           
            if let val =  data["FirstBatting"] where val == ""{
                data["FirstBatting"] =  data["Team"]
            }
                
            if let val =  data["SecondBatting"] where val == ""{
                data["SecondBatting"] =  data["Opponent"]
            }
                
            if let val =  data["TossWonBy"] where val == "-"{
                data["TossWonBy"] =  data["Team"]
            }
                
            if let val =  data["Result"] where val == "-"{
                data["Result"] =  "Won"
            }
                
            //sajith - if condition moved from top
//            if matchBeingEdited {
//                dataHasChangedAfterLastSave = false
//            }
            
            //if !dataHasChangedAfterLastSave {
            
            if !matchVC.teamOROpponentFieldChanged {
                if resVC.swapBtnVal == 0 {
                    if data["Team"] == resVC.existFB {
                        data["FirstBatting"]  = data["Team"]
                        data["SecondBatting"] = data["Opponent"]
                    }
                    else {
                        data["FirstBatting"]  = data["Opponent"]
                        data["SecondBatting"] = data["Team"]
                    }
                }
                else {
                    if data["Team"] == resVC.existFB {
                        data["FirstBatting"]  = data["Opponent"]
                        data["SecondBatting"] = data["Team"]
                        
                    }
                    else {
                        data["FirstBatting"]  = data["Team"]
                        data["SecondBatting"] = data["Opponent"]
                    }
                }
            }
            else {
                if resVC.swapBtnVal == 0 {
                    if matchVC.existTeamName == resVC.existFB {
                        data["FirstBatting"]  = data["Team"]
                        data["SecondBatting"] = data["Opponent"]
                    }
                    else {
                        data["FirstBatting"]  = data["Opponent"]
                        data["SecondBatting"] = data["Team"]
                    }
                    
                    //data["TossWonBy"] = data["Team"]
                }
                else {
                    if matchVC.existTeamName == resVC.existFB {
                        data["FirstBatting"]  = data["Opponent"]
                        data["SecondBatting"] = data["Team"]
                    }
                    else {
                        data["FirstBatting"]  = data["Team"]
                        data["SecondBatting"] = data["Opponent"]
                    }
                    //data["TossWonBy"] = data["Opponent"]
                }
            }

            
                if !matchBeingEdited{
                    addMatchData("date \(String(date))",data: data, callback: { dat in
                        self.updateGlobalValues()
                        // self.dismissViewControllerAnimated(true) {}
                        self.moveToMatchSummary()
                    })
                    
                }
                else{
//                    if !matchVC.teamOROpponentFieldChanged {
//                        if resVC.swapBtnVal == 0 {
//                            if data["Team"] == resVC.existFB {
//                                data["FirstBatting"]  = data["Team"]
//                                data["SecondBatting"] = data["Opponent"]
//                            }
//                            else {
//                                data["FirstBatting"]  = data["Opponent"]
//                                data["SecondBatting"] = data["Team"]
//                            }
//                        }
//                        else {
//                            if data["Team"] == resVC.existFB {
//                                data["FirstBatting"]  = data["Opponent"]
//                                data["SecondBatting"] = data["Team"]
//                                
//                            }
//                            else {
//                                data["FirstBatting"]  = data["Team"]
//                                data["SecondBatting"] = data["Opponent"]
//                            }
//                        }
//                    }
//                    else {
//                        if resVC.swapBtnVal == 0 {
//                            if matchVC.existTeamName == resVC.existFB {
//                                data["FirstBatting"]  = data["Team"]
//                                data["SecondBatting"] = data["Opponent"]
//                            }
//                            else {
//                                data["FirstBatting"]  = data["Opponent"]
//                                data["SecondBatting"] = data["Team"]
//                            }
//                        }
//                        else {
//                            if matchVC.existTeamName == resVC.existFB {
//                                data["FirstBatting"]  = data["Opponent"]
//                                data["SecondBatting"] = data["Team"]
//                            }
//                            else {
//                                data["FirstBatting"]  = data["Team"]
//                                data["SecondBatting"] = data["Opponent"]
//                            }
//                        }
//                    }
                    
                    if let matchKey = matchId{
                        updateMatchData(matchKey, data: data, callback: { dat in
                            self.updateGlobalValues()
                            var data = dat
                            data["MatchId"] =  matchKey
                            self.previous?.refresh(data)
                           self.moveToMatchSummary()
                            // self.dismissViewControllerAnimated(true) {}
                        })
                        
                    }
                }
//            }
//            else{
//                
//                let button = navigationItem.rightBarButtonItem
//                //(navigationItem.rightBarButtonItem.customView.subviews.lastObject)
//                let myBtn : UIButton?
//                if((button!.customView?.isKindOfClass(UIButton)) != nil)
//                {
//                    myBtn = button!.customView as? UIButton
//                    myBtn!.setTitle("DONE", forState: .Normal)
//                    
//                }
//                dataHasChangedAfterLastSave = false
//            }
            dataAdded = true
        }
    }
    
    func updateGlobalValues(){
        let teamName = self.data["Team"]!
        if teamName != "-" {
            if !teamNames.contains(teamName){
                addNewTeamName(teamName)
                teamNames.append(teamName)
            }
        }
        
        let oppoTeamName = self.data["Opponent"]!
        if oppoTeamName != "-" {
            if !opponentTeams.contains(oppoTeamName){
            addNewOppoSitTeamName(oppoTeamName)
            opponentTeams.append(oppoTeamName)
            }
        }
        
        let tournament = self.data["Tournament"]!
        if tournament != "-"{
            if !tournaments.contains(tournament){
                addNewTournamentName(tournament)
                tournaments.append(tournament)
            }
        }
        
        var groundName = "-"
        if let ground = data["Ground"] {
            groundName = ground
        }
        
        if groundName != "-"{
            if !groundNames.contains(groundName){
                addNewGroundName(groundName)
                groundNames.append(groundName)
            }
        }
        
        var venueName = "-"
        if let venue = data["Venue"] {
            venueName = venue
        }
        
        if venueName != "-"{
            if !venueNames.contains(venueName){
                addNewVenueName(venueName)
                venueNames.append(venueName)
            }
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
            pageName = "Details"
        }
        else if !battingBowlingViewController.allRequiredFieldsHaveFilledProperly {
            pageName = "Batting and Bowling Details"
        }
        else{
            return true
        }
        
//        SCLAlertView().showWarning("Error", subTitle: "Some Fields are not filled properly in \(pageName). Plaese fill it and try saving")
        let confirmAlert = UIAlertController(title: "" ,message:"Please fill the mandatory fields in \(pageName) tab before saving the match.",preferredStyle: UIAlertControllerStyle.Alert)
        confirmAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
          
        }))
        self.presentViewController(confirmAlert, animated: true, completion: nil)
        

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
    
    func moveToMatchSummary()  {
        let dashboardVC = viewControllerFrom("Main", vcid: "MatchSummaryViewController") as! MatchSummaryViewController
        if !matchBeingEdited {
            let navigationControl = UINavigationController(rootViewController: dashboardVC)
            sliderMenu.mainViewController = navigationControl
        }
        else {
            //self.navigationController?.popToRootViewControllerAnimated(true)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //MARK: In App purchase
    
    // Optional: Use this methode to fetch product info.
    private func fetchProductInfo(){
        
        SwiftyStoreKit.retrieveProductsInfo(["CricTrac_Premium_Player"]) { result in
            if let product = result.retrievedProducts.first {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.locale = product.priceLocale
                numberFormatter.numberStyle = .CurrencyStyle
                let priceString = numberFormatter.stringFromNumber(product.price ?? 0) ?? ""
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self.inAppProductPrice = priceString
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                //return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    @IBAction func didTapPurchaseButton(){
        
        if let msg = inAppProductPrice {
        
            let message = "Upgrade to Premium by paying : Rs. \(msg)"
            
            let refreshAlert = UIAlertController(title: "Upgrade", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Buy", style: .Default, handler: { (action: UIAlertAction!) in
                self.doPurchase()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
        
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        else {
            
            self.fetchProductInfo()
            
            let refreshAlert = UIAlertController(title: "Sorry", message: "Please try again", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
            self.presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func doPurchase(){
        
        SwiftyStoreKit.purchaseProduct("CricTrac_Premium_Player") { result in
            switch result {
            case .Success(let productId):
                print("Purchase Success: \(productId)")
                //self.upgradeButton.setTitle("", forState: UIControlState.Normal)
                let refreshAlert = UIAlertController(title: "Success", message: "Purchase successfull", preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                }))
                self.presentViewController(refreshAlert, animated: true, completion: nil)
                
            case .Error(let error):
                print("Purchase Failed: \(error)")
            }
        }
    }

}
