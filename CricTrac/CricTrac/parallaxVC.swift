//
//  parallaxVC.swift
//  CricTrac
//
//  Created by Tejas Hedly on 17/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import IOStickyHeader




class parallaxVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var headerNib : UINib!;

    var _battingDetails = [String: String]()
    var _bowlingDetails = [String: String]()
    
    var data = [[String:String]]()
   
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var fixedHeader: UIView!
    @IBOutlet weak var performanceDetails: UICollectionView!
    
    var ProfileDetailsInstance: ProfileDetails!
    var switchDemo: UISwitch!
    @IBOutlet weak var AddNewDataBtn: UIButton!
    
    
    //addImageBtn.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
    
    @IBAction func tabChanged(sender: UISegmentedControl) {
        adjustLayout()
        
//        if Tabs.selectedSegmentIndex == 2 {
//            
//            
//            
//           self.performanceDetails.setContentOffset(CGPointZero, animated: true)
//            
//        }
//        else
//        {
//            
//            self.performanceDetails?.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: Tabs.selectedSegmentIndex), atScrollPosition: .Top, animated: true)
//            
//        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //            self.performanceDetails?.scrollToItemAtIndexPath(NSIndexPath(forItem:  0, inSection: 0), atScrollPosition: .Top, animated: true)
        
        data = [
            [
                "Matches": "123",
                "Innings": "116",
                "Not_Out": "12",
                "Runs": "1028",
                "High_Score": "80",
                "Average": "32",
                "Balls Faced": "-",
                "SR": "-",
                "100s": "0",
                "50s": "1",
                "4s": "25",
                "6s": "15"
            ],
            [
                "Overs": "12",
                "Wickets": "5",
                "Runs_Given": "36",
                "Bowling_Average": "24.16"
            ]
        
        ]
        
        
        _battingDetails = [
            "Matches": "123",
            "Innings": "116",
            "Not_Out": "12",
            "Runs": "1028",
            "High_Score": "80",
            "Average": "32",
            "Balls_Faced": "-",
            "SR": "-",
            "100s": "0",
            "50s": "1",
            "4s": "25",
            "6s": "15"
        ]
        
        _bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs_Given": "36",
            "Bowling_Average": "24.16"
        ]

        
//        switchDemo=UISwitch(frame:CGRectMake(150, 300, 0, 0));
//        switchDemo.on = true
//        switchDemo.setOn(true, animated: false);
//        switchDemo.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged);
        
        
        self.setupCollectionView()

    }

//    func switchValueDidChange(sender: UISwitch){
//        print("switch changed")
//    }
    
    func setupCollectionView() {
        
        self.performanceDetails.dataSource = self
        self.performanceDetails.delegate = self
    
        
        adjustLayout()
        
        
        self.AddNewDataBtn.hidden = false
    }
    


    
    func adjustLayout() {
        
        
        self.headerNib = UINib(nibName: "ProfileDetails", bundle: NSBundle.mainBundle())
        
        
        
        if let layout: IOStickyHeaderFlowLayout = self.performanceDetails.collectionViewLayout as? IOStickyHeaderFlowLayout {
            layout.parallaxHeaderReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width + 4, 274)
            layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 100)
            
            
    
            
            layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, layout.itemSize.height)
            
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = false
            
            self.performanceDetails.collectionViewLayout = layout
        }
        self.performanceDetails.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        self.performanceDetails.registerNib(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "ProfileDetails")
        
        
        
        
        //self.performanceDetails.reloadData()
        
        
    }
    
    
    
    
    
    
    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: performanceCell = collectionView.dequeueReusableCellWithReuseIdentifier("performanceCell", forIndexPath: indexPath) as! performanceCell
        
        var currentKey :String?
        var currentvalue :String?
        
        let index = data[indexPath.section].startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
        
        currentKey = data[indexPath.section].keys[index]
        currentvalue = data[indexPath.section][currentKey!]!
        
        cell.configureCell(currentKey!, pValue: currentvalue!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 34);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }
    func tabsChanged(sender: UISegmentedControl){
        print("tab changed")
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "performanceHeader", forIndexPath: indexPath)
            
            let segCtrl = headerView.viewWithTag(200) as! UISegmentedControl

            segCtrl.addTarget(self, action: "tabsChanged:", forControlEvents: .ValueChanged)
            
            return headerView
        
        case IOStickyHeaderParallaxHeader:
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ProfileDetails", forIndexPath: indexPath) as! ProfileDetails
            
            return cell
            
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "performanceFooter", forIndexPath: indexPath)
            
            return footerView
       
        default:
            //Just to make code run adding this 
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "performanceFooter", forIndexPath: indexPath)
            
            return footerView
            assert(false, "Unexpected element kind")
            
        }
    }
    
}
