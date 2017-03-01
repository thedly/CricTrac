//
//  NewMatchParent.swift
//  CricTrac
//
//  Created by Renjith on 8/26/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

protocol MatchParent:class {
    
    var selecetedData:[String:AnyObject]?{get set}
    var matchVC:MatchViewController! {get set}
    //var teamOROpponentFieldChanged : Bool!{get set}
    func dataChangedAfterLastSave()
}

