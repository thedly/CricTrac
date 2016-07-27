//
//  summaryTableViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 27/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class summaryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellDate: UILabel!
    @IBOutlet weak var cellRuns: UILabel!
    @IBOutlet weak var cellFours: UILabel!
    @IBOutlet weak var cellSixes: UILabel!
    @IBOutlet weak var cellOvers: UILabel!
    @IBOutlet weak var cellResults: UILabel!
    @IBOutlet weak var cellWickets: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_date:String, _runs:String, _fours:String, _sixes:String, _overs:String, _results: String, _wickets:String ){
        cellDate.text = _date
        cellRuns.text = _runs
        cellFours.text = _fours
        cellOvers.text = _overs
        cellSixes.text = _sixes
        cellResults.text = _results
        cellWickets.text = _wickets
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
