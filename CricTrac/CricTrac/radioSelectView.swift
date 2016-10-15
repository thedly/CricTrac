//
//  radioSelectView.swift
//  CricTrac
//
//  Created by Tejas Hedly on 12/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class radioSelectView: UILabel {

    private var _isSelected: Bool = false
    
    var isSelected: Bool {
        get {
            return _isSelected
        }
        set {
            _isSelected  = newValue
            self.alpha = _isSelected ? 1 : 0.3
        }
    }
    
    

}
