//
//  Friends.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class Friends {
    
    var City: String?
    var Club: String?
    var FriendshipDateTime: String?
    var Name: String?
    var UserId: String?
    
    init(dataObj: [String: String]) {
        self.City = dataObj["City"] ?? "-"
        self.Club = dataObj["Club"] ?? "-"
        self.Name = dataObj["Name"] ?? "-"
        self.FriendshipDateTime =  dataObj["FriendshipDateTime"] ?? "-"
        self.UserId = dataObj["UserId"] ?? "-"
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