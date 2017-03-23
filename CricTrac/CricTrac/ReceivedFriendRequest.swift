//
//  ReceivedFriendRequest.swift
//  CricTrac
//
//  Created by Tejas Hedly on 08/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

class ReceivedFriendRequest {
    var City: String!
    var Club: String!
    var Name: String!
    var ReceivedDateTime: AnyObject!
    var ReceivedFrom: String!
    var RequestId: String!
    var SentRequestId: String!
    
    
    init(){

    }
    
    init(dataObj: [String: AnyObject!]) {
        self.City = String(dataObj["City"] ?? "-")
        self.Club = String(dataObj["Club"] ?? "-")
        self.Name = String(dataObj["Name"] ?? "-")
        self.ReceivedDateTime = String(dataObj["ReceivedDateTime"] ?? "-")
        self.ReceivedFrom = String(dataObj["ReceivedFrom"] ?? "-")
        self.RequestId = String(dataObj["RequestId"] ?? "-")
        self.SentRequestId = String(dataObj["SentRequestId"] ?? "-")
    }
    
    
    
    func getFriendRequestObject(datObject: ReceivedFriendRequest) -> [String: AnyObject] {
        
        return [
        
        "City": datObject.City!,
        "Club": datObject.Club!,
        "Name": datObject.Name!,
        "ReceivedDateTime": datObject.ReceivedDateTime!,
        "ReceivedFrom": datObject.ReceivedFrom!,
        
        ]
    }
    
}