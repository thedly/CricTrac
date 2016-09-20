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
    
    var timelineDS = [[String:String]]()
    
    let  refreshControl = UIRefreshControl()
    var totalPosts = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       loadTimeLineData()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading New Posts")
        refreshControl.addTarget(self, action: #selector(TimeLineViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        timeLineTable.addSubview(refreshControl)
        
        
          timeLineTable.registerNib(UINib.init(nibName:"AddPostTableViewCell", bundle: nil), forCellReuseIdentifier: "addpost")
        
        timeLineTable.registerNib(UINib.init(nibName:"APostTableViewCell", bundle: nil), forCellReuseIdentifier: "aPost")
        
        // Do any additional setup after loading the view.
    }

    
    
    func refresh(sender:AnyObject) {
        
        for _ in 1...10000000{}
        refreshControl.endRefreshing()
    }
    
    
    func loadTimeLineData(){
        
        loadTimeline { (timeline) in
            
            
            if let timelinedata = timeline as? [String:[String:String]]{
                
                for (_,val) in timelinedata{
                    
                    self.timelineDS.append(val)
                    
                }
                
                self.timeLineTable.reloadData()
                
                loadAllPostIds({
                    
                    loadTimelineFromId({ (timeline,postId) in
                        
                        self.timelineDS.append(timeline as! [String : String])
                        
                    })
                    
                })
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var acell = UITableViewCell()
        
        if indexPath.section == 0{
            
             acell =  timeLineTable.dequeueReusableCellWithIdentifier("addpost", forIndexPath: indexPath)
        }
        else{
           let  postCell =  timeLineTable.dequeueReusableCellWithIdentifier("aPost", forIndexPath: indexPath) as! APostTableViewCell
            
            let data = timelineDS[indexPath.section-1]
            postCell.post.text = data["post"]
            acell = postCell
            
        }
        
        
        acell.backgroundColor = .whiteColor()
        return acell
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return timelineDS.count+1
    }
    
     func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{return 150}
        return 200
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {


                timeLineTable.reloadData()

                loadTimelineFromId({ (timeline,postId) in
                    
                    self.timelineDS.append(timeline as! [String : String])
                    
                })
                
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
