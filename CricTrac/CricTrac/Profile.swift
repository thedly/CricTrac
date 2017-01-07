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
    
    var Experience: String
    var Certifications: String
    var CoachingLevel: String
    
    
    var PlayerCurrentTeams: [String]
    var PlayerPastTeams: [String]
    var CoachPastTeams: [String]
    var CoachCurrentTeams: [String]
    var CoachPlayedFor: [String]
    var SupportingTeams: [String]
    var InterestedSports: [String]
    var Hobbies: [String]
    
    var FavouritePlayers: String
    
    var ProfileImageUrl: String
    var fullName: String
    var UserProfile: String
    var UserStatus: String
    
    var UserAddedDate: String
    var UserEditedDate: String
    var UserLastLoggedin: String
    
    
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
        self.PlayingLevel = (usrObj["Level"] ?? "") as! String
        
        self.ProfileImageUrl = (usrObj["ProfileImageUrl"] ?? "") as! String
        
        self.UserProfile = (usrObj["UserProfile"] ?? "") as! String
        
        
        self.CoachingLevel = (usrObj["CoachingLevel"] ?? "") as! String
        self.Experience = (usrObj["Experience"] ?? "") as! String
        self.Certifications = (usrObj["Certifications"] ?? "") as! String
        
        
        self.fullName = "\(self.FirstName) \(self.LastName)"
        
        self.FavouritePlayers = (usrObj["FavouritePlayers"] ?? "") as! String
        
        self.PlayerCurrentTeams = (usrObj["PlayerCurrentTeams"] ?? []) as! [String]
        self.PlayerPastTeams = (usrObj["PlayerPastTeams"] ?? []) as! [String]
        self.CoachCurrentTeams = (usrObj["CoachCurrentTeams"] ?? []) as! [String]
        self.CoachPastTeams = (usrObj["CoachPastTeams"] ?? []) as! [String]
        self.SupportingTeams = (usrObj["SupportingTeams"] ?? []) as! [String]
        self.InterestedSports = (usrObj["InterestedSports"] ?? []) as! [String]
        self.Hobbies = (usrObj["Hobbies"] ?? []) as! [String]
        
        self.UserStatus = (usrObj["UserStatus"] ?? userStatus.Free.rawValue) as! String
        
        self.UserAddedDate = (usrObj["UserAddedDate"] ?? "") as! String
        self.UserEditedDate = (usrObj["UserEditedDate"] ?? "") as! String
        self.UserLastLoggedin = (usrObj["UserLastLoggedin"] ?? "") as! String
        self.CoachPlayedFor = (usrObj["CoachPlayedFor"] ?? []) as! [String]
        
    }
    
    
    var ProfileObject: [String:AnyObject] {
        return [
            "FirstName" : self.FirstName,
            "LastName" : self.LastName,
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
            "Level":self.PlayingLevel,
            "ProfileImageUrl": self.ProfileImageUrl ,
            "UserProfile": self.UserProfile,
            "FavouritePlayers": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.FavouritePlayers : "",
            "PlayerCurrentTeams": self.UserProfile == String(userProfileType.Player.rawValue) ? self.PlayerCurrentTeams : [],
            "PlayerPastTeams": self.UserProfile == String(userProfileType.Player.rawValue) ? self.PlayerPastTeams: [],
            "CoachCurrentTeams": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachCurrentTeams: [],
            "CoachPastTeams": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachPastTeams: [],
            "SupportingTeams": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.SupportingTeams: [],
            "InterestedSports": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.InterestedSports: [],
            "CoachPlayedFor": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachPlayedFor : [],
            "Hobbies": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.Hobbies : [],
            
            
            "CoachingLevel": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachingLevel: "",
            
            "Experience": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.Experience: "",
            
            "Certifications": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.Certifications: "",
            "UserStatus": self.UserStatus,
            "UserAddedDate" : self.UserAddedDate,
            "UserEditedDate" : self.UserEditedDate,
            "UserLastLoggedin": self.UserLastLoggedin
        ]
    }
    
    
}