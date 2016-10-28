//
//  FriendSuggestViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 11/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FriendSuggestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
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
        SuggestsTblview.registerNib(UINib.init(nibName:"FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        SuggestsTblview.allowsSelection = false
        SuggestsTblview.separatorStyle = .None
        SuggestsTblview.dataSource = self
        SuggestsTblview.delegate = self
        
        setUIBackgroundTheme(self.view)
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "SUGGESTIONS")
    }
    
    // MARK: - Table delegate functions
    
    
        
    @IBAction func getAllProfilesBtnPressed(sender: AnyObject) {
        getAllProfiles({ resultObj in
            
            for profile in resultObj {
                
                UserProfilesData.append(Profile(usrObj: profile))
                if let _imageUrl = profile["ProfileImageUrl"] as? String where _imageUrl != ""  {
                    getImageFromFirebase(_imageUrl) { (data) in
                        UserProfilesImages[_imageUrl] = data
                    }
                }
            }
            
            
            
            
            self.SuggestsTblview.reloadData()
        })
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserProfilesData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        return getCellForRow(indexPath)
        
    }
    
    func getCellForRow(indexPath:NSIndexPath)->FriendSuggestionsCell{
        
        
        let aCell =  SuggestsTblview.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as! FriendSuggestionsCell
        
        aCell.configureCell(UserProfilesData[indexPath.row])
        aCell.backgroundColor = UIColor.clearColor()
        return aCell
        
        
        
        
        
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

