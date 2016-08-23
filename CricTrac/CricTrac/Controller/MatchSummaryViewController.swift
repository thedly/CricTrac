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
                
                var dataDict = val as! [String:String]
                dataDict["key"] = key
                self.matchDataSource.append(dataDict)
                self.matchSummaryTable.reloadData()
            }
            KRProgressHUD.dismiss()
        }
    }

    func getCellForRow(indexPath:NSIndexPath)->SummaryCell{
        
        
        let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! SummaryCell
        
         let data = matchDataSource[indexPath.row]
        
        
        if let runs = data["Runs"]{
            
            aCell.totalRuns.text = "Runs: "+runs
        }
        if let wickets = data["Wickets"]{
            
            aCell.totalWickets.text = "Wickets: "+wickets
        }
        
        if let tournament = data["Tournamnet"]{
            
            if tournament == "-"{
                
                aCell.tournamentName.text = "Unamed Tournament"
            }
            else{
                aCell.tournamentName.text = tournament
            }
            
        }
        
        if let date = data["Date"]{
        let dateArray = date.characters.split{$0 == "/"}.map(String.init)
        aCell.machYear.text = dateArray[2]
        aCell.matchdate.text = dateArray[0]
        aCell.matchMonth.text = dateArray[1].monthName
        }
        
        if let overs = data["OversBalled"]{
        aCell.overs.text = "Overs: "+overs
        }
        if let balls = data["Balls"]{
        aCell.ballsFaced.text = "Balls: "+balls
        }
        if let result = data["Result"]{
            
        if result == "-"{
            aCell.result.text = "No Result Entered"
            }
        else{
        aCell.result.text = result
            }
        }
        if let result = data["Sixes"]{
        aCell.sixes.text = "Sixes: "+result
        }
        if let result = data["Sixes"]{
        aCell.fours.text = "Fours: "+result
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

}
