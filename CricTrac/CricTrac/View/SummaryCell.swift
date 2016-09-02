//
//  SummaryCell.swift
//  CricTrac
//
//  Created by Renjith on 8/20/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {

    
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var header1Lbl: UILabel!
    @IBOutlet weak var header2Lbl: UILabel!
    @IBOutlet weak var header3Lbl: UILabel!
    
    
    @IBOutlet weak var value1Lbl: UILabel!
    @IBOutlet weak var value2Lbl: UILabel!
    @IBOutlet weak var value3Lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(playingRole:String,value1:String,value2:String,value3:String){
        
        
//        switch playingRole {
//        case "Batsman","Wicketkeeper","Wicketkeeper batsman","Opening batsman", "Top-order batsman", "Lower-order batsman":
//            <#code#>
//        case "Bowling all-rounder", "Bowler":
//            <#code#>
//        }
//        
//        header1Lbl.text = header1
//        header2Lbl.text = header2
//        header3Lbl.text = header3
//        
//        value1Lbl.text = value1
//        value2Lbl.text = value2
//        value3Lbl.text = value3
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
