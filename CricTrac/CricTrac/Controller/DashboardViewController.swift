//
//  DashboardViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import KRProgressHUD

class DashboardViewController: UIViewController,UITabBarDelegate,UITableViewDataSource {

    @IBOutlet weak var battingBtn: UIButton!
    @IBOutlet weak var bowlingBtn: UIButton!
    @IBOutlet weak var battingSelectedIndicator: UIView!
    @IBOutlet weak var bowlingSelectedIndicator: UIView!
    
    @IBOutlet weak var performanceTable: UITableView!
    // Variables And Constants
    
    var battingDetails: [String:String]!
    var bowlingDetails: [String:String]!
    var recentMatches: [String:String]!
    
    var userHasAuthenticated = false
    
    // MARK: View controller Delegates and related methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarProperties()
        initializeView()
        getPerformanceDetails()
        
        KRProgressHUD.dismiss()
        
        
//         FIRAuth.auth()?.createUserWithEmail("test@ctest.com", password: "pwds12345") { (user, error) in}
//        
//         FIRAuth.auth()?.signInWithEmail("test@ctest.com", password: "pwds12345", completion: { (user, error) in
//         
//         if user != nil {
//         
//         self.userHasAuthenticated = true
//            
//            
//            
//            self.getData()
//         }
//         
//         })
        
        
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        
        let rootRef = FIRDatabase.database().referenceFromURL("https://ctest-66a38.firebaseio.com")
        
        rootRef.child("TestValue_Renjith").setValue(["test1":["One","Two","Three"]])
        
        //rootRef.setValue("TestValue_Renjith")
        
       // rootRef.child("users").child("RenjithTestOne").removeValue()

        rootRef.child("TestValue_Renjith").observeEventType(.Value, withBlock: { (snap) in
            
            print(snap)
            
            }) { (error) in
                
                print(error.description)
        }
        
    }
    
    func initializeView() {
        bowlingSelectedIndicator.hidden = true
        battingSelectedIndicator.hidden = false
        
        battingBtn.setTitleColor(UIColor(hex:"D8D8D8"), forState: UIControlState.Normal)
        bowlingBtn.setTitleColor(UIColor(hex:"D8D8D8"), forState: UIControlState.Normal)
        
        battingBtn.tintColor = UIColor.clearColor()
        bowlingBtn.tintColor = UIColor.clearColor()
        
        bowlingBtn.setTitleColor(UIColor(hex:"6D9447"), forState: UIControlState.Selected)
        battingBtn.setTitleColor(UIColor(hex:"6D9447"), forState: UIControlState.Selected)
        
        battingBtn.selected = true
    }
    
    //Sets button for Slide menu, Title and Navigationbar Color
    func setNavigationBarProperties(){
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        
        let addNewMatchButton: UIButton = UIButton(type:.Custom)
        addNewMatchButton.frame = CGRectMake(0, 0, 40, 40)
        addNewMatchButton.setTitle("+", forState:.Normal)
        addNewMatchButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 30)
        addNewMatchButton.addTarget(self, action: #selector(didNewMatchButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        let righttbarButton = UIBarButtonItem(customView: addNewMatchButton)
        
        //assign button to navigationbar
        
        navigationItem.leftBarButtonItem = leftbarButton
         navigationItem.rightBarButtonItem = righttbarButton
        navigationController!.navigationBar.barTintColor = UIColor(hex:"B12420")
        title = "Dashboard"
        let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    // MARK: Button Actions
    
    @IBAction func BattingTabSelected(sender: UIButton) {
        
        bowlingSelectedIndicator.hidden = true
        battingSelectedIndicator.hidden = false
        battingBtn.selected = true
        bowlingBtn.selected = false
        performanceTable.reloadData()
        
    }
    @IBAction func BowlingTabSelected(sender: UIButton) {
        
        bowlingSelectedIndicator.hidden = false
        battingSelectedIndicator.hidden = true
        battingBtn.selected = false
        bowlingBtn.selected = true
        performanceTable.reloadData()
    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didNewMatchButtonTapp(){
        
        let newMatchVc = viewControllerFrom("Main", vcid: "NewMatchViewController")
        self.presentViewController(newMatchVc, animated: true) {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
      // MARK: TableView DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("performanceCell", forIndexPath: indexPath) as? performanceCell {
            
                //print(battingDetails)
            
                var currentKey :String?
                var currentvalue :String?
            
            if indexPath.section == 0
            {
            
                if battingBtn.selected {
                    
                    let index = battingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                    currentKey = battingDetails.keys[index]
                    currentvalue = battingDetails[currentKey!]!
                }
                else
                {
                    let index = bowlingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                    currentKey = bowlingDetails.keys[index]
                    currentvalue = bowlingDetails[currentKey!]!
                }
            }
            else
            {
                let index = recentMatches.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
                currentKey = recentMatches.keys[index]
                currentvalue = recentMatches[currentKey!]!
                
            }
            
            cell.configureCell(currentKey!, pValue: currentvalue!)
            return cell
        }
        else
        {
            return UITableViewCell()
            
            
            
        }
        
        

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recent Matches"
        }
        else
        {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let vw = UIView()
            let headerLbl = UILabel(frame: CGRectMake(20, 10, UIScreen.mainScreen().bounds.size.width, 30))
            headerLbl.textColor = UIColor(hex: "6D9447")
            headerLbl.font = UIFont(name: "SFUIText-Bold", size: 20)
            //headerLbl.font = UIFont.boldSystemFontOfSize(20)
            headerLbl.text = "Recent Matches"
            vw.addSubview(headerLbl)
            
            vw.backgroundColor = UIColor.clearColor()
            return vw
        }
        return nil
 }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? battingBtn.selected ? battingDetails.count : bowlingDetails.count : 3
    }
 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
        
    // MARK: Service Calls
    
    func getPerformanceDetails() {
        
        
        
        // Make API call
        
        battingDetails = [
            "Matches": "123",
            "Innings": "116",
            "Not Out": "12",
            "Runs": "1028",
            "High Score": "80",
            "Average": "32",
            "Balls Faced": "-",
            "SR": "-",
            "100s": "0",
            "50s": "1",
            "4s": "25",
            "6s": "15"
        ]
        
        bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs Given": "36",
            "Bowling Average": "24.16"
        ]
        
        recentMatches = [
            "Against DPS South": "46",
            "Against ISB" : "41",
            "Against JOJO Mysore": "30"
        ]
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
