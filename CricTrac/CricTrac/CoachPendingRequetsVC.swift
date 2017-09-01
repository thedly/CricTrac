//
//  CoachPendingRequetsVC.swift
//  CricTrac
//
//  Created by AIPL on 31/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachPendingRequetsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    @IBOutlet weak var RequestsTblview: UITableView!
    
    let currentTheme = cricTracTheme.currentTheme
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
    }
    
    func initializeView() {
        RequestsTblview.registerNib(UINib.init(nibName:"FriendRequestsCell", bundle: nil), forCellReuseIdentifier: "FriendRequestsCell")
        RequestsTblview.allowsSelection = false
        RequestsTblview.separatorStyle = .None
        RequestsTblview.dataSource = self
        RequestsTblview.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = currentTheme.topColor
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = RequestsTblview.dequeueReusableCellWithIdentifier("FriendRequestsCell", forIndexPath: indexPath) as! FriendRequestsCell
        cell.FriendName.text = "Rahul"
        cell.backgroundColor = UIColor.clearColor()
        cell.baseView.backgroundColor = currentTheme.bottomColor
        cell.baseView.alpha = 1
        cell.cancelBtn.hidden = true
        return cell
    }
    
    
}
