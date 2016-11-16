//
//  UserDashboardViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 06/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class UserDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Variable declaration
    
    var battingDetails: [String:String]!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    var recentMatchesBowling: [String:String]!
    private var _currentTheme:String = CurrentTheme
    
    // MARK: - Plumbing
    
   
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var TeamsTable: UICollectionView!
    @IBOutlet weak var MatchesView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var battingInnings: UILabel!
    @IBOutlet weak var notOuts: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var battingAverage: UILabel!
    @IBOutlet weak var strikeRate: UILabel!
    @IBOutlet weak var hundreds: UILabel!
    @IBOutlet weak var fifties: UILabel!
    
    @IBOutlet weak var recentBest: UILabel!
    @IBOutlet weak var ballsFacedDuringBat: UILabel!
    
    // bowling
    
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var bowlingAverage: UILabel!
    @IBOutlet weak var bowlingEconomy: UILabel!
    
    @IBOutlet weak var recentBestBowling: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if ThemeChanged {
            setUIBackgroundTheme(self.view)
            setColorForViewsWithSameTag(baseView)
            ThemeChanged = false
        }
        
        
    }
    
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
        
        setBowlingUIElements()
        
        // Do any additional setup after loading the view.
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
            
            self.setUIElements()
            
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
        navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        title = "Dashboard"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    
    func setUIElements() {
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        if matchDataSource.count > 0 {
            var runs = [Int]()
            var top3MatchesArray = [NSMutableAttributedString]()
            self.battingMatches.text = String(matchDataSource.count)
            self.notOuts.text = String(0)
            self.fifties.text = String(0)
            self.hundreds.text = String(0)
            self.ballsFacedDuringBat.text = String(0)
            self.battingInnings.text = String(0)
            self.battingAverage.text = String(0)
            var top3MatchCount = 0
            for matchData in matchDataSource {
                
                if matchData["Dismissal"] != nil && !dismissals.contains(matchData["Dismissal"]!){
                    var dismissalCount = Int(self.notOuts.text!)!
                    dismissalCount = dismissalCount + 1
                    self.notOuts.text = String(dismissalCount)
                }
                
                if matchData["Runs"] != nil  && matchData["Runs"] != "-", let curruns = matchData["Runs"] {
                    runs.append(Int(curruns)!)
                }
                
                if matchData["Runs"] != nil && matchData["Runs"] != "-" && matchData["Runs"] != "0" {
                    var inningsCount = Int(self.battingInnings.text!)!
                    inningsCount = inningsCount + 1
                    self.battingInnings.text = String(inningsCount)
                }
                
//                if matchData["Sixes"] != nil && matchData["Sixes"] != "-"{
//                    var sixCount = Int(self.sixes.text!)!
//                    sixCount = sixCount + 1
//                    self.sixes.text = String(sixCount)
//                }
//                
//                if matchData["Fours"] != nil && matchData["Fours"] != "-"{
//                    var fourCount = Int(self.fours.text!)!
//                    fourCount = fourCount + 1
//                    self.fours.text = String(fourCount)
//                }
                
                if matchData["Balls"] != nil && matchData["Balls"] != "-", let ballCount = matchData["Balls"]{
                    var ballsCount = Int(self.ballsFacedDuringBat.text!)!
                    ballsCount = ballsCount + Int(ballCount)!
                    self.ballsFacedDuringBat.text = String(ballsCount)
                }
                if matchData["Runs"] != nil && matchData["Runs"] != "-" && Int(matchData["Runs"]!)! >= 50 && Int(matchData["Runs"]!)! < 100 {
                    var fiftyCount = Int(self.fifties.text!)!
                    fiftyCount = fiftyCount + 1
                    self.fifties.text = String(fiftyCount)
                }
                
                if matchData["Runs"] != nil && matchData["Runs"] != "-" && Int(matchData["Runs"]!)! >= 100 {
                    var hundredCount = Int(self.hundreds.text!)!
                    hundredCount = hundredCount + 1
                    self.hundreds.text = String(hundredCount)
                }
                
                if matchData["Dismissal"] != nil && matchData["Runs"] != nil && matchData["Runs"] != "-" && matchData["Opponent"] != nil && matchData["Opponent"] != "-" && top3MatchCount < 3, let runsScored = matchData["Runs"], let opponentFaced = matchData["Opponent"], let dismissedBy = matchData["Dismissal"] {
                    top3MatchCount = top3MatchCount + 1
                    
                    let formattedString = NSMutableAttributedString()
                    
                    if dismissedBy != "-" {
                        formattedString.bold("\(runsScored) ", fontName: "SFUIText-Bold", fontSize: 17).normal(" against \(opponentFaced)\n", fontName: "SFUIText-Regular", fontSize: 15)
                    }
                    else
                    {
                        formattedString.bold("\(runsScored)* ", fontName: "SFUIText-Bold", fontSize: 17).normal(" against \(opponentFaced)\n", fontName: "SFUIText-Regular", fontSize: 15)
                    }
                    
                    
                    top3MatchesArray.append(formattedString)
                }
                KRProgressHUD.dismiss()
            }
            
            if runs.count > 0 && self.notOuts.text != nil && self.notOuts.text != "-" , let notOuts = Int(self.notOuts.text!) {
                let notOutsAvg = (runs.count - notOuts)
                var avg = runs.reduce(0, combine: +)
                
                if notOutsAvg > 0 {
                    avg = avg/notOutsAvg
                }
                
                self.battingAverage.text = String(Float(avg))
            }
            
            if runs.count > 0 && self.ballsFacedDuringBat.text != nil && self.ballsFacedDuringBat.text != "-" {
                
                let ballsFacedDureingbat = Int(self.ballsFacedDuringBat.text!)!
                
                var totalruns = runs.reduce(0, combine: +)
                
                
                if ballsFacedDureingbat > 0 {
                    totalruns = totalruns/ballsFacedDureingbat
                }
                
                self.strikeRate.text = String(Float(totalruns*100))
                
            }
            
            if runs.count > 0 {
                self.highScore.text = String(runs.reduce(Int.min, combine: { max($0, $1) }))
            }
            
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
//            self.totalRunsGiven.text = String(0)
            var top3MatchesArray = [NSMutableAttributedString]()
            var top3MatchCount = 0
            for matchData in matchDataSource {
                
                if matchData["OversBalled"] != nil && matchData["OversBalled"] != "-", let oversbowled = matchData["OversBalled"]  {
//                    var oversCount = Int(self.totalOvers.text!)!
//                    var inningsCount = Int(self.bowlingInnings.text!)!
//                    inningsCount = inningsCount + 1
//                    oversCount = oversCount + Int(oversbowled)!
//                    self.totalOvers.text = String(oversCount)
//                    self.bowlingInnings.text = String(oversCount)
                }
                
                
                if matchData["Wickets"] != nil && matchData["Wickets"] != "-", let wicketsTaken = matchData["Wickets"]{
                    var wicketCount = Int(self.totalWickets.text!)!
                    wicketCount = wicketCount + Int(wicketsTaken)!
                    self.totalWickets.text = String(wicketCount)
                }
                
                if matchData["RunsGiven"] != nil && matchData["RunsGiven"] != "-", let runsGiven = matchData["RunsGiven"]{
//                    var runsGivenCount = Int(self.totalRunsGiven.text!)!
//                    runsGivenCount = runsGivenCount + Int(runsGiven)!
//                    self.totalRunsGiven.text = String(runsGivenCount)
                }
                
                if matchData["Wickets"] != nil && matchData["Wickets"] != "-" && matchData["Opponent"] != nil && matchData["Opponent"] != "-" && top3MatchCount < 3, let wicketstaken = matchData["Wickets"], let opponentFaced = matchData["Opponent"] {
                    top3MatchCount = top3MatchCount + 1
                    
                    let formattedString = NSMutableAttributedString()
                    
                    formattedString.bold("\(wicketstaken)",fontName: "SFUIText-Bold", fontSize: 17).normal(" wickets against \(opponentFaced)\n", fontName: "SFUIText-Regular", fontSize: 15)
                    
                    top3MatchesArray.append(formattedString)
                }
                
            }
            
            
            
//            if self.totalRunsGiven.text != nil && self.totalRunsGiven.text != "-" && self.totalWickets.text != nil && self.totalWickets.text != "-", let totRunsGiven = Int(self.totalRunsGiven.text!), let totWickets = Int(self.totalWickets.text!) {
//                
//                if totWickets > 0 {
//                    self.bowlingAverage.text = String(Float(totRunsGiven/totWickets))
//                }
//                
//                
//            }
            
            
            
            
//            if self.totalRunsGiven.text != nil && self.totalRunsGiven.text != "-" && self.totalOvers.text != nil && self.totalOvers.text != "-", let runsGiven = Int(self.totalRunsGiven.text!), let overs = Int(self.totalOvers.text!) {
//                
//                if overs > 0 {
//                    self.bowlingEconomy.text = String(Float(runsGiven/overs))
//                }
//                
//                
//            }
            
            if top3MatchesArray.count > 0 {
                self.recentBestBowling.attributedText = top3MatchesArray.joinWithSeparator("\n")
            }
            
            
            
            
            
            
        }
    }

    
    
    // MARK: - Collection view delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColors.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let allCells = collectionView.visibleCells() as! [ThemeColorsCollectionViewCell]
        
        allCells.forEach({ cell in
            cell.cellIsSelected = false
        })
        
        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! ThemeColorsCollectionViewCell
        
        currentCell.cellIsSelected = true
        _currentTheme = currentCell.ThemeTitle.text!
        self.view.backgroundColor = currentCell.contentView.backgroundColor
        
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
