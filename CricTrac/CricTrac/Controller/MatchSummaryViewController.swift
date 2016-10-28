//
//  MatchSummaryViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import KRProgressHUD

class MatchSummaryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var matchSummaryTable:UITableView!
    
    
    var runs = String?()
    var matchData:[String:AnyObject]!
    var matchDataSource = [[String:String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        getMatchData()
    matchSummaryTable.registerNib(UINib.init(nibName:"SummaryDetailsCell", bundle: nil), forCellReuseIdentifier: "SummaryDetailsCell")
        matchSummaryTable.allowsSelection = true
        matchSummaryTable.separatorStyle = .None
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchSummaryViewController.newDataAdded), name: "MatchDataChanged" , object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func newDataAdded(){
        getMatchData()
    }

    @IBAction func didTapCancel(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true) {}
    }
    
    
    
    func getMatchData(){
        
        KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        getAllMatchData { (data) in
            
            self.matchData = data
            self.matchDataSource.removeAll()
            for (key,val) in data{
                
                //var dataDict = val as! [String:String]
                //dataDict["key"] = key
                
                if  var value = val as? [String : String]{
                    
                    value += ["key":key]
                    
                    self.matchDataSource.append(value)
                }
            }
            KRProgressHUD.dismiss()
            self.matchSummaryTable.reloadData()
            
        }
    }

    
    
    
    func getCellForRow(indexPath:NSIndexPath)->SummaryDetailsCell{
        
        
        let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryDetailsCell", forIndexPath: indexPath) as! SummaryDetailsCell
        
        aCell.backgroundColor = UIColor.clearColor()
        
        let data = matchDataSource[indexPath.row]
        
        var totalruns:Double?

        if let runs = data["Runs"]{
            aCell.battingViewHidden = (runs == "0" || runs == "-") ? true : false
            aCell.battingView.hidden = aCell.battingViewHidden
            aCell.BallsAndStrikeRate.hidden = aCell.battingViewHidden
            
            aCell.totalRuns.text = runs
            totalruns = Double(runs)
        }
        if let wickets = data["Wickets"], let balls = data["OversBalled"], let runsGiven = data["RunsGiven"]   {
            aCell.bowlingViewHidden = (balls == "0" || balls == "-") ? true : false
            aCell.bowlingView.hidden = aCell.bowlingViewHidden
            aCell.BallsBowledWithWicketsTaken.hidden = aCell.bowlingViewHidden
            
            if !aCell.bowlingViewHidden {
                var formattedStringCollection = [NSMutableAttributedString]()
                
                let ballsformattedString = NSMutableAttributedString()
                let economyformattedString = NSMutableAttributedString()
                
                ballsformattedString.bold("\(balls) ", fontName: appFont_black, fontSize: 20).normal("OVERS", fontName: appFont_regular, fontSize: 10)
                
                
                var eco = "\(Float(runsGiven)!/Float(balls)!) "
                    matchDataSource[indexPath.row]["Economy"] = eco
                
                economyformattedString.bold(eco, fontName: appFont_black, fontSize: 20).normal("ECONOMY", fontName: appFont_regular, fontSize: 10)
                
                formattedStringCollection.append(ballsformattedString)
                formattedStringCollection.append(economyformattedString)
                
                aCell.BallsBowledWithWicketsTaken.text = "\(wickets)-\(balls)"
                aCell.oversAndEconomy.attributedText = formattedStringCollection.joinWithSeparator("    ")

            }
   }
        
        
        
        if let date = data["Date"]{
            
            //let dateString: String! = "\(dateArray[0]) \(dateArray[1].monthName) \(dateArray[2])"
            aCell.matchDateAndVenue.text = date ?? "NA"
            
            
            
            
        }
        
        if let balls = data["Balls"]{
            
            if totalruns != nil && balls != "-"{
                let totalBalls = Double(balls)!
                
                if totalBalls > 0{
                    var formattedStringCollection = [NSMutableAttributedString]()
                    
                    let strikeRateformattedString = NSMutableAttributedString()
                    let ballsformattedString = NSMutableAttributedString()
                    
                    ballsformattedString.bold("\(Int(totalBalls)) ", fontName: appFont_black, fontSize: 20).normal("BALLS", fontName: appFont_regular, fontSize: 10)
                    
                    strikeRateformattedString.bold("\(Double(round(100*(totalruns!/totalBalls*100))/100)) ", fontName: appFont_black, fontSize: 20).normal("SR", fontName: appFont_regular, fontSize: 10)
                    
                    formattedStringCollection.append(ballsformattedString)
                    formattedStringCollection.append(strikeRateformattedString)

                    
                    
                    aCell.BallsAndStrikeRate.attributedText = formattedStringCollection.joinWithSeparator("    ")
                }
            }
            

            
        }
        
        
        if let opponent  = data["Opponent"]{
            aCell.oponentName.text = opponent.uppercaseString
        }
        
        
        if let venue = data["Ground"]{
            aCell.matchDateAndVenue.text = ("\(aCell.matchDateAndVenue.text!) @ \(venue)").uppercaseString
        }
        else{
            aCell.matchDateAndVenue.text = "\(aCell.matchDateAndVenue.text!) @ NA".uppercaseString
        }
        
        aCell.selectionStyle = .None
    
        return aCell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.matchDataSource.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let currentCell = getCellForRow(indexPath)
        
        currentCell.vsView.backgroundColor = UIColor().darkerColorForColor(currentCell.baseView.backgroundColor!)
        
        currentCell.baseView.alpha = 0.6
        
        if currentCell.bowlingViewHidden || currentCell.battingViewHidden {
            tableView.rowHeight = 100
        }
        else
        {
            tableView.rowHeight = 150
            
        }
        
        return currentCell
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SummaryDetailsCell
        
        
        
        let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        if cell.battingViewHidden {
            summaryDetailsVC.battingViewHidden = true
        }
        
        if cell.bowlingViewHidden {
            summaryDetailsVC.bowlingViewHidden = true
        }
        
        
       summaryDetailsVC.matchDetailsData = matchDataSource[indexPath.row]
            presentViewController(summaryDetailsVC, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

}
