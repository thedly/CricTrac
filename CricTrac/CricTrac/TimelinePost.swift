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
    var OwnerID: String!
    var OwnerName: String!
    var Post: String!
    var PostType: String!
    var PostedBy: String!
    var isDeleted: Bool!
    var commentId: String!
    
    init(dataObj: [String: AnyObject!]) {
        self.commentId = String(dataObj["City"] ?? "-")
        
        self.AddedTime = NSDate(timeIntervalSince1970: (timeInterval:dataObj["AddedTime"] as! NSTimeInterval))
        
        
        self.isDeleted = dataObj["isDeleted"] as? Bool ?? false
        self.OwnerID = String(dataObj["OwnerID"] ?? "-")
        self.OwnerName = String(dataObj["OwnerName"] ?? "-")
        self.Post = String(dataObj["Post"] ?? "-")
        self.PostedBy = String(dataObj["PostedBy"] ?? "-")
        self.PostType = String(dataObj["PostType"] ?? "-")
    }
    
    static func getAnonymous(dat: [TimeLinePost]) -> [[String: AnyObject]]{
        var anonymousObjs = [[String: AnyObject]]()
        
        
        
        for timelinepost in dat {
            
            var anonymousObj = [String: AnyObject]()
            
            anonymousObj["AddedTime"] = timelinepost.AddedTime
            anonymousObj["commentId"] = timelinepost.commentId
            anonymousObj["isDeleted"] = timelinepost.isDeleted
            anonymousObj["OwnerID"] = timelinepost.OwnerID
            anonymousObj["OwnerName"] = timelinepost.OwnerName
            anonymousObj["Post"] = timelinepost.Post
            anonymousObj["PostedBy"] = timelinepost.PostedBy
            anonymousObj["PostType"] = timelinepost.PostType
            
            
            anonymousObjs.append(anonymousObj)
            
        }
        
        return anonymousObjs
        
    }
    
    
}