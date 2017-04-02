//
//  SentFriendRequest.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class SentFriendRequest {
    
    var City: String?
    var Club: String?
    var Name: String?
    var ReceivedRequestIdOther: String?
    var SentDateTime: AnyObject?
    var SentRequestId: String?
    var SentTo: String?
    
    init(){
        
    }
    
    init(dataObj: [String: AnyObject!]) {
        self.City = String(dataObj["City"] ?? "-")
        self.Club = String(dataObj["Club"] ?? "-")
        self.Name = String(dataObj["Name"] ?? "-")
        self.SentDateTime = String(dataObj["SentDateTime"] ?? "-")
        self.SentTo = String(dataObj["SentTo"] ?? "-")
        self.SentRequestId = String(dataObj["SentRequestId"] ?? "-")
        self.SentRequestId = String(dataObj["SentRequestId"] ?? "-")
    }

    
        
    func GetFriendRequestObject(datObj: SentFriendRequest) -> [String: AnyObject] {
        
            return [
            "City": datObj.City!,
            "Club": datObj.Club!,
            "Name": datObj.Name!,
            "SentDateTime": datObj.SentDateTime!,
            "SentTo": datObj.SentTo!
        ]
    }
}