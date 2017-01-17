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
    
        
    func GetFriendRequestObject(datObj: SentFriendRequest) -> [String: String] {
        
        return [
            "City": datObj.City!,
            "Club": datObj.Club!,
            "Name": datObj.Name!,
            "SentDateTime": datObj.SentDateTime! as! String,
            "SentTo": datObj.SentTo!
        ]
    }
}