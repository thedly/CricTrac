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
    var showProfileDetails: Bool = false
    var data = [[String:String]]()
   
    var battingBtn: UIButton!
    
    var bowlingBtn: UIButton!
    
    var battingSelector: UIView!
    
    var bowlingSelector: UIView!
    
    var performanceDetails: UICollectionView!
    
    var headerBtnsInitialized: Bool = false
    
   
    var collapseBtn: UIButton!
    
    
    func battingTapped(sender: UIButton) {
        battingBtn.selected = true
        bowlingBtn.selected = false
        bowlingSelector.hidden = true
        battingSelector.hidden = false
        performanceDetails.resetScrollPositionToTop()
        performanceDetails.reloadData()
    }
    
    
    func bowlingTapped(sender: UIButton) {
        battingBtn.selected = false
        bowlingBtn.selected = true
        bowlingSelector.hidden = false
        battingSelector.hidden = true
        performanceDetails.resetScrollPositionToTop()
        performanceDetails.reloadData()
    }
    
    
    
    func collapseBtnToggled(sender: UIButton) {
        
        showProfileDetails = !showProfileDetails
        collapseBtn.selected = showProfileDetails
        
        let layout: IOStickyHeaderFlowLayout  = self.performanceDetails.collectionViewLayout as! IOStickyHeaderFlowLayout
        
        
        self.performanceDetails.resetScrollPositionToTop()
        
        let scrollTo: CGFloat = self.showProfileDetails == false ? 100.0 : 250.0
        
        layout.parallaxHeaderReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width + 4, scrollTo)
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollTo)
        
    }
    
        
        
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

       
        self.setupCollectionView()

    }
    
    func didMenuButtonTapp(){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func didNewMatchButtonTapp(){
        
        let newMatchVc = viewControllerFrom("Main", vcid: "NewMatchViewController")
        self.presentViewController(newMatchVc, animated: true) {}
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


    func setupCollectionView() {
        
        self.performanceDetails.dataSource = self
        self.performanceDetails.delegate = self
        
        adjustLayout()
        setNavigationBarProperties()
    }
    


    
    func adjustLayout() {
        
        
        self.headerNib = UINib(nibName: "ProfileDetails", bundle: NSBundle.mainBundle())
        
        
        
        if let layout: IOStickyHeaderFlowLayout = self.performanceDetails.collectionViewLayout as? IOStickyHeaderFlowLayout {
            
            let scrollTo: CGFloat = self.showProfileDetails == false ? 100.0 : 250.0
            
            layout.parallaxHeaderReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width + 4, scrollTo)
            layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, scrollTo)
            
            
    
            
            layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, layout.itemSize.height)
            
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = false
            
            self.performanceDetails.collectionViewLayout = layout
        }
        self.performanceDetails.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.performanceDetails.backgroundColor = UIColor.clearColor()
        
        self.performanceDetails.registerNib(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "ProfileDetails")
        
        
        
        
        //self.performanceDetails.reloadData()
        
        
    }
    
    
    func initializeHeaderBtns() {
        
       
        battingBtn.setTitleColor(UIColor(hex: "D8D8D8"), forState: .Normal)
        battingBtn.setTitleColor(UIColor(hex: "6D9447"), forState: .Selected)
        bowlingBtn.setTitleColor(UIColor(hex: "D8D8D8"), forState: .Normal)
        bowlingBtn.setTitleColor(UIColor(hex: "6D9447"), forState: .Selected)
        
        collapseBtn.setImage(UIImage(named: "up"), forState: .Selected)
        collapseBtn.setImage(UIImage(named: "down"), forState: .Normal)
        
        
        battingBtn.tintColor = UIColor.clearColor()
        bowlingBtn.tintColor = UIColor.clearColor()
        
        battingBtn.selected = true
        collapseBtn.selected = showProfileDetails
        headerBtnsInitialized = true
        
    }
    
    
    
    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.bowlingBtn != nil && self.bowlingBtn.selected ? _bowlingDetails.count : _battingDetails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PerformanceCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("PerformanceCollectionViewCell", forIndexPath: indexPath) as! PerformanceCollectionViewCell
        
        var currentKey :String?
        var currentvalue :String?
        
        
        if self.bowlingBtn != nil && self.bowlingBtn.selected {
            let index = _bowlingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
            
            currentKey = _bowlingDetails.keys[index]
            currentvalue = _bowlingDetails[currentKey!]!
        }
        else
        {
            let index = _battingDetails.startIndex.advancedBy(indexPath.row) as DictionaryIndex<String,String>
            
            currentKey = _battingDetails.keys[index]
            currentvalue = _battingDetails[currentKey!]!
        }
        
        
        
        
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "performanceHeader", forIndexPath: indexPath)
            
            battingBtn = headerView.viewWithTag(1) as! UIButton
            battingBtn.addTarget(self, action: #selector(parallaxVC.battingTapped(_:)), forControlEvents: .TouchUpInside)
            
            bowlingBtn = headerView.viewWithTag(2) as! UIButton
            bowlingBtn.addTarget(self, action: #selector(parallaxVC.bowlingTapped(_:)), forControlEvents: .TouchUpInside)
            
            
            battingSelector = headerView.viewWithTag(3)
            bowlingSelector = headerView.viewWithTag(4)
            
            collapseBtn = headerView.viewWithTag(5) as! UIButton
            collapseBtn.addTarget(self, action: #selector(parallaxVC.collapseBtnToggled(_:)), forControlEvents: .TouchUpInside)
            
            if !headerBtnsInitialized {
                initializeHeaderBtns()
            }
            
            
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
            //assert(false, "Unexpected element kind")
            
        }
    }
    
}
