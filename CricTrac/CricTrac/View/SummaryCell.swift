//
//  SummaryCell.swift
//  CricTrac
//
//  Created by Renjith on 8/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {

    @IBOutlet weak var matchdate: UILabel!
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var ballsFaced: UILabel!
    @IBOutlet weak var matchMonth: UILabel!
    
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var overs: UILabel!
    @IBOutlet weak var machYear: UILabel!
    
    @IBOutlet weak var totalWickets: UILabel!
    @IBOutlet weak var totalRuns: UILabel!
    @IBOutlet weak var tournamentName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
