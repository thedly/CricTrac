//
//  CollectionFlowLayoutVC.swift
//  CricTrac
//
//  Created by Tejas Hedly on 19/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import CSStickyHeaderFlowLayout

class CollectionFlowLayoutVC: UICollectionViewController {

    var items : [String] = ["CSStickyHeaderFlowLayout basic example", "Example to initialize in code", "As well as in Swift", "Please Enjoy"]
    
    var headerNib : UINib!

    private var layout : CSStickyHeaderFlowLayout? {
        return self.collectionView?.collectionViewLayout as? CSStickyHeaderFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerNib = UINib(nibName: "ProfileDetails", bundle: NSBundle.mainBundle())
        
        self.collectionView?.alwaysBounceVertical = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Setup Cell
        self.collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.layout?.itemSize = CGSizeMake(self.view.frame.size.width, 44)
        
        self.collectionView?.registerNib(self.headerNib, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "ProfileDetails")
        
        // Setup Header
        //self.collectionView?.registerClass(CollectionParallaxHeader.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "parallaxHeader")
        self.layout?.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 100)
        
        // Setup Section Header
        self.collectionView?.registerClass(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        self.layout?.headerReferenceSize = CGSizeMake(320, 40)
    }
    
    // Cells
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.text = self.items[indexPath.row]
        return cell
    }
    
    // Parallax Header
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == CSStickyHeaderParallaxHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "parallaxHeader", forIndexPath: indexPath)
            return view
        } else if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionHeader", forIndexPath: indexPath)
            view.backgroundColor = UIColor.lightGrayColor()
            return view
        }
        
        return UICollectionReusableView()
        
    }

}
