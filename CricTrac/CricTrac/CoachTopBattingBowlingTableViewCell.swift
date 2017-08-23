//
//  CoachTopBattingBowlingTableViewCell.swift
//  CricTrac
//
//  Created by AIPL on 22/08/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class CoachTopBattingBowlingTableViewCell: UITableViewCell {
    
    //Top batting
    @IBOutlet weak var topBattingPlayerName: UILabel!
    @IBOutlet weak var battingMatches: UILabel!
    @IBOutlet weak var battingAvg: UILabel!
    @IBOutlet weak var battingStrikeRate: UILabel!
    @IBOutlet weak var battingRuns: UILabel!
    
    //Top Bowling
    @IBOutlet weak var topBowlingPlayerName: UILabel!
    @IBOutlet weak var bowlingMatches: UILabel!
    @IBOutlet weak var bowlingAve: UILabel!
    @IBOutlet weak var bowlingStrikeRate: UILabel!
    @IBOutlet weak var BowlingRuns: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
