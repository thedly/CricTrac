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

    var _battingDetails = [String: String]()
    var _bowlingDetails = [String: String]()
    
    @IBOutlet weak var fixedHeader: UIView!
    @IBOutlet weak var performanceDetails: UICollectionView!
    let headerNib = UINib(nibName: "ProfileDetails", bundle: NSBundle.mainBundle())
    override func viewDidLoad() {
        super.viewDidLoad()

        _battingDetails = [
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
        
        _bowlingDetails = [
            "Overs": "12",
            "Wickets": "5",
            "Runs Given": "36",
            "Bowling Average": "24.16"
        ]

        fixedHeader.hidden = true
        
        self.setupCollectionView()

    }

    func setupCollectionView() {
        
        self.performanceDetails.dataSource = self
        self.performanceDetails.delegate = self
    
        if let layout: IOStickyHeaderFlowLayout = self.performanceDetails.collectionViewLayout as? IOStickyHeaderFlowLayout {
            layout.parallaxHeaderReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 274)
            layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 0)
            layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, layout.itemSize.height)
            
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = true
            
            self.performanceDetails.collectionViewLayout = layout
            
            self.performanceDetails.reloadData()
        }
    
        self.performanceDetails.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
        self.performanceDetails.registerNib(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "ProfileDetails")
    
        
    }

    
        func scrollViewDidScroll(scrollView: UIScrollView) {
            let scrollOffset = scrollView.contentOffset.y;
            
            
            if (scrollOffset >= 274.0)
            {
                fixedHeader.hidden = false
            }
            else
            {
                fixedHeader.hidden = true
            }
            
        }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _battingDetails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: performanceCell = collectionView.dequeueReusableCellWithReuseIdentifier("performanceCell", forIndexPath: indexPath) as! performanceCell
        
        var currentKey = ""
        var currentvalue = ""
        
        let index = _battingDetails.startIndex.advancedBy(indexPath.row) // index 1
        currentKey = _battingDetails.keys[index]
        currentvalue = _battingDetails[currentKey]!
        
        
        cell.configureCell(currentKey, pValue: currentvalue)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 50);
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case IOStickyHeaderParallaxHeader:
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ProfileDetails", forIndexPath: indexPath) as! ProfileDetails
            return cell
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "performanceHeader", forIndexPath: indexPath) as! UICollectionReusableView
            
            //headerView.backgroundColor = UIColor.blueColor();
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
}
