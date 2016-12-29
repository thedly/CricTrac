//
//  TeamCollectionViewCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 29/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var TeamName : UILabel!
    @IBOutlet weak var TeamImage : UIImageView!
    @IBOutlet weak var TeamAbbr: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if TeamImage.image != nil
        {
            TeamAbbr.hidden = true
        }
        else
        {
            TeamImage.hidden = true
        }
        
        
        baseView.layer.cornerRadius = baseView.frame.size.width/2
    }
}
