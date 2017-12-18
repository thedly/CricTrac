//
//  CoachPlayers.swift
//  CricTrac
//
//  Created by AIPL on 14/12/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class CoachPlayers {
    
    var coachNodeId: String!
    var playerId: String!
    var playerNodeIdOther: String!
    var isAccepted: Bool!
    
    var DOB_TS: NSDate!
    var DOB: String!
    
    var userProfile: String!
    var playingRole: String!
    var propic: String!
    var city: String!
    var firstName: String!
    var lastName: String!
    
    init(dataObj: [String: AnyObject!]) {
        self.coachNodeId = String(dataObj["CoachNodeID"] ?? "-")
        self.playerId = String(dataObj["PlayerID"] ?? "-")
        self.playerNodeIdOther = String(dataObj["PlayerNodeIdOther"] ?? "-")
        self.isAccepted = dataObj["isAccepted"] as? Bool ?? false
        
        self.DOB = dataObj["DOB"] as? String
        self.DOB_TS = dataObj["DOB_TS"] as? NSDate
        
        self.userProfile = dataObj["UserProfile"] as? String
        self.playingRole = dataObj["PlayingRole"] as? String
        self.propic = dataObj["ProfilePic"] as? String
        self.city = dataObj["City"] as? String
        self.firstName = dataObj["FirstName"] as? String
        self.lastName = dataObj["LastName"] as? String
    }
    
    static func getAnonymous(dat: [CoachPlayers]) -> [[String: AnyObject]]{
        var anonymousObjs = [[String: AnyObject]]()
        
        for players in dat {
            var anonymousObj = [String: AnyObject]()
            
            anonymousObj["DOB"] = players.DOB
            anonymousObj["DOB_TS"] = players.DOB_TS
            anonymousObj["coachNodeId"] = players.coachNodeId
            anonymousObj["isAccepted"] = players.isAccepted
            anonymousObj["playerId"] = players.playerId
            anonymousObj["playerNodeIdOther"] = players.playerNodeIdOther
            anonymousObj["UserProfile"] = players.userProfile
            anonymousObj["PlayingRole"] = players.playingRole
            anonymousObj["ProfilePic"] = players.propic
            anonymousObj["City"] = players.city
            anonymousObj["FirstName"] = players.firstName
            anonymousObj["LastName"] = players.lastName
            
            
            anonymousObjs.append(anonymousObj)
        }
        
        return anonymousObjs
    }
    
}