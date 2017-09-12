//
//  PlayerMatchesData.swift
//  CricTrac
//
//  Created by AIPL on 11/09/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class PlayerMatchesData {
    
    var playerId: String!
    var totalMatches: Int!
    var totalRunsTaken: Int!
    var totalWicketsTaken: Int!
    var totalBatInnings: Int!
    var totalBowlInnings: Int!
    var batAverage:Float = 0
    var bowlAverage:Float = 0
    var strikeRate: Float!
    var economy: Float!
    var totalRunsGiven: Int!
    var dispHS: String!
    var dispBB: String!
    var totalDismissal: Int!
    var totalOversBowled: Float!
    var totalBallsFaced: Int!
}