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

        getMatchData()
    matchSummaryTable.registerNib(UINib.init(nibName:"SummaryCell", bundle: nil), forCellReuseIdentifier: "SummaryCell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                if var dataDict: [String : String] = val as? [String : String] {
                    dataDict["key"] = key
                    self.matchDataSource.append(dataDict)
                    self.matchSummaryTable.reloadData()
                }
                
            }
            KRProgressHUD.dismiss()
        }
    }

    func getCellForRow(indexPath:NSIndexPath)->SummaryCell{
        
        
        let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! SummaryCell
        
         let data = matchDataSource[indexPath.row]
        
        
        if runs == data["Runs"]{
            
            //aCell.totalRuns.text = "Runs: "+runs!
        }
        if let wickets = data["Wickets"]{
            
            //aCell.totalWickets.text = "Wickets: "+wickets
        }
        
//        if let tournament = data["Tournamnet"]{
//            
//            
//            
//        }
        
        
        if let opponent = data["Opponent"]{
            if opponent == "-"{
                
                aCell.tournamentName.text = "VS Unknown"
            }
            else{
                aCell.tournamentName.text = "VS \(opponent)"
            }
        }
        
        if let date = data["Date"]{
        let dateArray = date.characters.split{$0 == "/"}.map(String.init)
        //aCell.matchdate.text = "\(dateArray[0]) \(dateArray[1].monthName) \(dateArray[2]) | @ INHS, Indiranagar"
        }
        
        if let overs = data["OversBalled"]{
        //aCell.overs.text = overs
        }
        if let balls = data["Balls"]{
        //aCell.ballsFaced.text = "Balls: "+balls
        }
        if let result = data["Result"]{
            
        if result != "-"{
            //aCell.result.text = result
            }
        }
        if let result = data["Sixes"]{
        //aCell.sixes.text = result
        }
        if let result = data["Sixes"]{
        //aCell.fours.text = result
        }
        
        aCell.selectionStyle = .None
        
        return aCell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.matchDataSource.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        return getCellForRow(indexPath)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        summaryDetailsVC.matchDetailsData = matchDataSource[indexPath.row]
        
        
        //print(currentCell.sixes.text)
        
        //summaryDetailsVC._sixes = currentCell.sixes.text!
        //summaryDetailsVC._ballsFaced = currentCell.ballsFaced.text!
        //summaryDetailsVC._fours = currentCell.fours.text!
        //summaryDetailsVC._batRuns = currentCell.machYear.text!
        //summaryDetailsVC._matchMonth = currentCell.matchdate.text!
        //summaryDetailsVC._overs = currentCell.overs.text!
        //summaryDetailsVC._result = currentCell.result.text!
        //summaryDetailsVC._batRuns = currentCell.totalRuns.text!
        //summaryDetailsVC._totalWickets = currentCell.totalWickets.text!
        //summaryDetailsVC._tournamentName = currentCell.tournamentName.text!
        
            presentViewController(summaryDetailsVC, animated: true, completion: nil)
        
    }

}
