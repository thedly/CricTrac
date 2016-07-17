//
//  performanceCell.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class performanceCell: UICollectionViewCell {

    
    @IBOutlet weak var performanceKey: UILabel!
    @IBOutlet weak var performanceValue: UILabel!
    
    func configureCell(pKey: String, pValue: String){
        performanceKey.text = pKey
        performanceValue.text = pValue
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
