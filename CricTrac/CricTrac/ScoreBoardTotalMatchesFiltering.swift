//
//  ScoreBoardTotalMatchesFiltering.swift
//  CricTrac
//
//  Created by AIPL on 04/07/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class ScoreBoardTotalMatchesFiltering: UIView {

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
    
    @IBOutlet weak var horizontalDividerView: NSLayoutConstraint!
    
    @IBOutlet weak var verticalDividerView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
}
