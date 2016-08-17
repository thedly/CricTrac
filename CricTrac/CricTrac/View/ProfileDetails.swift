//
//  ProfileDetails.swift
//  CricTrac
//
//  Created by Tejas Hedly on 17/07/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileDetails: UICollectionViewCell {
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        profileImage.layer.cornerRadius = 32.0
        
    }
    
    
    
}
