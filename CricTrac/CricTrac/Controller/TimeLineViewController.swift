//
//  TimeLineViewController.swift
//  CricTrac
//
//  Created by Renjith on 9/16/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var timeLineTable: UITableView!
    
    let  refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        refreshControl.attributedTitle = NSAttributedString(string: "Loading New Posts")
        refreshControl.addTarget(self, action: #selector(TimeLineViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        timeLineTable.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }

    
    func refresh(sender:AnyObject) {
        
        for _ in 1...10000000{}
        refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let acell = UITableViewCell()
        acell.backgroundColor = .whiteColor()
        return acell
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 10
    }
    
     func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
//                if !isNewDataLoading{

                //Get New Data
                
//                    }
                
                print("")
                
                }
            }
    
    
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        return 15
//    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let aView = UIView(frame: CGRectMake(0, 0, view.frame.width, 10) )
//        aView.backgroundColor = UIColor.clearColor()
//        
//        return aView
//    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let aView = UIView(frame: CGRectMake(0, 0, view.frame.width, 20) )
        aView.backgroundColor = UIColor.clearColor()
        
        return aView
    }
    
    @IBAction func exit(sender: UIButton) {
        
        dismissViewControllerAnimated(true) { 
            
        }
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
