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
    
    var CoachingExperience: String
    var CoachingCertifications: String
    var CoachingLevel: String
    
    
    var CurrentTeamsAsPlayer: [String]
    var PastTeamsAsPlayer: [String]
    var CurrentTeamsAsCoach: [String]
    var PastTeamsAsCoach: [String]
    var SupportingTeamsAsAFan: [String]
    var InterestedSportsAsAFan: [String]
    var HobbiesAsAFan: [String]
    
    var FavouritePlayerAsAFan: String
    
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
        
        self.ProfileImageUrl = (usrObj["ProfileImageUrl"] ?? "") as! String
        
        self.userType = (usrObj["UserType"] ?? "") as! String
        
        
        self.CoachingLevel = (usrObj["CoachingLevel"] ?? "") as! String
        self.CoachingExperience = (usrObj["CoachingExperience"] ?? "") as! String
        self.CoachingCertifications = (usrObj["CoachingCertifications"] ?? "") as! String
        
        
        self.fullName = "\(self.FirstName) \(self.LastName)"
        
        self.FavouritePlayerAsAFan = (usrObj["FavouritePlayerAsAFan"] ?? "") as! String
        
        self.CurrentTeamsAsPlayer = (usrObj["CurrentTeamsAsPlayer"] ?? []) as! [String]
        self.PastTeamsAsPlayer = (usrObj["PastTeamsAsPlayer"] ?? []) as! [String]
        self.CurrentTeamsAsCoach = (usrObj["CurrentTeamsAsCoach"] ?? []) as! [String]
        self.PastTeamsAsCoach = (usrObj["PastTeamsAsCoach"] ?? []) as! [String]
        self.SupportingTeamsAsAFan = (usrObj["SupportingTeamsAsAFan"] ?? []) as! [String]
        self.InterestedSportsAsAFan = (usrObj["InterestedSportsAsAFan"] ?? []) as! [String]
        self.HobbiesAsAFan = (usrObj["HobbiesAsAFan"] ?? []) as! [String]
        
    }
    
    
    var ProfileObject: [String:AnyObject] {
        return [
            "FirstName" : self.FirstName,
            "LastName" : self.LastName,
            "UserId" : self.id,
            "BattingStyle": self.BattingStyle,
            "BowlingStyle": self.BowlingStyle,
            "City": self.City,
            "Country": self.Country,
            "State": self.State,
            "DateOfBirth": self.DateOfBirth,
            "Email": self.Email,
            "Gender": self.Gender,
            "Mobile": self.Mobile,
            "PlayingRole":self.PlayingRole,
            "PlayingLevel":self.PlayingLevel,
            "ProfileImageUrl": self.ProfileImageUrl ,
            "UserType": self.userType,
            "FavouritePlayerAsAFan": self.userType == String(userProfileType.Fan.rawValue) ? self.FavouritePlayerAsAFan : "",
            "CurrentTeamsAsPlayer": self.userType == String(userProfileType.Player.rawValue) ? self.CurrentTeamsAsPlayer : [],
            "PastTeamsAsPlayer": self.userType == String(userProfileType.Player.rawValue) ? self.PastTeamsAsPlayer: [],
            "CurrentTeamsAsCoach": self.userType == String(userProfileType.Coach.rawValue) ? self.CurrentTeamsAsCoach: [],
            "PastTeamsAsCoach": self.userType == String(userProfileType.Coach.rawValue) ? self.PastTeamsAsCoach: [],
            "SupportingTeamsAsAFan": self.userType == String(userProfileType.Fan.rawValue) ? self.SupportingTeamsAsAFan: [],
            "InterestedSportsAsAFan": self.userType == String(userProfileType.Fan.rawValue) ? self.InterestedSportsAsAFan: [],
            
            "HobbiesAsAFan": self.userType == String(userProfileType.Fan.rawValue) ? self.HobbiesAsAFan : [],
            
            
            "CoachingLevel": self.userType == String(userProfileType.Coach.rawValue) ? self.CoachingLevel: "",
            
            "CoachingExperience": self.userType == String(userProfileType.Coach.rawValue) ? self.CoachingExperience: "",
            
            "CoachingCertifications": self.userType == String(userProfileType.Coach.rawValue) ? self.CoachingCertifications: "",
        ]
    }
    
    
}