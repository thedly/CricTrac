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
        matchSummaryTable.allowsSelection = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchSummaryViewController.newDataAdded), name: "MatchDataChanged" , object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func getCellForRow(indexPath:NSIndexPath)->SummaryCell{
        
        
        let aCell =  matchSummaryTable.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! SummaryCell
        
        let data = matchDataSource[indexPath.row]
        
        var totalruns:Double?
        
        if let runs = data["Runs"]{
            
            aCell.sumOne.text = runs
            totalruns = Double(runs)
        }
        if let wickets = data["Wickets"]{
            
            //aCell.totalWickets.text = "Wickets: "+wickets
        }
        
        
        
        if let date = data["Date"]{
            let dateArray = date.characters.split{$0 == "/"}.map(String.init)
            aCell.matchDate.text = dateArray[0]+" "+dateArray[1].monthName+" "+dateArray[2]
        }
        
        //        if let overs = data["OversBalled"]{
        //        aCell.overs.text = "Overs: "+overs
        //        }
        if let balls = data["Balls"]{
            aCell.sumTwo.text = balls
            if totalruns != nil{
                let totalBalls = Double(balls)!
                if totalBalls > 0{
                    
                    aCell.sumThree.text =  String(format: "%.0f",(totalruns!/totalBalls*100))
                }
            }
            else{
                aCell.sumThree.text = "-"
            }
        }
        
        
        if let opponent  = data["Opponent"]{
            aCell.oponentName.text = "vs "+opponent
        }
        if let venue = data["Ground"]{
            aCell.matchVenue.text = venue
        }
        else{
            aCell.matchVenue.text = ""
        }
        
        aCell.selectionStyle = .None
        aCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return aCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.matchDataSource.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        return getCellForRow(indexPath)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let summaryDetailsVC = viewControllerFrom("Main", vcid: "SummaryMatchDetailsViewController") as! SummaryMatchDetailsViewController
        
        summaryDetailsVC.matchDetailsData = matchDataSource[indexPath.row]
            presentViewController(summaryDetailsVC, animated: true, completion: nil)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }

}
