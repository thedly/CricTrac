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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIBackgroundTheme(self.view)
        setColorForViewsWithSameTag(baseView)
        
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width/2
        MatchesView.layer.cornerRadius = 10
        userProfileImage.clipsToBounds = true
        
        TeamsTable.delegate = self
        TeamsTable.dataSource = self
        
        
        
        setNavigationBarProperties();
        getMatchData()
        
        
        
        
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
    
    func getMatchData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllMatchData { (data) in
            
            matchDataSource.removeAll()
            for (key,val) in data{
                
                if  var value = val as? [String : String]{
                    
                    value += ["key":key]
                    
                    matchDataSource.append(value)
                }
            }
            
            let df = NSDateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            
            
            self.PlayerName.text = currentUser?.displayName?.uppercaseString
            
            
            let formattedString = NSMutableAttributedString()
            
            
            let locationText = formattedString.bold("\(profileData.City.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.State.uppercaseString)\n", fontName: appFont_black, fontSize: 15).bold("\(profileData.Country.uppercaseString) ", fontName: appFont_black, fontSize: 15)
          
            
            
            self.PlayerLocation.attributedText = locationText
            
            self.userProfileImage.image = LoggedInUserImage
            
            self.setUIElements()
            self.setBowlingUIElements()
            KRProgressHUD.dismiss()
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
    
    
    func setUIElements() {
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        if matchDataSource.count > 0 {
            var totalPlayerRuns = [Int]()
            
            var totalNotOuts = Int(0)
            
            var top3MatchesArray = [NSMutableAttributedString]()
            self.battingMatches.text = String(matchDataSource.count)
//            self.notOuts.text = String(0)
            self.fifties.text = String(0)
            self.hundreds.text = String(0)
            self.ballsFacedDuringBat.text = String(0)
            self.battingInnings.text = String(0)
            self.battingAverage.text = String(0)
            
            self.sixes.text = String(0)
            self.fours.text = String(0)
            
            
            var top3MatchCount = 0
            for matchData in matchDataSource {
                
                if matchData["Dismissal"] != nil && !dismissals.contains(matchData["Dismissal"]!){
                    var dismissalCount = totalNotOuts
                    dismissalCount = dismissalCount + 1
                    totalNotOuts = dismissalCount
                }
                
                if matchData["RunsTaken"] != nil  && matchData["RunsTaken"] != "-", let curruns = matchData["RunsTaken"] {
                    totalPlayerRuns.append(Int(curruns)!)
                }
                
                if matchData["RunsTaken"] != nil && matchData["RunsTaken"] != "-" && matchData["RunsTaken"] != "0" {
                    var inningsCount = Int(self.battingInnings.text!)!
                    inningsCount = inningsCount + 1
                    self.battingInnings.text = String(inningsCount)
                }
                
                if matchData["Sixes"] != nil && matchData["Sixes"] != "-", let sixes = matchData["Sixes"] {
                    var sixCount = Int(sixes)!
                    sixCount = sixCount + 1
                    self.sixes.text = String(sixCount)
                }

                if matchData["Fours"] != nil && matchData["Fours"] != "-"{
                    var fourCount = Int(self.fours.text!)!
                    fourCount = fourCount + 1
                    self.fours.text = String(fourCount)
                }
                
                if matchData["BallsFaced"] != nil && matchData["BallsFaced"] != "-", let ballCount = matchData["BallsFaced"]{
                    var ballsCount = Int(self.ballsFacedDuringBat.text!)!
                    ballsCount = ballsCount + Int(ballCount)!
                    self.ballsFacedDuringBat.text = String(ballsCount)
                }
                if matchData["RunsTaken"] != nil && matchData["RunsTaken"] != "-" && Int(matchData["RunsTaken"]!)! >= 50 && Int(matchData["RunsTaken"]!)! < 100 {
                    var fiftyCount = Int(self.fifties.text!)!
                    fiftyCount = fiftyCount + 1
                    self.fifties.text = String(fiftyCount)
                }
                
                if matchData["RunsTaken"] != nil && matchData["RunsTaken"] != "-" && Int(matchData["RunsTaken"]!)! >= 100 {
                    var hundredCount = Int(self.hundreds.text!)!
                    hundredCount = hundredCount + 1
                    self.hundreds.text = String(hundredCount)
                }
                
                if matchData["Dismissal"] != nil && matchData["RunsTaken"] != nil && matchData["RunsTaken"] != "-" && matchData["Opponent"] != nil && matchData["Opponent"] != "-" && top3MatchCount < 3, let runsScored = matchData["RunsTaken"], let opponentFaced = matchData["Opponent"], let dismissedBy = matchData["Dismissal"] {
                    top3MatchCount = top3MatchCount + 1
                    
                    let formattedString = NSMutableAttributedString()
                    
                    if dismissedBy != "-" {
                        formattedString.bold("\(runsScored) ", fontName: appFont_bold, fontSize: 17).normal(" against \(opponentFaced)\n", fontName: appFont_regular, fontSize: 15)
                        self.highScore.text = "\(runsScored)"
                    }
                    else
                    {
                        formattedString.bold("\(runsScored)* ", fontName: appFont_bold, fontSize: 17).normal(" against \(opponentFaced)\n", fontName: appFont_regular, fontSize: 15)
                        self.highScore.text = "\(runsScored)*"
                    }
                    
                    
                    top3MatchesArray.append(formattedString)
                }
                KRProgressHUD.dismiss()
            }
            
            if totalPlayerRuns.count > 0 {
                let notOuts = totalNotOuts
                let notOutsAvg = (totalPlayerRuns.count - notOuts)
                var avg = totalPlayerRuns.reduce(0, combine: +)
                
                if notOutsAvg > 0 {
                    avg = avg/notOutsAvg
                }
                
                self.battingAverage.text = String(Float(avg))
            }
            
            if totalPlayerRuns.count > 0 && self.ballsFacedDuringBat.text != nil && self.ballsFacedDuringBat.text != "-" {
                
                let ballsFacedDureingbat = Int(self.ballsFacedDuringBat.text!)!
                
                var totalruns = totalPlayerRuns.reduce(0, combine: +)
                
                self.totalRunsScored.text = "\(totalruns)"
                
                if ballsFacedDureingbat > 0 {
                    
                    self.ballsFacedDuringBat.text = "\(ballsFacedDureingbat)"
                    
                    totalruns = totalruns/ballsFacedDureingbat
                }
                
                self.strikeRate.text = String(Float(totalruns*100))
                
            }
            
//            if totalPlayerRuns.count > 0 {
//                self.highScore.text = String(totalPlayerRuns.reduce(Int.min, combine: { max($0, $1) }))
//            }
            
            if top3MatchesArray.count > 0 {
                self.recentBest.attributedText = top3MatchesArray.joinWithSeparator("\n")
            }
            
        }
    }
    
    
    func setBowlingUIElements() {
        if matchDataSource.count > 0 {
//            self.bowlingMatches.text = String(matchDataSource.count)
//            self.totalOvers.text = String(0)
//            self.bowlingInnings.text = String(0)
            self.bowlingEconomy.text = String(0)
            self.bowlingAverage.text = String(0)
            self.totalWickets.text = String(0)
            
            self.TotalThreeWicketsPerMatch.text = String(0)
            self.TotalFiveWicketsPerMatch.text = String(0)
            
            self.TotalMaidens.text = String(0)
            
//            self.totalRunsGiven.text = String(0)
            var top3MatchesArray = [NSMutableAttributedString]()
            var top3MatchCount = 0
            
            var totalOversBowled = 0
            var totalMaidensBowled = 0
            var total3WPerMatch = 0
            var total5WPerMatch = 0
            var wicketCount = 0
            var runsGivenCount = 0
            var totalEconomy = [Float]()
            
            for matchData in matchDataSource {
                
                if matchData["OversBowled"] != nil && matchData["OversBowled"] != "-", let oversbowled = matchData["OversBowled"]  {
                    totalOversBowled += Int(oversbowled)!
                    
                    if matchData["RunsGiven"] != nil && matchData["RunsGiven"] != "-", let runsGiven = matchData["RunsGiven"]{
                        
//                        if runsGiven == 0 {
//                            totalMaidensBowled += 1
//                        }
                        
                        if Int(oversbowled) > 0 {
                            totalEconomy.append(Float(Int(runsGiven)!/Int(oversbowled)!))
                        }
                        
                    }

                    
                    
                    
                }
                
                if matchData["Wickets"] != nil && matchData["Wickets"] != "-", let wicketsTaken = matchData["Wickets"]{
                    
                    if Int(wicketsTaken) > 3 {
                       total3WPerMatch += 1
                    }
                    
                    if Int(wicketsTaken) > 5 {
                        total5WPerMatch += 1
                    }
                    
                    
                    wicketCount += Int(wicketsTaken)!
                    
                }
                
                
                
                if matchData["Wickets"] != nil && matchData["Wickets"] != "-" && matchData["Opponent"] != nil && matchData["Opponent"] != "-" && top3MatchCount < 3, let wicketstaken = matchData["Wickets"], let opponentFaced = matchData["Opponent"] {
                    top3MatchCount = top3MatchCount + 1
                    
                    let formattedString = NSMutableAttributedString()
                    
                    formattedString.bold("\(wicketstaken)",fontName: appFont_bold, fontSize: 17).normal(" wicket(s) against \(opponentFaced)\n", fontName: appFont_regular, fontSize: 15)
                    
                    top3MatchesArray.append(formattedString)
                }
            }
            
            self.PlayerOversBowld.text =  "\(totalOversBowled)"
            self.totalWickets.text = String(wicketCount)
            self.TotalThreeWicketsPerMatch.text = String(total3WPerMatch)
            self.TotalFiveWicketsPerMatch.text = String(total5WPerMatch)
            
            self.bowlingEconomy.text = String(totalEconomy.reduce(0, combine: +)/Float(matchDataSource.count))
            
            if top3MatchesArray.count > 0 {
                self.recentBestBowling.attributedText = top3MatchesArray.joinWithSeparator("\n")
            }
            
            
            
            
            
            
//            if self.totalRunsGiven.text != nil && self.totalRunsGiven.text != "-" && self.totalWickets.text != nil && self.totalWickets.text != "-", let totRunsGiven = Int(self.totalRunsGiven.text!), let totWickets = Int(self.totalWickets.text!) {
//                
//                if totWickets > 0 {
//                    self.bowlingAverage.text = String(Float(totRunsGiven/totWickets))
//                }
//                
//                
//            }
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
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
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThemeColorsCollectionViewCell", forIndexPath: indexPath) as? ThemeColorsCollectionViewCell {
            
            
            let intIndex = indexPath.row // where intIndex < myDictionary.count
            let index = themeColors.startIndex.advancedBy(intIndex) // index 1
            
            //aCell.ThemeTitle.text = themeColors.keys[index]
            
            
            if let colorObject = themeColors[themeColors.keys[index]] {
                
                aCell.cellTopColor = colorObject["topColor"]!
                aCell.cellBottomColor = colorObject["bottomColor"]!
                
                
                setCustomUIBackgroundTheme(aCell.contentView, _topColor: colorObject["topColor"]!, _bottomColor: colorObject["bottomColor"]!)
                return aCell
            }
            else
            {
                return ThemeColorsCollectionViewCell()
            }
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
