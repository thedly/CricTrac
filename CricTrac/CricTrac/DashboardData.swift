//
//  DashboardData.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

class DashboardData {
    var BattingInnings: String!
    var BowlingInnings: String!
    var ChaseWinPercentage: String!
    var FirstBattingCount: String!
    var FirstBattingWins: String!
    var SecondBattingCount: String!
    var SecondBattingWins: String!
    var TopBatting1stMatch: String!
    var TopBatting1stMatchDate: String!
    var TopBatting1stMatchGround: String!
    var TopBatting1stMatchOpp: String!
    var TopBatting1stMatchScore: String!
    var TopBatting2ndMatch: String!
    var TopBatting2ndMatchDate: String!
    var TopBatting2ndMatchGround: String!
    var TopBatting2ndMatchOpp: String!
    var TopBatting2ndMatchScore: String!
    var TopBatting3rdMatch: String!
    var TopBatting3rdMatchDate: String!
    var TopBatting3rdMatchGround: String!
    var TopBatting3rdMatchOpp: String!
    var TopBatting3rdMatchScore: String!
    var TopBowling1stMatchID: String!
    var TopBowling1stMatchScore: String!
    var TopBowling1stMatchOpp: String!
    var TopBowling1stMatchDate: String!
    var TopBowling1stMatchGround: String!
    var TopBowling2ndMatchID: String!
    var TopBowling2ndMatchScore: String!
    var TopBowling2ndMatchDate: String!
    var TopBowling2ndMatchGround: String!
    var TopBowling2ndMatchOpp: String!
    var TopBowling3rdMatchID: String!
    var TopBowling3rdMatchScore: String!
    var TopBowling3rdMatchDate: String!
    var TopBowling3rdMatchOpp: String!
    var TopBowling3rdMatchGround: String!
    var Total100s: String!
    var Total3Wkts: String!
    var Total4s: String!
    var Total50s: String!
    var Total5Wkts: String!
    var Total6s: String!
    var TotalBallsFaced: String!
    var TotalBattingAverage: String!
    var TotalBowlingAverage: String!
    var TotalDucks: String!
    var TotalEconomy: String!
    var TotalMaidens: String!
    var TotalMatches: String!
    var TotalNBs: String!
    var TotalNotOut: String!
    var TotalOvers: String!
    var TotalRuns: String!
    var TotalRunsGiven: String!
    var TotalStrikeRate: String!
    var TotalWickets: String!
    var TotalWides: String!
    var TotalWins: String!
    var WinPercentage: String!
    
    
    init(dataObj: [String: AnyObject!]){
        self.BattingInnings = String(dataObj["BattingInnings"] ?? "0")
        self.BowlingInnings = String(dataObj["BowlingInnings"] ?? "0")
        self.ChaseWinPercentage = String(dataObj["ChaseWinPercentage"] ??  "0")
        self.FirstBattingCount = String(dataObj["FirstBattingCount"] ??  "0")
        self.FirstBattingWins = String(dataObj["FirstBattingWins"] ??  "0")
        self.SecondBattingCount = String(dataObj["SecondBattingCount"] ??  "0")
        self.SecondBattingWins = String(dataObj["SecondBattingWins"] ??  "0")
        self.TopBatting1stMatch = String(dataObj["TopBatting1stMatch"] ??  "0")
        self.TopBatting1stMatchDate = String(dataObj["TopBatting1stMatchDate"] ?? "-")
        self.TopBatting1stMatchGround = String(dataObj["TopBatting1stMatchGround"] ?? "-")
        self.TopBatting1stMatchOpp = String(dataObj["TopBatting1stMatchOpp"] ?? "-")
        self.TopBatting1stMatchScore = String(dataObj["TopBatting1stMatchScore"] ??  "0")
        self.TopBatting2ndMatch = String(dataObj["TopBatting2ndMatch"] ??  "0")
        self.TopBatting2ndMatchDate = String(dataObj["TopBatting2ndMatchDate"] ?? "-")
        self.TopBatting2ndMatchGround = String(dataObj["TopBatting2ndMatchGround"] ?? "-")
        self.TopBatting2ndMatchOpp = String(dataObj["TopBatting2ndMatchOpp"] ?? "-")
        self.TopBatting2ndMatchScore = String(dataObj["TopBatting2ndMatchScore"] ??  "0")
        self.TopBatting3rdMatch = String(dataObj["TopBatting3rdMatch"] ??  "0")
        self.TopBatting3rdMatchDate = String(dataObj["TopBatting3rdMatchDate"] ?? "-")
        self.TopBatting3rdMatchGround = String(dataObj["TopBatting3rdMatchGround"] ?? "-")
        self.TopBatting3rdMatchOpp = String(dataObj["TopBatting3rdMatchOpp"] ?? "-")
        self.TopBatting3rdMatchScore = String(dataObj["TopBatting3rdMatchScore"] ??  "0")
        self.TopBowling1stMatchID = String(dataObj["TopBowling1stMatchID"] ??  "0")
        self.TopBowling1stMatchScore = String(dataObj["TopBowling1stMatchScore"] ?? "0-0")
        self.TopBowling1stMatchOpp = String(dataObj["TopBowling1stMatchOpp"] ?? "-")
        self.TopBowling1stMatchDate = String(dataObj["TopBowling1stMatchDate"] ?? "-")
        self.TopBowling1stMatchGround = String(dataObj["TopBowling1stMatchGround"] ?? "-")
        self.TopBowling2ndMatchID = String(dataObj["TopBowling2ndMatchID"] ??  "0")
        self.TopBowling2ndMatchScore = String(dataObj["TopBowling2ndMatchScore"] ?? "0-0")
        self.TopBowling2ndMatchDate = String(dataObj["TopBowling2ndMatchDate"] ?? "-")
        self.TopBowling2ndMatchGround = String(dataObj["TopBowling2ndMatchGround"] ?? "-")
        self.TopBowling2ndMatchOpp = String(dataObj["TopBowling2ndMatchOpp"] ?? "-")
        self.TopBowling3rdMatchID = String(dataObj["TopBowling3rdMatchID"] ??  "0")
        self.TopBowling3rdMatchScore = String(dataObj["TopBowling3rdMatchScore"] ?? "0-0")
        self.TopBowling3rdMatchDate = String(dataObj["TopBowling3rdMatchDate"] ?? "-")
        self.TopBowling3rdMatchOpp = String(dataObj["TopBowling3rdMatchOpp"] ?? "-")
        self.TopBowling3rdMatchGround = String(dataObj["TopBowling3rdMatchGround"] ?? "-")
        self.Total100s = String(dataObj["Total100s"] ??  "0")
        self.Total3Wkts = String(dataObj["Total3Wkts"] ??  "0")
        self.Total4s = String(dataObj["Total4s"] ??  "0")
        self.Total50s = String(dataObj["Total50s"] ??  "0")
        self.Total5Wkts = String(dataObj["Total5Wkts"] ??  "0")
        self.Total6s = String(dataObj["Total6s"] ??  "0")
        self.TotalBallsFaced = String(dataObj["TotalBallsFaced"] ??  "0")
        self.TotalBattingAverage = String(dataObj["TotalBattingAverage"] ??  "0")
        self.TotalBowlingAverage = String(dataObj["TotalBowlingAverage"] ??  "0")
        self.TotalDucks = String(dataObj["TotalDucks"] ?? "")
        self.TotalEconomy = String(dataObj["TotalEconomy"] ??  "0")
        self.TotalMaidens = String(dataObj["TotalMaidens"] ??  "0")
        self.TotalMatches = String(dataObj["TotalMatches"] ??  "0")
        self.TotalNBs = String(dataObj["TotalNBs"] ??  "0")
        self.TotalNotOut = String(dataObj["TotalNotOut"] ??  "0")
        self.TotalOvers = String(dataObj["TotalOvers"] ??  "0")
        self.TotalRuns = String(dataObj["TotalRuns"] ??  "0")
        self.TotalRunsGiven = String(dataObj["TotalRunsGiven"] ??  "0")
        self.TotalStrikeRate = String(dataObj["TotalStrikeRate"] ??  "0")
        self.TotalWickets = String(dataObj["TotalWickets"] ??  "0")
        self.TotalWides = String(dataObj["TotalWides"] ??  "0")
        self.TotalWins = String(dataObj["TotalWins"] ??  "0")
        self.WinPercentage = String(dataObj["WinPercentage"] ??  "0")
    }
    
