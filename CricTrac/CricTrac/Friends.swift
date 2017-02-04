//
//  Friends.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class Friends {
    
    var City: String!
    var Club: String!
    var FriendshipDateTime: String!
    var Name: String!
    var UserId: String!
    
    init(dataObj: [String: AnyObject]) {
        self.City = dataObj["City"] as! String ?? "-"
        self.Club = dataObj["Club"] as! String ?? "-"
        self.Name = dataObj["Name"] as! String ?? "-"
        self.FriendshipDateTime =  String(dataObj["FriendshipDateTime"]) ?? "-"
        self.UserId = dataObj["UserId"] as! String ?? "-"
    }
    
    var FriendRequestObject : [String: String] {
        return [
            
            "City": self.City!,
            "Club": self.Club!,
            "Name": self.Name!,
            "FriendshipDateTime": self.FriendshipDateTime!,
            "UserId": self.UserId!
        ]
    }

    
}