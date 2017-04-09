//
//  Profile.swift
//  CricTrac
//
//  Created by Tejas Hedly on 18/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

class Profile {
    
    var id: String = ""
    var BattingStyle: String = ""
    var BowlingStyle: String = ""
    var City: String = ""
    var Country: String = ""
    var DateOfBirth: String = ""
    var Email: String = ""
    var FirstName: String = ""
    var Gender: String = ""
    var LastName: String = ""
    var Mobile: String = ""
    //var PlayingLevel: String
    var PlayingRole: String = ""
    var State: String = ""
    var Experience: String = ""
    var Certifications: [String] = []
    var CoachingLevel: String = ""
    var PlayerCurrentTeams: [String] = []
    var PlayerPastTeams: [String] = []
    var CoachPastTeams: [String] = []
    var CoachCurrentTeams: [String] = []
    var CoachPlayedFor: [String] = []
    var SupportingTeams: [String] = []
    var InterestedSports: [String] = []
    var Hobbies: [String] = []
    var FavoritePlayers: [String] = []
    var ProfileImageURL: String = "-"
    var CoverPhotoURL: String = "-"
    var fullName: String = ""
    var UserProfile: String = ""
    var UserStatus: String = "Free"
    var UserAddedDate: AnyObject = ""
    var UserEditedDate: AnyObject = ""
    var UserLastLoggedin: AnyObject = ""
    var userExists: Bool = false
    
    init(usrObj : [String: AnyObject]) {
        
        self.userExists = usrObj.count > 0
        
        if let userId = usrObj["Id"] as? String {
            self.id = userId
        }
        
        if let fname = usrObj["FirstName"] as? String {
            self.FirstName = fname
        }
        if let lname = usrObj["LastName"] as? String {
            self.LastName = lname
        }
        
        if let battingStyle = usrObj["BattingStyle"] as? String {
            self.BattingStyle = battingStyle
        }
        if let bowlingStyle = usrObj["BowlingStyle"] as? String {
            self.BowlingStyle = bowlingStyle
        }
        if let city = usrObj["City"] as? String {
            self.City = city
        }
        if let country = usrObj["Country"] as? String {
            self.Country = country
        }
        if let state = usrObj["State"] as? String {
            self.State = state
        }
        if let dob = usrObj["DateOfBirth"] as? String {
            self.DateOfBirth = dob
        }
        if let email = usrObj["Email"] as? String {
            self.Email = email
        }
        if let gender = usrObj["Gender"] as? String {
            self.Gender = gender
        }
        if let mobile = usrObj["Mobile"] as? String {
            self.Mobile = mobile
        }
        if let playingRole = usrObj["PlayingRole"] as? String {
            self.PlayingRole = playingRole
        }
        if let profileImage = usrObj["ProfileImageURL"] as? String {
            userImageMetaData = NSURL(string: profileImage)!
        }
        if let coverUrl = usrObj["CoverPhotoURL"] as? String {
            self.CoverPhotoURL = ""
        }
        if let usrProfile = usrObj["UserProfile"] as? String {
           self.UserProfile = usrProfile
        }
        if let coachingLevel = usrObj["CoachingLevel"] as? String {
           
            self.CoachingLevel = coachingLevel
        }
        if let experience = usrObj["Experience"] as? String {
            
            self.Experience = experience
            
        }
        if let certifications = usrObj["Certifications"] as? [String] {
            self.Certifications = certifications
            
        }
       
        
        if let fname = self.FirstName as? String, let lName = self.LastName as? String {
            self.fullName = "\(fname) \(lName)"
        }
        
        if let favoritePlayers = usrObj["FavoritePlayers"] as? [String] {
            self.FavoritePlayers = favoritePlayers
            
        }
        if let playerCurrentTeams = usrObj["PlayerCurrentTeams"] as? [String] {
            self.PlayerCurrentTeams = playerCurrentTeams
        }
        if let playerPastTeams = usrObj["PlayerPastTeams"] as? [String] {
            self.PlayerPastTeams = playerPastTeams
        }
        
        if let coachCurrentTeams = usrObj["CoachCurrentTeams"] as? [String] {
            self.CoachCurrentTeams = coachCurrentTeams
        }
        if let coachPastTeams = usrObj["CoachPastTeams"] as? [String] {
            self.CoachPastTeams = coachPastTeams
        }
        
        if let supportingTeams = usrObj["SupportingTeams"] as? [String] {
            self.SupportingTeams = supportingTeams
        }
        
        if let interestedSports = usrObj["InterestedSports"] as? [String] {
            self.InterestedSports = interestedSports
        }
        
        if let hobbies = usrObj["Hobbies"] as? [String] {
            self.Hobbies = hobbies
        }
        if let userStatus = usrObj["UserStatus"] as? String where userStatus != "" {
            self.UserStatus = userStatus
        }
        if let userAddedDate = usrObj["UserAddedDate"] as AnyObject? {
            self.UserAddedDate =  userAddedDate
        }
        if let userEditedDate = usrObj["UserEditedDate"] as AnyObject? {
            self.UserEditedDate = userEditedDate
        }
        if let userLastLoggedin = usrObj["UserLastLoggedin"] as AnyObject? {
            self.UserLastLoggedin = userLastLoggedin
        }
        if let coachPlayedFor = usrObj["CoachPlayedFor"] as? [String] {
            self.CoachPlayedFor = coachPlayedFor
        }
    }
    