    var dashboardData: [String: String] {
        return [
        "BattingInnings" : self.BattingInnings,
        "BowlingInnings" : self.BowlingInnings,
        "ChaseWinPercentage" : self.ChaseWinPercentage,
        "FirstBattingCount" : self.FirstBattingCount,
        "FirstBattingWins" : self.FirstBattingWins,
        "SecondBattingCount" : self.SecondBattingCount,
        "SecondBattingWins" : self.SecondBattingWins,
        "TopBatting1stMatch" : self.TopBatting1stMatch,
        "TopBatting1stMatchDate" : self.TopBatting1stMatchDate,
        "TopBatting1stMatchGround" : self.TopBatting1stMatchGround,
        "TopBatting1stMatchOpp" : self.TopBatting1stMatchOpp,
        "TopBatting1stMatchScore" : self.TopBatting1stMatchScore,
        "TopBatting2ndMatch" : self.TopBatting2ndMatch,
        "TopBatting2ndMatchDate" : self.TopBatting2ndMatchDate,
        "TopBatting2ndMatchGround" : self.TopBatting2ndMatchGround,
        "TopBatting2ndMatchOpp" : self.TopBatting2ndMatchOpp,
        "TopBatting2ndMatchScore" : self.TopBatting2ndMatchScore,
        "TopBatting3rdMatch" : self.TopBatting3rdMatch,
        "TopBatting3rdMatchDate" : self.TopBatting3rdMatchDate,
        "TopBatting3rdMatchGround" : self.TopBatting3rdMatchGround,
        "TopBatting3rdMatchOpp" : self.TopBatting3rdMatchOpp,
        "TopBatting3rdMatchScore" : self.TopBatting3rdMatchScore,
        "TopBowling1stMatchID" : self.TopBowling1stMatchID,
        "TopBowling1stMatchScore" : self.TopBowling1stMatchScore,
        "TopBowling1stMatchOpp" : self.TopBowling1stMatchOpp,
        "TopBowling1stMatchDate" : self.TopBowling1stMatchDate,
        "TopBowling1stMatchGround" : self.TopBowling1stMatchGround,
        "TopBowling2ndMatchID" : self.TopBowling2ndMatchID,
        "TopBowling2ndMatchScore" : self.TopBowling2ndMatchScore,
        "TopBowling2ndMatchDate" : self.TopBowling2ndMatchDate,
        "TopBowling2ndMatchGround" : self.TopBowling2ndMatchGround,
        "TopBowling2ndMatchOpp" : self.TopBowling2ndMatchOpp,
        "TopBowling3rdMatchID" : self.TopBowling3rdMatchID,
        "TopBowling3rdMatchScore" : self.TopBowling3rdMatchScore,
        "TopBowling3rdMatchDate" : self.TopBowling3rdMatchDate,
        "TopBowling3rdMatchOpp" : self.TopBowling3rdMatchOpp,
        "TopBowling3rdMatchGround" : self.TopBowling3rdMatchGround,
        "Total100s" : self.Total100s,
        "Total3Wkts" : self.Total3Wkts,
        "Total4s" : self.Total4s,
        "Total50s" : self.Total50s,
        "Total5Wkts" : self.Total5Wkts,
        "Total6s" : self.Total6s,
        "TotalBallsFaced" : self.TotalBallsFaced,
        "TotalBattingAverage" : self.TotalBattingAverage,
        "TotalBowlingAverage" : self.TotalBowlingAverage,
        "TotalDucks" : self.TotalDucks,
        "TotalEconomy" : self.TotalEconomy,
        "TotalMaidens" : self.TotalMaidens,
        "TotalMatches" : self.TotalMatches,
        "TotalNBs" : self.TotalNBs,
        "TotalNotOut" : self.TotalNotOut,
        "TotalOvers" : self.TotalOvers,
        "TotalRuns" : self.TotalRuns,
        "TotalRunsGiven" : self.TotalRunsGiven,
        "TotalStrikeRate" : self.TotalStrikeRate,
        "TotalWickets" : self.TotalWickets,
        "TotalWides" : self.TotalWides,
        "TotalWins" : self.TotalWins,
        "WinPercentage" : self.WinPercentage!
        ]
    }
    
}