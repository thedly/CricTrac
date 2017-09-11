//
//  MatchSummaryData.swift
//  CricTrac
//
//  Created by Tejas Hedly on 01/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class MatchSummaryData {
    
    var matchId: String!
    var opponentName: String!
    var battingBowlingScore: NSMutableAttributedString!
    var matchDateAndVenue: String!
    var ground: String!
    var strikerate: Float!
    var economy: Float!
    var BattingSectionHidden: Bool!
    var BowlingSectionHidden: Bool!
    var matchDate: NSDate!
    var ageGroup: String!
    var level: String!
    
    
    //for Coach Match Date - to be moved to a different file
    var playerId: String!
    var totalMatches: Int!
    var totalRunsTaken: Int!
    var totalWicketsTaken: Int!
    var totalBatInnings: Int!
    var totalBowlInnings: Int!
    var batAverage:Float = 0
    var bowlAverage:Float = 0
    var strikeRate: Float!
    //var economy: Float!
    var totalRunsGiven: Int!
    var dispHS: String!
    var dispBB: String!
    var totalDismissal: Int!
    var totalOversBowled: Float!
    var totalBallsFaced: Int!
    
}