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
        
        if appThemeChanged {
            updateBackgroundTheme(self.view)
            appThemeChanged = false;
        }
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
            //aCell.battingView.hidden = aCell.bowlingViewHidden
            aCell.totalRuns.text = runs
            totalruns = Double(runs)
        }
        if let wickets = data["Wickets"], let balls = data["OversBalled"]  {
            aCell.bowlingViewHidden = (balls == "0" || balls == "-") ? true : false
            aCell.BallsBowledWithWicketsTaken.text = "\(wickets)-\(balls)"
            aCell.oversAndEconomy.text = "\(balls)"
        }
        
        
        
        if let date = data["Date"]{
            let dateArray = date.characters.split{$0 == "/"}.map(String.init)
            aCell.matchDateAndVenue.text = "\(dateArray[0]) \(dateArray[1].monthName) \(dateArray[2])".capitalizedString
        }
        
        if let balls = data["Balls"]{
            
            if totalruns != nil{
                let totalBalls = Double(balls)!
                if totalBalls > 0{
                    aCell.BallsAndStrikeRate.text =  String(format: "%.0f",(totalruns!/totalBalls*100))
                }
            }
            

            
        }
        
        
        if let opponent  = data["Opponent"]{
            aCell.oponentName.text = opponent.uppercaseString
        }
        
        
        if let venue = data["Ground"]{
            aCell.matchDateAndVenue.text = ("\(aCell.matchDateAndVenue.text), @ \(venue)").uppercaseString
        }
        else{
            aCell.matchDateAndVenue.text = "\(aCell.matchDateAndVenue.text), @ NA".uppercaseString
        }
        
        aCell.selectionStyle = .None
    
        return aCell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.matchDataSource.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let currentCell = getCellForRow(indexPath)
        
        
        if currentCell.bowlingViewHidden || currentCell.battingViewHidden {
            tableView.rowHeight = 120
        }
        else
        {
            tableView.rowHeight = 200
            
        }
        
        return currentCell
        
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
       // summaryDetailsVC.matchDetailsData = matchDataSource[indexPath.row]
            presentViewController(summaryDetailsVC, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

}
