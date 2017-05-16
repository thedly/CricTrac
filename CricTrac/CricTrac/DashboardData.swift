//
//  DashboardData.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/12/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

class DashboardData {
    var BattingInnings: AnyObject!
    var BowlingInnings: AnyObject!
    var ChaseWinPercentage: AnyObject!
    var FirstBattingCount: AnyObject!
    var FirstBattingWins: AnyObject!
    var SecondBattingCount: AnyObject!
    var SecondBattingWins: AnyObject!
    var TopBatting1stMatch: AnyObject!
    var TopBatting1stMatchDate: AnyObject!
    var TopBatting1stMatchGround: AnyObject!
    var TopBatting1stMatchOpp: AnyObject!
    var TopBatting1stMatchScore: AnyObject!
    var TopBatting2ndMatch: AnyObject!
    var TopBatting2ndMatchDate: AnyObject!
    var TopBatting2ndMatchGround: AnyObject!
    var TopBatting2ndMatchOpp: AnyObject!
    var TopBatting2ndMatchScore: AnyObject!
    var TopBatting3rdMatch: AnyObject!
    var TopBatting3rdMatchDate: AnyObject!
    var TopBatting3rdMatchGround: AnyObject!
    var TopBatting3rdMatchOpp: AnyObject!
    var TopBatting3rdMatchScore: AnyObject!
    var TopBowling1stMatchID: AnyObject!
    var TopBowling1stMatchScore: AnyObject!
    var TopBowling1stMatchOpp: AnyObject!
    var TopBowling1stMatchDate: AnyObject!
    var TopBowling1stMatchGround: AnyObject!
    var TopBowling2ndMatchID: AnyObject!
    var TopBowling2ndMatchScore: AnyObject!
    var TopBowling2ndMatchDate: AnyObject!
    var TopBowling2ndMatchGround: AnyObject!
    var TopBowling2ndMatchOpp: AnyObject!
    var TopBowling3rdMatchID: AnyObject!
    var TopBowling3rdMatchScore: AnyObject!
    var TopBowling3rdMatchDate: AnyObject!
    var TopBowling3rdMatchOpp: AnyObject!
    var TopBowling3rdMatchGround: AnyObject!
    var Total100s: AnyObject!
    var Total3Wkts: AnyObject!
    var Total4s: AnyObject!
    var Total50s: AnyObject!
    var Total5Wkts: AnyObject!
    var Total6s: AnyObject!
    var TotalBallsFaced: AnyObject!
    var TotalBattingAverage: AnyObject!
    var TotalBowlingAverage: AnyObject!
    var TotalDucks: AnyObject!
    var TotalEconomy: AnyObject!
    var TotalMaidens: AnyObject!
    var TotalMatches: AnyObject!
    var TotalNBs: AnyObject!
    var TotalNotOut: AnyObject!
    var TotalOvers: AnyObject!
    var TotalRuns: AnyObject!
    var TotalRunsGiven: AnyObject!
    var TotalStrikeRate: AnyObject!
    var TotalWickets: AnyObject!
    var TotalWides: AnyObject!
    var TotalWins: AnyObject!
    var WinPercentage: AnyObject!
    