    var ProfileObject: [String:AnyObject] {
        if self.UserProfile == String(userProfileType.Fan.rawValue) {
            return [
                "FirstName" : self.FirstName.whiteSpacesTrimmedString(),
                "LastName" : self.LastName.whiteSpacesTrimmedString(),
                "City": self.City.whiteSpacesTrimmedString(),
                "Country": self.Country,
                "State": self.State,
                "DateOfBirth": self.DateOfBirth,
                "Email": self.Email.whiteSpacesTrimmedString(),
                "Gender": self.Gender,
                "Mobile": self.Mobile.whiteSpacesTrimmedString(),
                "ProfileImageURL": self.ProfileImageURL ,
                "UserProfile": self.UserProfile,
                "CoverPhotoURL" : self.CoverPhotoURL,
                "SearchFirstName" : self.FirstName.lowercaseString.whiteSpacesTrimmedString(),
                "SearchLastName" : self.LastName.lowercaseString.whiteSpacesTrimmedString(),
                "FavoritePlayers": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.FavoritePlayers : [],
                "SupportingTeams": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.SupportingTeams: [],
                "InterestedSports": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.InterestedSports: [],
                "Hobbies": self.UserProfile == String(userProfileType.Fan.rawValue) ? self.Hobbies : [],
                "UserStatus": self.UserStatus,
                "UserAddedDate" : self.UserAddedDate,
                "UserEditedDate" : self.UserEditedDate,
                "UserLastLoggedin": self.UserLastLoggedin
            ]
        }
        else if self.UserProfile == String(userProfileType.Player.rawValue) {
            return [
                "FirstName" : self.FirstName.whiteSpacesTrimmedString(),
                "LastName" : self.LastName.whiteSpacesTrimmedString(),
                "BattingStyle": self.BattingStyle,
                "BowlingStyle": self.BowlingStyle,
                "City": self.City.whiteSpacesTrimmedString(),
                "Country": self.Country,
                "State": self.State,
                "DateOfBirth": self.DateOfBirth,
                "Email": self.Email.whiteSpacesTrimmedString(),
                "Gender": self.Gender,
                "Mobile": self.Mobile.whiteSpacesTrimmedString(),
                "PlayingRole":self.PlayingRole,
                //"Level":self.PlayingLevel,
                "ProfileImageURL": self.ProfileImageURL ,
                "SearchFirstName" : self.FirstName.lowercaseString.whiteSpacesTrimmedString(),
                "SearchLastName" : self.LastName.lowercaseString.whiteSpacesTrimmedString(),
                "CoverPhotoURL" : self.CoverPhotoURL,
                "UserProfile": self.UserProfile,
                "PlayerCurrentTeams": self.UserProfile == String(userProfileType.Player.rawValue) ? self.PlayerCurrentTeams : [],
                "PlayerPastTeams": self.UserProfile == String(userProfileType.Player.rawValue) ? self.PlayerPastTeams: [],
                "UserStatus": self.UserStatus,
                "UserAddedDate" : self.UserAddedDate,
                "UserEditedDate" : self.UserEditedDate,
                "UserLastLoggedin": self.UserLastLoggedin
            ]
        }
        else {
            return [
                "FirstName" : self.FirstName.whiteSpacesTrimmedString(),
                "LastName" : self.LastName.whiteSpacesTrimmedString(),
                "City": self.City.whiteSpacesTrimmedString(),
                "Country": self.Country,
                "State": self.State,
                "DateOfBirth": self.DateOfBirth,
                "Email": self.Email.whiteSpacesTrimmedString(),
                "Gender": self.Gender,
                "Mobile": self.Mobile.whiteSpacesTrimmedString(),
                "ProfileImageURL": self.ProfileImageURL ,
                "CoverPhotoURL" : self.CoverPhotoURL,
                "UserProfile": self.UserProfile,
                "SearchFirstName" : self.FirstName.lowercaseString.whiteSpacesTrimmedString(),
                "SearchLastName" : self.LastName.lowercaseString.whiteSpacesTrimmedString(),
                "CoachCurrentTeams": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachCurrentTeams: [],
                "CoachPastTeams": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachPastTeams: [],
                "CoachPlayedFor": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachPlayedFor : [],
                "CoachingLevel": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.CoachingLevel: "",
                "Experience": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.Experience: "",
                "Certifications": self.UserProfile == String(userProfileType.Coach.rawValue) ? self.Certifications: [],
                "UserStatus": self.UserStatus,
                "UserAddedDate" : self.UserAddedDate,
                "UserEditedDate" : self.UserEditedDate,
                "UserLastLoggedin": self.UserLastLoggedin
            ]
        }
    }
}

extension String {
    func whiteSpacesTrimmedString() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

