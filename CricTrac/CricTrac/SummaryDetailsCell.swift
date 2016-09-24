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
    
    @IBOutlet weak var BallsAndStrikeRate: UILabel!
    @IBOutlet weak var totalRuns: UILabel!
    @IBOutlet weak var matchDateAndVenue: UILabel!
    
    @IBOutlet weak var oversAndEconomy: UILabel!
    @IBOutlet weak var BallsBowledWithWicketsTaken: UILabel!
    @IBOutlet weak var battingView: UIView!
    
    var bowlingViewHidden:Bool = true
    var battingViewHidden:Bool = true
    
    @IBOutlet weak var bowlingView: UIView!
    
    @IBOutlet weak var bowlingHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var battingHeightConsraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.baseView.layer.cornerRadius = 10
        self.baseView.clipsToBounds = true
        self.baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: bottomColor))
        self.baseView.alpha = 0.6
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
