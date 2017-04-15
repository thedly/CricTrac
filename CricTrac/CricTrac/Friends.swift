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
    //var Club: String!
    var FriendshipDateTime: AnyObject!
    var Name: String!
    var UserId: String!
    var FriendRecordIdOther: String!
    var FriendRecordId: String!
    
    init(dataObj: [String: AnyObject]) {
        self.City = (dataObj["City"] ?? "-") as! String
        
        //self.Club = (dataObj["Club"] ?? "-") as! String
        self.Name = (dataObj["Name"] ?? "-") as! String
        self.FriendshipDateTime = dataObj["FriendshipDateTime"] ?? "-"
        self.UserId = (dataObj["UserId"] ?? "-") as! String
        
        self.FriendRecordIdOther = (dataObj["FriendRecordIdOther"] ?? "-") as! String
        self.FriendRecordId = (dataObj["FriendRecordId"] ?? "-") as! String
    }
    
    func FriendRequestObject(datObject: Friends) -> [String: AnyObject] {
        return [
            
            "City": self.City!,
            //"Club": self.Club!,
            "Name": self.Name!,
            "FriendshipDateTime": self.FriendshipDateTime!,
            "UserId": self.UserId!,
            "FriendRecordIdOther": self.FriendRecordIdOther!,
            "FriendRecordId": self.FriendRecordId!
        ]
    }
    
    
}