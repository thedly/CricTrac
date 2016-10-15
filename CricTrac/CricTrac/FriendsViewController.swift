//
//  FriendsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//




import UIKit
import XLPagerTabStrip

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    @IBOutlet weak var SuggestsTblview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    func initializeView() {
        
         SuggestsTblview.registerNib(UINib.init(nibName:"FriendsCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        
        SuggestsTblview.allowsSelection = false
        SuggestsTblview.separatorStyle = .None
        SuggestsTblview.dataSource = self
        SuggestsTblview.delegate = self
        
        setUIBackgroundTheme(self.view)

        
    }
    
    func getCellForRow(indexPath:NSIndexPath)->FriendsCell{
        
        
        let aCell =  SuggestsTblview.dequeueReusableCellWithIdentifier("FriendsCell", forIndexPath: indexPath) as! FriendsCell
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FRIENDS")
    }
    
    // MARK: - Table delegate functions
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return getCellForRow(indexPath)
        
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


