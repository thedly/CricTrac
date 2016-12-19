//
//  ThemeColorsCollectionViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ThemeColorsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var ThemeTitle: UILabel!
    
    var cellTopColor : String!
    var cellBottomColor : String!
    var theme:String!
    
    private var _cellIsSelected: Bool = false
    
    var cellIsSelected: Bool {
        get {
            return _cellIsSelected
        }
        set {
            _cellIsSelected = newValue
            if _cellIsSelected {
                self.alpha = 1.0
                self.layer.borderWidth = 5
                self.layer.borderColor = UIColor.whiteColor().CGColor
            }
            else {
                self.alpha = 0.3
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clearColor().CGColor
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    
}
