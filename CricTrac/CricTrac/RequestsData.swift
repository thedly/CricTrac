//
//  RequestsData.swift
//  CricTrac
//
//  Created by Tejas Hedly on 18/03/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import Foundation

public class RequestsData {
    
    
    var City: String!
    //var Club: String!
    var Name: String!
    var ReceivedDateTime: AnyObject!
    var ReceivedFrom: String!
    var RequestId: String!
    var SentRequestId: String!
    

    var ReceivedRequestIdOther: String!
    var SentDateTime: AnyObject!
    var SentTo: String!
    
    var isSentRequest: Bool!
    
    
    init(){
        
    }
    
    init(dataObj: [String: AnyObject!]) {
        
        self.isSentRequest = (dataObj["IsSentRequest"] ?? false) as! Bool
        
        self.City = String(dataObj["City"] ?? "-")
        //self.Club = String(dataObj["Club"] ?? "-")
        self.Name = String(dataObj["Name"] ?? "-")
        self.ReceivedDateTime = String(dataObj["ReceivedDateTime"] ?? "-")
        self.ReceivedFrom = String(dataObj["ReceivedFrom"] ?? "-")
        self.RequestId = String(dataObj["RequestId"] ?? "-")
        self.SentRequestId = String(dataObj["SentRequestId"] ?? "-")
        
        
        self.ReceivedRequestIdOther = String(dataObj["ReceivedRequestIdOther"] ?? "-")
        self.SentDateTime = String(dataObj["SentDateTime"] ?? "-")
        self.SentTo = String(dataObj["SentTo"] ?? "-")
        
    }
    
    
    
    func getFriendRequestObject(datObject: RequestsData) -> [String: AnyObject] {
        return [
            
            "City": datObject.City!,
            //"Club": datObject.Club!,
            "Name": datObject.Name!,
            "ReceivedDateTime": datObject.ReceivedDateTime! as! AnyObject,
            "ReceivedFrom": datObject.ReceivedFrom!,
            
            "ReceivedRequestIdOther": datObject.ReceivedRequestIdOther!,
            "SentDateTime": datObject.SentDateTime!,
            "SentTo": datObject.SentTo!

        ]
    }
    
}