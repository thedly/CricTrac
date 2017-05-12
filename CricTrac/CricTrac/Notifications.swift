//
//  Notifications.swift
//  CricTrac
//
//  Created by Sajith Kumar on 12/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class Notifications {
    var AddedTime: NSDate!
    var AddedTimeDisp: Double!
    var Message: String!
    var Topic: String!
    var TopicID: String!
    var isRead: Bool!
    var NotificationID: String!
    var FromID: String!
    
    init(dataObj: [String: AnyObject!]) {
        self.NotificationID = String(dataObj["NotificationID"] ?? "-")
        self.AddedTimeDisp = dataObj["AddedTime"] as? Double
        self.AddedTime = NSDate(timeIntervalSince1970: (timeInterval:dataObj["AddedTime"] as! NSTimeInterval))
        self.isRead = dataObj["isRead"] as? Bool ?? false
        self.Message = String(dataObj["Message"] ?? "-")
        self.Topic = String(dataObj["Topic"] ?? "-")
        self.TopicID = String(dataObj["TopicID"] ?? "-")
        self.FromID = String(dataObj["FromID"] ?? "-")
    }
    
    static func getAnonymous(dat: [Notifications]) -> [[String: AnyObject]]{
        var anonymousObjs = [[String: AnyObject]]()
        
        for notifications in dat {
            
            var anonymousObj = [String: AnyObject]()
            
            anonymousObj["AddedTime"] = notifications.AddedTime
            anonymousObj["AddedTimeDisp"] = notifications.AddedTimeDisp
            anonymousObj["NotificationID"] = notifications.NotificationID
            anonymousObj["isRead"] = notifications.isRead
            anonymousObj["Message"] = notifications.Message
            anonymousObj["Topic"] = notifications.Topic
            anonymousObj["TopicID"] = notifications.TopicID
            anonymousObj["FromID"] = notifications.FromID
            
            anonymousObjs.append(anonymousObj)
        }
        
        return anonymousObjs
    }
}
