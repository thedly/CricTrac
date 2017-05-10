//
//  TimelinePost.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/05/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation


class TimeLinePost {
    var AddedTime: NSDate!
    var AddedTimeDisp: Double!
    var OwnerID: String!
    var OwnerName: String!
    var Comment: String!
    var isDeleted: Bool!
    var CommentID: String!
    
    init(dataObj: [String: AnyObject!]) {
        self.CommentID = String(dataObj["commentId"] ?? "-")
        self.AddedTimeDisp = dataObj["AddedTime"] as? Double
        self.AddedTime = NSDate(timeIntervalSince1970: (timeInterval:dataObj["AddedTime"] as! NSTimeInterval))
        self.isDeleted = dataObj["isDeleted"] as? Bool ?? false
        self.OwnerID = String(dataObj["OwnerID"] ?? "-")
        self.OwnerName = String(dataObj["OwnerName"] ?? "-")
        self.Comment = String(dataObj["Comment"] ?? "-")
    }
    
    static func getAnonymous(dat: [TimeLinePost]) -> [[String: AnyObject]]{
        var anonymousObjs = [[String: AnyObject]]()

        for timelinepost in dat {
            
            var anonymousObj = [String: AnyObject]()
            
            anonymousObj["AddedTime"] = timelinepost.AddedTime
            anonymousObj["AddedTimeDisp"] = timelinepost.AddedTimeDisp
            anonymousObj["CommentID"] = timelinepost.CommentID
            anonymousObj["isDeleted"] = timelinepost.isDeleted
            anonymousObj["OwnerID"] = timelinepost.OwnerID
            anonymousObj["OwnerName"] = timelinepost.OwnerName
            anonymousObj["Comment"] = timelinepost.Comment
           
            anonymousObjs.append(anonymousObj)
        }
        
        return anonymousObjs
    }
}
