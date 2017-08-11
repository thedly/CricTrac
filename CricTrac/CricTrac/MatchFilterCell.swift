//
//  MatchFilterCell.swift
//  CricTrac
//
//  Created by Arjun Innovations on 09/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class MatchFilterCell: UITableViewCell {
   
    // For TotalMatches
    @IBOutlet weak var totalMatchesLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var strikeRate: UILabel!
    @IBOutlet weak var battingAvg: UILabel!
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var runs: UILabel!
    @IBOutlet weak var bowlingMatches: UILabel!
    @IBOutlet weak var wickets: UILabel!
    @IBOutlet weak var economy: UILabel!
    @IBOutlet weak var bowlingAvg: UILabel!
    //height constraints
    @IBOutlet weak var view1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view4heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalDividerView: NSLayoutConstraint!
    @IBOutlet weak var verticalDividerView: NSLayoutConstraint!
    
    @IBOutlet weak var subView3: UIView!
    @IBOutlet weak var subView4: UIView!
    @IBOutlet weak var subView1: UIView!
    @IBOutlet weak var subView2: UIView!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