    var TopBatting1stMatchID: AnyObject!
    var TopBatting2ndMatchID: AnyObject!
    var TopBatting3rdMatchID: AnyObject!
    var Recent1stMatchID: AnyObject!
    var Recent1stMatchDate: AnyObject!
    var Recent2ndMatchID: AnyObject!
    var Recent2ndMatchDate: AnyObject!
    var Recent3rdMatchID: AnyObject!
    var Recent3rdMatchDate: AnyObject!
    var TopBatting1stMatchDispScore: AnyObject!
    var TopBatting2ndMatchDispScore: AnyObject!
    var TopBatting3rdMatchDispScore: AnyObject!
    
    
    init(dataObj: [String: AnyObject!]){
        self.BattingInnings = dataObj["BattingInnings"] ?? 0
        self.BowlingInnings = dataObj["BowlingInnings"] ?? 0
        self.ChaseWinPercentage = dataObj["ChaseWinPercentage"] ?? 0
        self.FirstBattingCount = dataObj["FirstBattingCount"] ?? 0
        self.FirstBattingWins = dataObj["FirstBattingWins"] ?? 0
        self.SecondBattingCount = dataObj["SecondBattingCount"] ?? 0
        self.SecondBattingWins = dataObj["SecondBattingWins"] ?? 0
        self.TopBatting1stMatch = String(dataObj["TopBatting1stMatch"] ?? "-")
        self.TopBatting1stMatchDate = (dataObj["TopBatting1stMatchDate"] ?? "-")
        self.TopBatting1stMatchGround = (dataObj["TopBatting1stMatchGround"] ?? "-")
        self.TopBatting1stMatchOpp = (dataObj["TopBatting1stMatchOpp"] ?? "-")
        self.TopBatting1stMatchScore = dataObj["TopBatting1stMatchScore"] ??  0
        self.TopBatting2ndMatch = String(dataObj["TopBatting2ndMatch"] ?? "-")
        self.TopBatting2ndMatchDate = String(dataObj["TopBatting2ndMatchDate"] ?? "-")
        self.TopBatting2ndMatchGround = String(dataObj["TopBatting2ndMatchGround"] ?? "-")
        self.TopBatting2ndMatchOpp = String(dataObj["TopBatting2ndMatchOpp"] ?? "-")
        self.TopBatting2ndMatchScore = dataObj["TopBatting2ndMatchScore"] ?? 0
        self.TopBatting3rdMatch = String(dataObj["TopBatting3rdMatch"] ?? "-")
        self.TopBatting3rdMatchDate = String(dataObj["TopBatting3rdMatchDate"] ?? "-")
        self.TopBatting3rdMatchGround = String(dataObj["TopBatting3rdMatchGround"] ?? "-")
        self.TopBatting3rdMatchOpp = String(dataObj["TopBatting3rdMatchOpp"] ?? "-")
        self.TopBatting3rdMatchScore = dataObj["TopBatting3rdMatchScore"] ?? 0
        self.TopBowling1stMatchID = String(dataObj["TopBowling1stMatchID"] ??  "-")
        self.TopBowling1stMatchScore = String(dataObj["TopBowling1stMatchScore"] ?? "0-0")
        self.TopBowling1stMatchOpp = String(dataObj["TopBowling1stMatchOpp"] ?? "-")
        self.TopBowling1stMatchDate = String(dataObj["TopBowling1stMatchDate"] ?? "-")
        self.TopBowling1stMatchGround = String(dataObj["TopBowling1stMatchGround"] ?? "-")
        self.TopBowling2ndMatchID = String(dataObj["TopBowling2ndMatchID"] ??  "-")
        self.TopBowling2ndMatchScore = String(dataObj["TopBowling2ndMatchScore"] ?? "0-0")
        self.TopBowling2ndMatchDate = String(dataObj["TopBowling2ndMatchDate"] ?? "-")
        self.TopBowling2ndMatchGround = String(dataObj["TopBowling2ndMatchGround"] ?? "-")
        self.TopBowling2ndMatchOpp = String(dataObj["TopBowling2ndMatchOpp"] ?? "-")
        self.TopBowling3rdMatchID = String(dataObj["TopBowling3rdMatchID"] ??  "-")
        self.TopBowling3rdMatchScore = String(dataObj["TopBowling3rdMatchScore"] ?? "0-0")
        self.TopBowling3rdMatchDate = String(dataObj["TopBowling3rdMatchDate"] ?? "-")
        self.TopBowling3rdMatchOpp = String(dataObj["TopBowling3rdMatchOpp"] ?? "-")
        self.TopBowling3rdMatchGround = String(dataObj["TopBowling3rdMatchGround"] ?? "-")
        self.Total100s = dataObj["Total100s"] ?? 0
        self.Total3Wkts = dataObj["Total3Wkts"] ?? 0
        self.Total4s = dataObj["Total4s"] ?? 0
        self.Total50s = dataObj["Total50s"] ?? 0
        self.Total5Wkts = dataObj["Total5Wkts"] ?? 0
        self.Total6s = dataObj["Total6s"] ?? 0
        self.TotalBallsFaced = dataObj["TotalBallsFaced"] ?? 0
        self.TotalBattingAverage = dataObj["TotalBattingAverage"] ?? 0
        self.TotalBowlingAverage = dataObj["TotalBowlingAverage"] ?? 0
        self.TotalDucks = dataObj["TotalDucks"] ?? 0
        self.TotalEconomy = dataObj["TotalEconomy"] ?? 0
        self.TotalMaidens = dataObj["TotalMaidens"] ?? 0
        self.TotalMatches = dataObj["TotalMatches"] ?? 0
        self.TotalNBs = dataObj["TotalNBs"] ?? 0
        self.TotalNotOut = dataObj["TotalNotOut"] ?? 0
        self.TotalOvers = dataObj["TotalOvers"] ?? 0
        self.TotalRuns = dataObj["TotalRuns"] ?? 0
        self.TotalRunsGiven = dataObj["TotalRunsGiven"] ?? 0
        self.TotalStrikeRate = dataObj["TotalStrikeRate"] ?? 0
        self.TotalWickets = dataObj["TotalWickets"] ?? 0
        self.TotalWides = dataObj["TotalWides"] ?? 0
        self.TotalWins = dataObj["TotalWins"] ?? 0
        self.WinPercentage = dataObj["WinPercentage"] ?? 0
        
        self.TopBatting1stMatchID = String(dataObj["TopBatting1stMatchID"] ??  "-")
        self.TopBatting2ndMatchID = String(dataObj["TopBatting2ndMatchID"] ??  "-")
        self.TopBatting3rdMatchID = String(dataObj["TopBatting3rdMatchID"] ??  "-")
        self.Recent1stMatchID = String(dataObj["Recent1stMatchID"] ??  "-")
        self.Recent1stMatchDate = String(dataObj["Recent1stMatchDate"] ?? "-")
        self.Recent2ndMatchID = String(dataObj["Recent2ndMatchID"] ??  "-")
        self.Recent2ndMatchDate = String(dataObj["Recent2ndMatchDate"] ?? "-")
        self.Recent3rdMatchID = String(dataObj["Recent3rdMatchID"] ??  "-")
        self.Recent3rdMatchDate = String(dataObj["Recent3rdMatchDate"] ?? "-")
        self.TopBatting1stMatchDispScore = dataObj["TopBatting1stMatchDispScore"] ??  "-"
        self.TopBatting1stMatchDispScore = dataObj["TopBatting1stMatchDispScore"] ??  "-"
        self.TopBatting1stMatchDispScore = dataObj["TopBatting1stMatchDispScore"] ??  "-"
    }
    
    var dashboardData: [String: AnyObject] {
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
        "WinPercentage" : self.WinPercentage!,
            
        "TopBatting1stMatchID" : self.TopBatting1stMatchID,
        "TopBatting2ndMatchID" : self.TopBatting2ndMatchID,
        "TopBatting3rdMatchID" : self.TopBatting3rdMatchID,
        "Recent1stMatchID" : self.Recent1stMatchID,
        "Recent1stMatchDate" : self.Recent1stMatchDate,
        "Recent2ndMatchID" : self.Recent2ndMatchID,
        "Recent2ndMatchDate" : self.Recent2ndMatchDate,
        "Recent3rdMatchID" : self.Recent3rdMatchID,
        "Recent3rdMatchDate" : self.Recent3rdMatchDate,
        "TopBatting1stMatchDispScore" : self.TopBatting1stMatchDispScore,
        "TopBatting1stMatchDispScore" : self.TopBatting1stMatchDispScore,
        "TopBatting1stMatchDispScore" : self.TopBatting1stMatchDispScore
        ]
    }
    
}