//
//  CoachPlayersListViewController.swift
//  CricTrac
//
//  Created by AIPL on 30/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachPlayersListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ThemeChangeable {

    
    @IBOutlet weak var CoachPlayersTableView: UITableView!
    let currentTheme = cricTracTheme.currentTheme

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeView()
    }
    
    override func viewWillAppear(animated: Bool) {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        setBackgroundColor()
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func initializeView() {
        CoachPlayersTableView.registerNib(UINib.init(nibName: "FriendSuggestionsCell", bundle: nil), forCellReuseIdentifier: "FriendSuggestionsCell")
        
        CoachPlayersTableView.allowsSelection = false
        CoachPlayersTableView.separatorStyle = .None
    }
    
    func changeThemeSettigs() {
        self.view.backgroundColor = currentTheme.topColor
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendSuggestionsCell", forIndexPath: indexPath) as! FriendSuggestionsCell
        cell.userName.text = "Arjun"
        cell.userCity.text = "Bangalore"
        cell.backgroundColor = UIColor.clearColor()
        cell.baseView.backgroundColor = currentTheme.bottomColor
        cell.AddFriendBtn.setTitle("Remove", forState: .Normal)
        
        return cell
    }
    
    
}
