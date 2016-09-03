//
//  NewMatchParent.swift
//  CricTrac
//
//  Created by Renjith on 8/26/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

protocol MatchParent:class {
    
    var selecetedData:[String:String]?{get set}
    
    func dataChangedAfterLastSave()
}

