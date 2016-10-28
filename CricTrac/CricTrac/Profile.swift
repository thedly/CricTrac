//
//  Profile.swift
//  CricTrac
//
//  Created by Tejas Hedly on 18/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

class Profile {
    
    var id: String
    var BattingStyle: String
    var BowlingStyle: String
    var City: String
    var Country: String
    var DateOfBirth: String
    var Email: String
    var FirstName: String
    var Gender: String
    var LastName: String
    var Mobile: String
    var PlayingLevel: String
    var PlayingRole: String
    var State: String
    var TeamName: String
    var ProfileImageUrl: String
    var fullName: String
    var userType: String
    
    init(usrObj : [String: AnyObject]) {

        self.FirstName = (usrObj["FirstName"] ?? "") as! String
        self.LastName = (usrObj["LastName"] ?? "") as! String
        self.id = (usrObj["UserId"] ?? "") as! String
        self.BattingStyle = (usrObj["BattingStyle"] ?? "") as! String
        self.BowlingStyle = (usrObj["BowlingStyle"]  ?? "") as! String
        self.City = (usrObj["City"]  ?? "") as! String
        self.Country = (usrObj["Country"]  ?? "") as! String
        self.State = (usrObj["State"] ?? "") as! String
        self.DateOfBirth = (usrObj["DateOfBirth"]  ?? "") as! String
        self.Email = (usrObj["Email"]  ?? "") as! String
        self.Gender = (usrObj["Gender"]  ?? "") as! String
        self.Mobile = (usrObj["Mobile"] ?? "") as! String
        self.PlayingRole = (usrObj["PlayingRole"]  ?? "") as! String
        self.PlayingLevel = (usrObj["PlayingLevel"] ?? "") as! String
        self.TeamName = (usrObj["TeamName"] ?? "") as! String
        self.ProfileImageUrl = (usrObj["ProfileImageUrl"] ?? "") as! String
        
        self.userType = (usrObj["UserType"] ?? "") as! String
        
        self.fullName = "\(self.FirstName) \(self.LastName)"
        
    }
    
    
}