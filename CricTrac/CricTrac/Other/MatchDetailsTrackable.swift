//
//  MatchDetailsTrackable.swift
//  CricTrac
//
//  Created by Renjith on 8/24/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import UIKit

protocol MatchDetailsTrackable:class {
    
    var teamText:UITextField!{get set}
    var opponentText:UITextField!{get set}
}