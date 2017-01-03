//
//  UserDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 06/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class UserDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,ThemeChangeable {

    //MARK: - Variable declaration
    
    var battingDetails: [String:String]!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    var recentMatchesBowling: [String:String]!
    private var _currentTheme:String = CurrentTheme
    
    // MARK: - Plumbing
    
   
    
   
    
    @IBOutlet weak var winPerc: UILabel!
    @IBOutlet weak var BB: UILabel!
    @IBOutlet weak var PlayerLocation: UILabel!
    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var totalRunsScored: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var TeamsTable: UICollectionView!
    @IBOutlet weak var MatchesView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var battingInnings: UILabel!
//    @IBOutlet weak var notOuts: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var battingAverage: UILabel!
    @IBOutlet weak var strikeRate: UILabel!
    @IBOutlet weak var hundreds: UILabel!
    @IBOutlet weak var fifties: UILabel!
    
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var fours: UILabel!
    
    @IBOutlet weak var recentBest: UILabel!
    @IBOutlet weak var ballsFacedDuringBat: UILabel!
    
    // bowling
    
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var bowlingAverage: UILabel!
    @IBOutlet weak var bowlingEconomy: UILabel!
    
    @IBOutlet weak var TotalThreeWicketsPerMatch: UILabel!
    @IBOutlet weak var recentBestBowling: UILabel!
    
    @IBOutlet weak var TotalMaidens: UILabel!
    @IBOutlet weak var TotalFiveWicketsPerMatch: UILabel!

    @IBOutlet weak var PlayerOversBowld: UILabel!
    
    
    
    @IBOutlet weak var FirstRecentMatchView: UIView!
    
    
    @IBOutlet weak var SecondRecentMatchView: UIView!
    
    
    @IBOutlet weak var FirstRecentMatchBowlingView: UIView!
    
    @IBOutlet weak var SecondRecentMatchBowlingView: UIView!
    
    
    
    
    @IBOutlet weak var FirstRecentMatchScore: UILabel!
    @IBOutlet weak var FirstRecentMatchOpponent: UILabel!
    
    @IBOutlet weak var FirstRecentMatchDateAndLocation: UILabel!
    
    
    
    @IBOutlet weak var SecondRecentMatchScore: UILabel!
    @IBOutlet weak var SecondRecentMatchOpponent: UILabel!
    
    @IBOutlet weak var SecondRecentMatchDateAndLocation: UILabel!
 

    
    
    
    
    @IBOutlet weak var FirstRecentMatchBowlingScore: UILabel!
    @IBOutlet weak var FirstRecentMatchBowlingOpponent: UILabel!
    
    @IBOutlet weak var FirstRecentMatchBowlingDateAndLocation: UILabel!
    
    
    
    @IBOutlet weak var SecondRecentMatchBowlingScore: UILabel!
    @IBOutlet weak var SecondRecentMatchBowlingOpponent: UILabel!
    
    @IBOutlet weak var SecondRecentMatchBowlingDateAndLocation: UILabel!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIBackgroundTheme(self.view)
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        userProfileImage.clipsToBounds = true
        
        TeamsTable.delegate = self
        TeamsTable.dataSource = self
        
        
        
        setNavigationBarProperties();
        //getMatchData()
        
        setDashboardData()
        
        
        //setBackgroundColor()
        
        // Do any additional setup after loading the view.
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        MatchesView.backgroundColor = currentTheme.boxColor
        //baseView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    
    
    func setDashboardData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        
        getAllDashboardData { (data) in
            
            //DashboardDetails = DashboardData(dataObj: data)
            
            
            let df = NSDateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            self.PlayerName.text = currentUser?.displayName?.uppercaseString
            let formattedString = NSMutableAttributedString()
            let locationText = formattedString.bold("\(profileData.City.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.State.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.Country.uppercaseString) ", fontName: appFont_black, fontSize: 15)
            self.PlayerLocation.attributedText = locationText
            self.userProfileImage.image = LoggedInUserImage
            
            
            
            
            
            
            
            
            
            
            //self.setUIElements()
            //self.setBowlingUIElements()
            KRProgressHUD.dismiss()
            
            
            
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.SetDataOnDashboard()
    }
    
    
    func SetDataOnDashboard(){
       
        if DashboardDetails != nil {
            self.winPerc.text = DashboardDetails.WinPercentage
            self.BB.text = DashboardDetails.TopBowling1stMatchScore
            self.totalRunsScored.text = DashboardDetails.TotalRuns
            
            self.battingMatches.text = DashboardDetails.TotalMatches
            self.battingInnings.text = DashboardDetails.BattingInnings
            //    self.notOuts = DashboardDetails
            
            self.highScore.text = DashboardDetails.TopBatting1stMatchScore
            self.battingAverage.text = DashboardDetails.TotalBattingAverage
            self.strikeRate.text = DashboardDetails.TotalStrikeRate
            self.hundreds.text = DashboardDetails.Total100s
            self.fifties.text = DashboardDetails.Total50s
            
            self.sixes.text = DashboardDetails.Total6s
            self.fours.text = DashboardDetails.Total4s
            
            self.ballsFacedDuringBat.text = DashboardDetails.TotalBallsFaced
            
            // bowling
            
            self.totalWickets.text = DashboardDetails.TotalWickets
            self.bowlingAverage.text = DashboardDetails.TotalBowlingAverage
            self.bowlingEconomy.text = DashboardDetails.TotalEconomy
            
            self.TotalThreeWicketsPerMatch.text = DashboardDetails.Total3Wkts
            
            self.TotalMaidens.text = DashboardDetails.TotalMaidens
            self.TotalFiveWicketsPerMatch.text = DashboardDetails.Total5Wkts
            
            self.PlayerOversBowld.text = DashboardDetails.TotalOvers
            
            
            
            
            
            FirstRecentMatchView.hidden = (DashboardDetails.TopBatting1stMatchScore == nil || DashboardDetails.TopBatting1stMatchScore == "0")
            
            
            SecondRecentMatchView.hidden = (DashboardDetails.TopBatting2ndMatchScore == nil || DashboardDetails.TopBatting1stMatchScore == "0")
            
            
            
            FirstRecentMatchBowlingView.hidden = (DashboardDetails.TopBowling1stMatchScore == nil || DashboardDetails.TopBowling1stMatchScore == "0-0")
            
            
            SecondRecentMatchBowlingView.hidden = (DashboardDetails.TopBowling2ndMatchScore == nil || DashboardDetails.TopBowling2ndMatchScore == "0-0")
            
            
            
            if !FirstRecentMatchView.hidden {
                self.FirstRecentMatchScore.text = DashboardDetails.TopBatting1stMatchScore
                self.FirstRecentMatchOpponent.text = DashboardDetails.TopBatting1stMatchOpp
                
                let formattedString = NSMutableAttributedString()
                formattedString.bold("\(DashboardDetails.TopBatting1stMatchDate), at \(DashboardDetails.TopBatting1stMatchGround)",fontName: appFont_bold, fontSize: 12)
                self.FirstRecentMatchDateAndLocation.attributedText = formattedString
            }
            
            
            
            
            if !SecondRecentMatchView.hidden {
                
                self.SecondRecentMatchScore.text = DashboardDetails.TopBatting2ndMatchScore
                self.SecondRecentMatchOpponent.text = DashboardDetails.TopBatting2ndMatchOpp
                
                let formattedString_2 = NSMutableAttributedString()
                formattedString_2.bold("\(DashboardDetails.TopBatting2ndMatchDate), at \(DashboardDetails.TopBatting2ndMatchGround)",fontName: appFont_bold, fontSize: 12)
                self.SecondRecentMatchDateAndLocation.attributedText = formattedString_2
                
            }
            
            
            if !FirstRecentMatchBowlingView.hidden {
                self.FirstRecentMatchBowlingScore.text = DashboardDetails.TopBowling1stMatchScore
                self.FirstRecentMatchBowlingOpponent.text = DashboardDetails.TopBowling1stMatchOpp
                
                let formattedString_Bowling = NSMutableAttributedString()
                formattedString_Bowling.bold("\(DashboardDetails.TopBowling1stMatchDate), at \(DashboardDetails.TopBowling1stMatchGround)",fontName: appFont_bold, fontSize: 12)
                self.FirstRecentMatchBowlingDateAndLocation.attributedText = formattedString_Bowling
            }
            
            
            
            if !SecondRecentMatchBowlingView.hidden {
                
                self.SecondRecentMatchBowlingScore.text = DashboardDetails.TopBowling2ndMatchScore
                self.SecondRecentMatchBowlingOpponent.text = DashboardDetails.TopBowling2ndMatchOpp
                
                let formattedString_Bowling_2 = NSMutableAttributedString()
                formattedString_Bowling_2.bold("\(DashboardDetails.TopBowling2ndMatchDate), at \(DashboardDetails.TopBowling2ndMatchGround)",fontName: appFont_bold, fontSize: 12)
                self.SecondRecentMatchBowlingDateAndLocation.attributedText = formattedString_Bowling_2
            }
        }
        
        
    }
    

    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didNewMatchButtonTapp(){
        let newMatchVc = viewControllerFrom("Main", vcid: "AddMatchDetailsViewController")
        self.presentViewController(newMatchVc, animated: true) {}
    }
    
    func setNavigationBarProperties(){
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("+", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: appFont_bold, size: 30)
        addNewMatchButton.addTarget(self, action: #selector(didNewMatchButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = UIColor(hex: topColor)
        title = "DASHBOARD"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    
    
    // MARK: - Collection view delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var valueToReturn = 0
        
        switch profileData.UserProfile {
        case userProfileType.Player.rawValue:
            valueToReturn = profileData.PlayerCurrentTeams.count
            break
        case userProfileType.Coach.rawValue:
            valueToReturn = profileData.CoachCurrentTeams.count
            break
        case userProfileType.Fan.rawValue:
            valueToReturn = profileData.SupportingTeams.count
            break
        default:
            valueToReturn = 0
            break
        }
        return valueToReturn // //themeColors.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
//        let allCells = collectionView.visibleCells() as! [ThemeColorsCollectionViewCell]
//        
//        allCells.forEach({ cell in
//            cell.cellIsSelected = false
//        })
//        
//        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! ThemeColorsCollectionViewCell
//        
//        currentCell.cellIsSelected = true
//        _currentTheme = currentCell.ThemeTitle.text!
//        self.view.backgroundColor = currentCell.contentView.backgroundColor
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("TeamCollectionViewCell", forIndexPath: indexPath) as? TeamCollectionViewCell {
            
            
//            let intIndex = indexPath.row // where intIndex < myDictionary.count
//            let index = themeColors.startIndex.advancedBy(intIndex) // index 1
            
            //aCell.ThemeTitle.text = themeColors.keys[index]
            
            
//            if let colorObject = themeColors[themeColors.keys[index]] {
//                
                aCell.TeamImage.image = UIImage()
            
            var teamNameToReturn = ""
            
            switch profileData.UserProfile {
            case userProfileType.Player.rawValue:
                teamNameToReturn = profileData.PlayerCurrentTeams[indexPath.row]
                break
            case userProfileType.Coach.rawValue:
                teamNameToReturn = profileData.CoachCurrentTeams[indexPath.row]
                break
            case userProfileType.Fan.rawValue:
                teamNameToReturn = profileData.SupportingTeams[indexPath.row]
                break
            default:
                teamNameToReturn = ""
                break
            }
            
            
            
                aCell.TeamName.text = teamNameToReturn
            
            
                aCell.TeamAbbr.text = "\(teamNameToReturn[0])\(teamNameToReturn[1])"
            
            
                
            
                return aCell
//            }
//            else
//            {
//                return ThemeColorsCollectionViewCell()
//            }
        }
        return ThemeColorsCollectionViewCell()
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
