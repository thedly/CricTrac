//
//  SummaryDetailsCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 23/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SummaryDetailsCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!

    @IBOutlet weak var oponentName: UILabel!
    @IBOutlet weak var BattingOrBowlingScore: UILabel!
    @IBOutlet weak var vsView: UIView!
    
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var strikeRateLabel: UILabel!
    @IBOutlet weak var economyLabel: UILabel!
    
    @IBOutlet weak var matchDateAndVenue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 10
        baseView.clipsToBounds = true
        
        setColorForViewsWithSameTag(self)
        
        baseView.alpha = 0.7
        
        
        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: UIColor().hexFromUIColor(cricTracTheme.currentTheme.bottomColor)))
        
        self.baseView.alpha = 0.8

        self.selectionStyle = .None
        //self.vsView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: "#660000"))
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
