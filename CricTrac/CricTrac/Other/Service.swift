//
//  Service.swift
//  CricTrac
//
//  Created by Renjith on 8/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import Firebase
import SCLAlertView
import KRProgressHUD
import SwiftyJSON

import FirebaseStorage
//MARK:- Match Data

func loadInitialValues(){
    fireBaseRef.child("Dismissals").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
        dismissals = value
        }
    })
    
    fireBaseRef.child("AgeGroup").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            AgeGroupData = value
        }
    })

    fireBaseRef.child("PlayingLevel").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            PlayingLevels = value
        }
    })
    
    fireBaseRef.child("Results").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            results = value
        }
    })
    
    fireBaseRef.child("Achievements").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            Achievements = value
        }
    })
    
    fireBaseRef.child("BattingStyle").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            BattingStyles = value
        }
    })
    
    fireBaseRef.child("PlayingRole").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            PlayingRoles = value
        }
    })
    
    fireBaseRef.child("MatchStage").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            MatchStage = value
        }
    })
    
    fireBaseRef.child("Gender").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            genders = value
        }
    })
    
    fireBaseRef.child("BowlingStyle").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            BowlingStyles = value
        }
    })
    
    fireBaseRef.child("Ground").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            groundNames = value
        }
    })
    
    fireBaseRef.child("Venue").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let value = snapshot.value as? [String]{
            venueNames = value
        }
    })
    
    loadCountriesData()
}

func addMatchData(key:String,data:[String:AnyObject], callback: [String:AnyObject] -> Void){
    var dataToBeModified = data
    //let formatter = NSDateFormatter()
    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    dataToBeModified["MatchAddedDate"] = NSDate().getCurrentTimeStamp() // formatter.stringFromDate(NSDate())
    dataToBeModified["MatchEditedDate"] = NSDate().getCurrentTimeStamp()// formatter.stringFromDate(NSDate())
    dataToBeModified["MatchDateTS"] = NSDate().getCurrentTimeStamp()// MatchDate in timestamp format
    dataToBeModified["UserId"] = currentUser!.uid //Current user ID
    dataToBeModified["DeviceInfo"] = modelName + "|" + systemVersion + "|" + versionAndBuildNumber //Device info and App info
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").childByAutoId()
    dataToBeModified["MatchId"] = ref.key
    ref.setValue(dataToBeModified)    
    
    if let matchId = dataToBeModified["MatchId"] as? String{
        writeAutomaticMessage(matchId)
    }
    
    UpdateDashboardDetails()
    newMatchNotification((dataToBeModified["MatchId"] as? String)!)
    callback(dataToBeModified)
}

func addProfileImageData(profileDp:UIImage){
    let imageData:NSData = UIImageJPEGRepresentation(profileDp, 0.8)!
    let metaData = FIRStorageMetadata()
    metaData.contentType = "image/jpg"
    
    //    if let usrId = FIRAuth.auth()?.currentUser?.uid {
      //  let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/UserProfile/profilePhoto"
        storageRef.child((FIRAuth.auth()?.currentUser?.uid)!).child("UserProfile").child("profileImage").putData(imageData, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                userImageMetaData = (metaData?.downloadURL())!
                LoggedInUserImage = profileDp
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    updateMetaData(userImageMetaData)
                    do {
                        let data = try? NSData(contentsOfURL: userImageMetaData, options: NSDataReadingOptions())
                        // let data = try? NSData(contentsOfURL: userImageMetaData)
                        LoggedInUserImage = UIImage(data: data!)!
                    }catch {
                        LoggedInUserImage = placeHolderImage!
                    }
                    //print("This is run on the background queue")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if let data = try? NSData(contentsOfURL: userImageMetaData, options: NSDataReadingOptions()){
                            LoggedInUserImage = UIImage(data: data)!
                        }else {
                            LoggedInUserImage = placeHolderImage!
                        }
                        //print("This is run on the main queue, after the previous code in outer block")
                    })
                })
            }
        }
    //    }
}

func addCoverImageData(profileDp:UIImage){
    let imageData:NSData = UIImageJPEGRepresentation(profileDp, 0.8)!
    let metaData = FIRStorageMetadata()
    metaData.contentType = "image/jpg"
    
    //    if let usrId = FIRAuth.auth()?.currentUser?.uid {
   // let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/UserProfile/coverImage"
    storageRef.child((FIRAuth.auth()?.currentUser?.uid)!).child("UserProfile").child("coverPhoto").putData(imageData, metadata: metaData){(metaData,error) in
        if let error = error {
            print(error.localizedDescription)
            return
        }else{
            userImageMetaData = (metaData?.downloadURL())!
            LoggedInUserCoverImage = profileDp
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                updateCoverMetaData(userImageMetaData)
                do {
                    let data = try? NSData(contentsOfURL: userImageMetaData, options: NSDataReadingOptions())
                    LoggedInUserCoverImage = UIImage(data: data!)!
                }catch {
                    LoggedInUserCoverImage = placeHolderImage!
                }
                //print("This is run on the background queue")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = try? NSData(contentsOfURL: userImageMetaData, options: NSDataReadingOptions()) {
                        LoggedInUserCoverImage = UIImage(data: data)!
                    }else {
                        LoggedInUserCoverImage = placeHolderImage!
                    }
                    //print("This is run on the main queue, after the previous code in outer block")
                })
            })
        }
    }
    //    }
    
}

func updateMetaData(profileImgUrl: NSURL) {
    if profileData.userExists {
        let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile")
        let profileImageObject: [NSObject:AnyObject] = [ "ProfileImageURL"    : profileImgUrl.absoluteString]
        ref.updateChildValues(profileImageObject)
        //if profileData.ProfileImageURL == "-" {
            profileData.ProfileImageURL = profileImgUrl.absoluteString
             NSNotificationCenter.defaultCenter().postNotificationName("ProfilePictureUpdated", object: nil)
        //}
    }
}

// cover pic
func updateCoverMetaData(coverImgUrl: NSURL) {
        if profileData.userExists {
        let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile")
        let coverImageObject: [NSObject:AnyObject] = [ "CoverPhotoURL"    : coverImgUrl.absoluteString]
        ref.updateChildValues(coverImageObject)
        //if profileData.CoverPhotoURL == "-" {
            profileData.CoverPhotoURL = coverImgUrl.absoluteString
            NSNotificationCenter.defaultCenter().postNotificationName("CoverPictureUpdated", object: nil)
        //}
    }
}

func getAllMatchData(friendId:String? = nil,sucessBlock:([String:AnyObject])->Void){
    let userId:String = friendId ?? currentUser!.uid
    fireBaseRef.child("Users").child(userId).child("Matches").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value! as? [String:AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllDashboardData(friendId:String?=nil,sucessBlock:([String:AnyObject])->Void){
   let userId:String = friendId ?? currentUser!.uid
    fireBaseRef.child("Users").child(userId).child("Dashboard").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value! as? [String:AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

//MARK:- Ground

func addNewGroundName(groundName:String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Grounds").childByAutoId()
    ref.setValue(groundName)
}

func addNewVenueName(venueName:String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Venue").childByAutoId()
    ref.setValue(venueName)
}

func addNewTeamName(teamName:String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Teams").childByAutoId()
    ref.setValue(teamName)
}

func addNewOppoSitTeamName(oTeamName:String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Opponents").childByAutoId()
    ref.setValue(oTeamName)
}

func addNewTournamentName(tournament:String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Tournaments").childByAutoId()
    ref.setValue(tournament)
}

func getAllTeams(sucessBlock:(AnyObject)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Teams").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllOpponents(sucessBlock:(AnyObject)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Opponents").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllGrounds(sucessBlock:(AnyObject)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Grounds").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllVenue(sucessBlock:(AnyObject)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Venue").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllTournaments(sucessBlock:(AnyObject)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Tournaments").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllUserProfileInfo(friendId:String? = nil , sucess:(Void)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            loggedInUserInfo = data
            sucess()
        }
    })
}

func getFriendProfileInfo(friendId:String? = nil , sucess:([String : AnyObject])->Void){
    let userId:String = friendId ?? currentUser!.uid
    fireBaseRef.child("Users").child(userId).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            sucess(data)
        }
    })
}

func getProfileInfoById(usrId: String, sucessBlock: ([String:AnyObject]) -> Void) {
    fireBaseRef.child("Users").child(usrId).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject]{
            var dataToBeManipulated = data
            dataToBeManipulated["Id"] = usrId
            sucessBlock(dataToBeManipulated)
        }
        else{
            sucessBlock([:])
        }
    })
}

func fetchFriendCity(id:String,sucess:(city:String)->Void){
    fireBaseRef.child("Users").child(id).child("UserProfile").child("City").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? String{
            sucess(city: data)
        }
    })
}

func fetchFriendDetail(id:String,sucess:(result:[String:String])->Void){
    fireBaseRef.child("Users").child(id).child("UserProfile").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value {
            guard let proPic = data["ProfileImageURL"] as? String else {return }
            guard let city = data["City"]! as? String else {return }
            sucess(result: ["proPic":proPic,"city":city])
        }
    })
}

func fetchBasicProfile(id:String,sucess:(result:[String:String])->Void){
    fireBaseRef.child("Users").child(id).child("UserProfile").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value {
            guard let firstname = data["FirstName"]! as? String else {return }
            guard let lastname = data["LastName"]! as? String else {return }
            guard let proPic = data["ProfileImageURL"] as? String else {return }
            guard let city = data["City"]! as? String else {return }
            sucess(result: ["proPic":proPic,"city":city,"firstname":firstname,"lastname":lastname])
        }
    })
}

func fetchCoverPhoto(id:String,sucess:(result:[String:String])->Void){
    fireBaseRef.child("Users").child(id).child("UserProfile").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value {
            guard let coverPic = data["CoverPhotoURL"] as? String else {return }
            sucess(result: ["coverPic":coverPic])
        }
    })
}

func fetchAdDetails(sucess:(result:[String:String])->Void){
    fireBaseRef.child("Constants").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value {
            let adUnitId = data["AdUnitId"] as? String
            let showAds = data["ShowADs"] as? String
            sucess(result: ["adUnitId":adUnitId!,"showAds":showAds!])
        }
    })
}


func enableSync(){
    //fireBaseRef.database.persistenceEnabled = true
    fireBaseRef.keepSynced(true)
}


// MARK: - Profile

func addUserProfileData(data:[String:AnyObject], sucessBlock:([String:AnyObject])->Void){
    //KRProgressHUD.showText("Updating ...")
    var dataToBeModified = data
//    let formatter = NSDateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    dataToBeModified["UserLastLoggedin"] = NSDate().getCurrentTimeStamp()
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").child("Email").observeSingleEventOfType(.Value, withBlock: { snapshot in
        let userRegistered = snapshot.value as? String
        
        if userRegistered == nil
            //if !profileData.userExists
        {
            dataToBeModified["UserAddedDate"] = NSDate().getCurrentTimeStamp()//formatter.stringFromDate(NSDate())
            dataToBeModified["UserEditedDate"] = NSDate().getCurrentTimeStamp()//formatter.stringFromDate(NSDate())
            dataToBeModified["DeviceInfo"] = modelName + "|" + systemVersion + "|" + versionAndBuildNumber //Device info and App info
            
            _ = fireBaseRef.child("Users").child(currentUser!.uid).child("UserSettings").child("NotificationsCount").setValue(0)
            _ = fireBaseRef.child("Users").child(currentUser!.uid).child("UserSettings").child("Theme").setValue("Grass")
            
            //welcome post for the new user
            var postText = "Welcome to CricTrac."
            if profileData.UserProfile == "Player" {
                postText = "Welcome to CricTrac, an ultimate e-accessory for your cricket kit. Chase your passion, share your success, encourage your buddies for their great knocks. Everyone has the fire, but the champions know when to ignite the spark. \nWishing you all the very best on your journey towards becoming a fantastic cricketer and a great individual."
            }
            else if profileData.UserProfile == "Coach" {
                postText = "Welcome to CricTrac. You are the one who identified a player's potential and worked towards maximising the performance. Without your support and dedication they would have never excelled in their career. You are the one who taught them the right way to hold bat and ball. \nFollow them, track them and mentor them to shape them as an excellent player and a great individual."
            }
            else {
                postText = "Welcome to CricTrac, an innovative arena for cricket lovers. You can now get the latest cricket updates about your near and dear one's who are sweating out on the ground. \n\nTrack them, monitor them and hold their hands to chase their passion."
            }
            
            let addedTime =  NSDate().getCurrentTimeStamp()
            let userName = profileData.FirstName + " " + profileData.LastName ?? "No Name"
            
            let welcomePost:[String:AnyObject] = ["AddedTime":addedTime,"OwnerID":currentUser!.uid,"OwnerName":userName,"isDeleted":"0","Post":postText,"PostedBy":"CricTrac","PostType":"Welcome","CommentCount":0,"LikeCount":0]
            let ref = fireBaseRef.child("TimelinePosts").childByAutoId()
            ref.setValue(welcomePost)
            let postKey = ref.key
            fireBaseRef.child("Users").child(currentUser!.uid).child("TimelineID").childByAutoId().setValue(postKey)
            
            var timeLineData:[JSON]!
            if let  value = timelineData?.arrayValue{
                timeLineData = value
            }else{
                timeLineData = [JSON]()
            }
            
            timeLineData.insert(JSON(welcomePost), atIndex: 0)
            timelineData = JSON(timeLineData)
            
        }
        else
        {
            dataToBeModified["UserEditedDate"] = NSDate().getCurrentTimeStamp()//formatter.stringFromDate(NSDate())
        }
            
        let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile")
        ref.setValue(dataToBeModified)
        
        if let usrProfileType = dataToBeModified["UserProfile"] {
            if usrProfileType as! String != userProfileType.Player.rawValue {
                deleteAllPlayerData()
            }
            else
            {
                let dataToBeCreated = DashboardData(dataObj: [String:AnyObject]())
                let dataToBeSent = dataToBeCreated.dashboardData
                createDashboardData(dataToBeSent)
                UpdateDashboardDetails()
            }
        }
        //KRProgressHUD.dismiss()
        sucessBlock(dataToBeModified)
    })
}

func deleteAllPlayerData(){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Dashboard").removeValue()
    fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").removeValue()
    fireBaseRef.child("Users").child(currentUser!.uid).child("Opponents").removeValue()
    fireBaseRef.child("Users").child(currentUser!.uid).child("Teams").removeValue()
    fireBaseRef.child("Users").child(currentUser!.uid).child("Grounds").removeValue()
    fireBaseRef.child("Users").child(currentUser!.uid).child("Tournaments").removeValue()
    fireBaseRef.child("Users").child(currentUser!.uid).child("Venue").removeValue()
}

func UpdateDashboardDetails(){
    if let usrId = currentUser?.uid {
        let requestUrl = "\(DashboardDataUpdateUrl)\(usrId)"
        let request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}


func createDashboardData(dashboardData: [String: AnyObject]){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Dashboard")
    ref.setValue(dashboardData)
}


func updateLastLogin(){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").child("UserLastLoggedin")
    ref.setValue(NSDate().getCurrentTimeStamp())
}

func getAllProfileData(sucessBlock:([String:AnyObject])->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func FriendExists(FriendId: String) -> [AnyObject]? {
    let ref = fireBaseRef.child("Friends")
    ref.queryOrderedByChild("UserId").queryStartingAtValue(FriendId).queryEndingAtValue(FriendId+"\u{f8ff}").observeEventType(.Value, withBlock: { snapshot in
        return snapshot.value
    })
    return nil
}

func searchProfiles(searchParameter: String, sucessBlock:([Profile])->Void) {
    let ref = fireBaseRef.child("Users")
    ref.queryOrderedByChild("UserProfile/FirstName").queryStartingAtValue(searchParameter).queryEndingAtValue(searchParameter+"\u{f8ff}").observeSingleEventOfType(.Value, withBlock: { snapshot in

        var users: [Profile] = []
        
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {

            for (key, value) in data {
                var retVal = 0
                
                //exclude the users from Friends node
                fireBaseRef.child("Users").child(currentUser!.uid).child("Friends").observeSingleEventOfType(.Value, withBlock: { snapshot in
                    if let data2: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
                        for (_, value2) in data2 {
                            if key == value2["UserId"] as? String {
                                retVal = 1
                            }
                        }
                    }
                    
                    //exclude the users from Recieved Request node
                    fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if let data3: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
                            for (_, value3) in data3 {
                                if key == value3["ReceivedFrom"] as? String {
                                    retVal = 1
                                }
                            }
                        }
                        
                        //exclude the users from Sent Request node
                        fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest").observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if let data4: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
                                for (_, value4) in data4 {
                                    if key == value4["SentTo"] as? String {
                                        retVal = 1
                                    }
                                }
                            }
                    
                            if retVal == 0 {
                                if var profile = value["UserProfile"] as? [String : AnyObject] {
                                    profile["Id"] = key
                                    if key != currentUser?.uid {
                                        let profileObject = Profile(usrObj: profile)
                                        users.append(profileObject)
                                    }
                                }
                            }
                            
                            sucessBlock(users)
                        })
                    })
                })
            }
            //sucessBlock(users)
        }
 
    })
    return
}

func getAllProfiles(params:[String], sucessBlock:([[String:AnyObject]])->Void){
    fireBaseRef.child("Users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        var users: [[String: AnyObject]] = []
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
            for (key, value) in data {
                if params.contains(key) {
                    if var profile = value["UserProfile"] as? [String : AnyObject] {
                        profile["Id"] = key
                        users.append(profile)
                    }
                }
            }
            sucessBlock(users)
        }
        else{
            sucessBlock([[:]])
        }
    })
}

func getImageFromFacebook() -> UIImage{
    var profileImage = UIImage()
    if let url  = currentUser?.photoURL,
        data = NSData(contentsOfURL: url)
    {
        profileImage = UIImage(data: data)!
    }
   return profileImage
}

func getImageFromFirebase(imagePath: String ,sucessBlock:(UIImage)->Void){
    if let url = NSURL(string: imagePath) {
        if let data = NSData(contentsOfURL: url) {
            if data.length > 0 {
                sucessBlock(UIImage(data: data)!)
            }
        }
    }
}

//MARK:- Update  Match

func updateMatchData(key:String,data:[String:AnyObject], callback:(data:[String:AnyObject])->Void ){
    var dataToBeModified = data
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").child(key)
    
    //let formatter = NSDateFormatter()
    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    dataToBeModified["MatchEditedDate"] = NSDate().getCurrentTimeStamp() //formatter.stringFromDate(NSDate())
    ref.updateChildValues(dataToBeModified)
    UpdateDashboardDetails()
    callback(data: dataToBeModified)
    
}

//MARK:- Delete Match

func deleteMatchData(matchId:String, callback:(error:NSError?)->Void ){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").child(matchId)
    ref.removeValueWithCompletionBlock { (error, dataRef) in
        UpdateDashboardDetails()
        callback(error: error)
    }
    
}

//MARK:- Login

func loginWithMailAndPassword(userName:String,password:String,callBack:(user:FIRUser?,error:NSError?)->Void){
    FIRAuth.auth()?.signInWithEmail(userName, password: password) { (user, error) in
        callBack(user: user,error: error)
    }
}

//func loadTimeline(callback: (timeline:[String:AnyObject])->Void){
//    fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").observeEventType(.Value, withBlock: { snapshot in
//        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
//            callback(timeline: data)
//        }
//        else{
//            callback(timeline: [:])
//        }
//    })
//}

public func loadTimeLineFromIDS(callback: (timeline:[[String:String]])->Void){
    loadAllPostIds {
        var timeLine = [[String:String]]()
        var postCount = loadedTimelineIds.count-1
        if postCount >= 5{
            postCount = 4
        }
        
        for postindex in 0...postCount{
            let postId = loadedTimelineIds[postindex]
            fireBaseRef.child("TimelinePosts").child(postId).observeEventType(.Value, withBlock: { snapshot in
                if let data = snapshot.value as? String {
                    //let arrayElement = [["postId":postId],["post":data]]
                    //timeLine.append(["postId":postId])
                    timeLine.append(["post":data])
                        
                    if postindex == postCount{
                        callback(timeline: timeLine)
                    }
                }
            })
        }
    }
}

func loadAllPostIds(callback: ()->Void){
    loadedTimelineIds.removeAll()
    fireBaseRef.child(currentUser!.uid).child("TimelineIDs").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : String] {
            for (_,value) in data{
                loadedTimelineIds.append(value)
            }
            callback()
        }
    })
}

var loadedTimelineIds = [String]()
var fetchedIndex = 0

func loadTimelineFromId(callback: (timeline:[String:AnyObject],postId:String)->Void){
    if loadedTimelineIds.count > fetchedIndex {
        let postId = loadedTimelineIds[fetchedIndex]
        fireBaseRef.child("TimelinePosts").child(postId).observeEventType(.Value, withBlock: { snapshot in
            if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
                callback(timeline: data,postId:postId)
            }
        })
    }
   fetchedIndex += 1
}

func DoesUserExist() -> Bool {
    fireBaseRef.child("Users").child(currentUser!.uid).observeEventType(.Value, withBlock: { snapshot in
        return snapshot.hasChild("UserProfile")
    })
    
    return false
}

func registerWithEmailAndPassword(userName:String,password:String,callBack:(user:FIRUser?,error:NSError?)->Void) {
    //if error?.code == 17011{
        FIRAuth.auth()?.createUserWithEmail(userName, password: password) { (user, error) in
            callBack(user: user,error: error)
        }
    //}
}

var newPostIds = [String]()

func addThemeData(theme: String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserSettings").child("Theme")
    ref.setValue(theme)
}

func getAppTheme(userId:String,sucess:(theme:String)->Void){
    fireBaseRef.child("Users").child(userId).child("UserSettings").child("Theme").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? String{
            sucess(theme: data)
        }
    })
}


// MARK: - Friends

public func getAllFriendSuggestions(callback:()->Void) {
    if let usrId = currentUser?.uid {
        let requestUrl = "\(FriendSuggstionUrl)\(usrId)"
        let request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                if let jsonStrArr = json["suggestions"] as? [String] {
                    //sajith code for fetching individual user data
                    for userprofileId in jsonStrArr {
                        _ = Profile(usrObj: [:])
                        getProfileInfoById(userprofileId, sucessBlock: { FriendData in
                            let currentProfile = Profile(usrObj: FriendData)
                            UserProfilesData.append(currentProfile)
                            callback()
                        })
                    }
                }
            }
            catch
            {
                print("Error with Json: \(error)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}


public func AcceptFriendRequest(data: [String:[String:AnyObject]], callback:(data:String)->Void){
    var dataToBeManipulated = data
    
    //sajith - check for duplicate entry
    let friendSentTo = dataToBeManipulated["FriendData"]!["UserId"] as? String
    var friendExist = 0
    
    //sajith - check for duplicate entry in Friends
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Friends")
    ref.queryOrderedByChild("UserId").queryEqualToValue(friendSentTo).observeSingleEventOfType(.Value, withBlock: { snapshot in
        
        if snapshot.childrenCount > 0 {
            friendExist = 1
        }

        if friendExist == 0 {
            // Add friend to user friends list
            let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Friends")
            ref.childByAutoId().setValue(dataToBeManipulated["FriendData"], withCompletionBlock: { error, newlyCreatedUserFriendData in
                // user's friend record id
                dataToBeManipulated["FriendData"]!["FriendRecordId"] = newlyCreatedUserFriendData.key
                dataToBeManipulated["UserData"]!["FriendRecordIdOther"] = newlyCreatedUserFriendData.key
        
                // Add user reference to Friend's friends list
                let receivedRequestRef = fireBaseRef.child("Users").child(dataToBeManipulated["FriendData"]!["UserId"]! as! String).child("Friends")
                receivedRequestRef.childByAutoId().setValue(dataToBeManipulated["UserData"], withCompletionBlock: { error, newlyCreatedUserReferenceData in
                // user's record id other
                    dataToBeManipulated["FriendData"]!["FriendRecordIdOther"] = newlyCreatedUserReferenceData.key
                    dataToBeManipulated["UserData"]!["FriendRecordId"] = newlyCreatedUserReferenceData.key
            
                    // Friend's record id
                    receivedRequestRef.child(newlyCreatedUserReferenceData.key).updateChildValues(dataToBeManipulated["UserData"]!)
                    ref.child(newlyCreatedUserFriendData.key).updateChildValues(dataToBeManipulated["FriendData"]!)
                    
                    //call the notification api
                    friendRequestAcceptedNotification(friendSentTo!)
                    
                    callback(data: newlyCreatedUserReferenceData.key)
                })
            })
        }
        else {
            callback(data:"")
        }
    })
}

func DeleteFriendRequestData(FriendReqId: String, successBlock: Bool -> Void) {
    fireBaseRef.child("Users").child(currentUser!.uid).child("Friends").child(FriendReqId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        //sajith code modified
        if let data = snapshot.value as? [String : AnyObject] {
            let selfNodeId = data["FriendRecordId"] as! String
            let friendId = data["UserId"] as! String
            let friendNodeId = data["FriendRecordIdOther"] as! String
            
            //delete the node from first user's Friends node
            fireBaseRef.child("Users").child(currentUser!.uid).child("Friends").child(selfNodeId).removeValue()
            
            //delete the node from second user's Friends node
            fireBaseRef.child("Users").child(friendId).child("Friends").child(friendNodeId).removeValue()
            
            successBlock(true)
        }
    })
}

func DeleteSentAndReceivedFriendRequestData(ReceivedRequestId: String, successBlock: Bool -> Void) {
    fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").child(ReceivedRequestId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        //sajith code modified
        if let data = snapshot.value as? [String : AnyObject] {
            let selfNodeId = data["RequestId"] as! String
            let friendId = data["ReceivedFrom"] as! String
            let friendNodeId = data["SentRequestId"] as! String
            
            //delete the node from user's ReceivedRequest node
            fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").child(selfNodeId).removeValue()
            
            //delete the node from sender's SentRequest node
            fireBaseRef.child("Users").child(friendId).child("SentRequest").child(friendNodeId).removeValue()
            
            successBlock(true)
        }
    })
}

func CancelSentFriendRequestData(ReceivedRequestId: String, successBlock: Bool -> Void) {
    fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest").child(ReceivedRequestId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        //sajith code modified
        if let data = snapshot.value as? [String : AnyObject] {
            let selfNodeId = data["SentRequestId"] as! String
            let friendId = data["SentTo"] as! String
            let friendNodeId = data["ReceivedRequestIdOther"] as! String
            
            //delete the node from SentRequest
            fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest").child(selfNodeId).removeValue()
            
            //delete the node from ReceivedRequest
            fireBaseRef.child("Users").child(friendId).child("ReceivedRequest").child(friendNodeId).removeValue()
            
            successBlock(true)
        }
    })
}


public func AddSentRequestData(data: [String:[String:AnyObject]], callback:(data:String)->Void) {
    var dataToBeManipulated = data
    
    //sajith - check for duplicate entry
    let friendSentTo = dataToBeManipulated["sentRequestData"]!["SentTo"] as? String
    var friendExist = 0
    
    //sajith - check for duplicate entry in SentRequest
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest")
    ref.queryOrderedByChild("SentTo").queryEqualToValue(friendSentTo).observeSingleEventOfType(.Value, withBlock: { snapshot in
        
        if snapshot.childrenCount > 0 {
            friendExist = 1
        }
        
        //sajith - check for duplicate entry in ReceivedRequest
        let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest")
        ref.queryOrderedByChild("ReceivedFrom").queryEqualToValue(friendSentTo).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.childrenCount > 0 {
                friendExist = 1
            }
            
            //sajith - check for duplicate entry in Friends
            let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Friends")
            ref.queryOrderedByChild("UserId").queryEqualToValue(friendSentTo).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.childrenCount > 0 {
                    friendExist = 1
                }

                if friendExist == 0 {
                    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest").childByAutoId()
                    ref.setValue(dataToBeManipulated["sentRequestData"], withCompletionBlock: { error, newlyCreateddata in
        
                        var sentcreatedId = [String: AnyObject]()
                        sentcreatedId["SentRequestId"] = newlyCreateddata.key
        
                        let receivedRequestRef = fireBaseRef.child("Users").child(dataToBeManipulated["sentRequestData"]!["SentTo"]! as! String).child("ReceivedRequest").childByAutoId()
        
                        dataToBeManipulated["ReceivedRequestData"]!["SentRequestId"] = newlyCreateddata.key
                        receivedRequestRef.setValue(data["ReceivedRequestData"], withCompletionBlock: { error, newlyCreatedReceivedRequestData in
                            var createdId = [String: AnyObject]()
                            createdId["RequestId"] = newlyCreatedReceivedRequestData.key
                            createdId["SentRequestId"] = newlyCreateddata.key
                            receivedRequestRef.updateChildValues(createdId)
                            sentcreatedId["ReceivedRequestIdOther"] = newlyCreatedReceivedRequestData.key
                            ref.updateChildValues(sentcreatedId)
                            
                            //call the notification api
                            friendRequestReceivedNotification(friendSentTo!) 
                            callback(data: newlyCreatedReceivedRequestData.key)
                        })
        
                    })
                }
                else {
                    callback(data:"")
                }
            })
        })
    })

}
 //MARK: - Friends


func getAllFriendRequests(sucessBlock:([String: AnyObject])->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").observeSingleEventOfType(.Value, withBlock: { snapshot in
        
        if let data = snapshot.value as? [String : AnyObject] {
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllSentFriendRequests(sucessBlock:([String: AnyObject])->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("SentRequest").observeSingleEventOfType(.Value, withBlock: {   snapshot in
        if let data = snapshot.value as? [String : AnyObject] {
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllFriends(sucessBlock:([String: AnyObject])->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("Friends").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String : AnyObject] {
          sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}


//func getFriendRequestById(id: String) -> [String: String]{
//    if let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").child(id) as? [String: String] {
//        return ref
//    }
//    return [:]
//}
//   


 //MARK: - Add Post

func addNewPost(postText:String, sucess:(data:[String:AnyObject])->Void){
    //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
    let userName = loggedInUserName ?? "No Name"
    let addedTime =  NSDate().getCurrentTimeStamp()
    
    let date = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    dateFormatter.timeStyle = .ShortStyle
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    let dispTime = dateFormatter.stringFromDate((date as? NSDate)!)
    
    let timelineDict:[String:AnyObject] = ["AddedTime":addedTime,"OwnerID":currentUser!.uid,"OwnerName":userName,"isDeleted":"0","Post":postText,"PostedBy":currentUser!.uid,"PostType":"Self","CommentCount":0,"LikeCount":0]
    
    let ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    
    ref.setValue(timelineDict)
    
    let postKey = ref.key
    let returnData = ["timeline":["DisplayTime":dispTime,"Post":postText,"CommentCount":"0","LikeCount":"0","OwnerName":userName,"postId":postKey,"OwnerID":currentUser!.uid,"PostedBy":currentUser!.uid,"PostType":"Self"]]
    
    sucess(data: returnData)
    //KRProgressHUD.dismiss()
    
    updateTimelineWithNewPost(postKey)
    
    newPostNotification(postKey)
    
}


func editPost(post:String, postId:String,sucess:([String:AnyObject])->Void){
    //KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
    //let userName = loggedInUserName ?? "No Name"
    let edittedTime =  Int(NSDate().timeIntervalSince1970 * 1000)
//    let timelineDict:[String:AnyObject] = ["AddedTime":addedTime,"OwnerID":currentUser!.uid,"OwnerName":userName,"isDeleted":"0","Post":post,"PostedBy":currentUser!.uid,"PostType":"Self"]
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Post")
    ref.setValue(post)
    
    let editedTimeRef = fireBaseRef.child("TimelinePosts").child(postId).child("EditedTime")
    editedTimeRef.setValue(edittedTime)
    
//    let returnData = ["timeline":["Post":post,"CommentCount":"0","LikeCount":"0","OwnerName":userName,"postId":postId,"OwnerID":currentUser!.uid,"PostedBy":currentUser!.uid,"PostType":"Self"]]
//    sucess(returnData)
}


func addNewComment(postId:String,comment:String){
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("TimelineComments").childByAutoId()
    //let addedTime =  Int(NSDate().timeIntervalSince1970 * 1000)
    let addedTime = NSDate().getCurrentTimeStamp()
    let commentDict:[String:AnyObject] = ["Comment":comment,"OwnerID":currentUser!.uid,"OwnerName":loggedInUserName ?? "","isDeleted":"0","AddedTime":addedTime]
    ref.setValue(commentDict)
   
    calCmtCnt(postId)
    
    timelinePostBump(postId)

    newCommentNotification(postId)
}

func calCmtCnt(postId:String) {
    //calculate the Comment Count
    fireBaseRef.child("TimelinePosts").child(postId).child("TimelineComments").observeSingleEventOfType(.Value, withBlock: {   snapshot in
        let CommentCount = snapshot.childrenCount
        let ref = fireBaseRef.child("TimelinePosts").child(postId).child("CommentCount")
        ref.setValue(CommentCount)
    })
}

func calLikeCnt(postId:String) {
    //calculate the Like Count
    fireBaseRef.child("TimelinePosts").child(postId).child("Likes").observeSingleEventOfType(.Value, withBlock: {   snapshot in
        let LikeCount = snapshot.childrenCount
        let ref = fireBaseRef.child("TimelinePosts").child(postId).child("LikeCount")
        ref.setValue(LikeCount)
    })
}

func getAllLikes(postId:String,sucessBlock:([[String: AnyObject]])->Void){
    fireBaseRef.child("TimelinePosts").child(postId).child("Likes").observeSingleEventOfType(.Value,withBlock: { snapshot in
        if let data = snapshot.value as? [String:[String:AnyObject]] {
            var result = [[String:AnyObject]]()
            for (_,value) in data{
                let dataval = value
                result.append(dataval)
            }
            sucessBlock(result)
        }
    })
    
}

func getAllComments(postId:String,sucess:(data:[[String: AnyObject]])->Void){
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("TimelineComments").queryOrderedByChild("AddedTime")
    ref.observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String:[String:AnyObject]] {
            var result = [TimeLineComments]()
            for (key,value) in data{
                var dataval = value as [String:AnyObject]
                dataval["commentId"] = key
                result.append(TimeLineComments(dataObj: dataval))
            }
            
            result.sortInPlace({$0.AddedTime.compare($1.AddedTime) == NSComparisonResult.OrderedAscending})
            
            let resultObj = TimeLineComments.getAnonymous(result)
            sucess(data: resultObj)
        }
        else {
            return sucess(data: [[String:AnyObject]]())
        }
    })
}

func getAllNotifications(sucess:(data:[[String: AnyObject]])->Void){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Notifications").queryOrderedByChild("AddedTime").queryLimitedToLast(30)
    ref.observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String:[String:AnyObject]] {
            var result = [Notifications]()
            for (key,value) in data{
                var dataval = value as [String:AnyObject]
                dataval["NotificationID"] = key
                result.append(Notifications(dataObj: dataval))
            }
            
            result.sortInPlace({$0.AddedTime.compare($1.AddedTime) == NSComparisonResult.OrderedDescending})
            
            let resultObj = Notifications.getAnonymous(result)
            sucess(data: resultObj)
        }
    })
}

func calcUnreadNotifications() {
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Notifications").queryLimitedToLast(30)
    ref.observeEventType(.Value, withBlock: { snapshot in
        var notiCount = 0
        if let data = snapshot.value as? [String:[String:AnyObject]] {
            for (_,value) in data {
                let unRead = value["isRead"] as? Int
                if unRead == 0 {
                    notiCount += 1
                }
            }
        }
        
        let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserSettings").child("NotificationsCount")
        ref.setValue(notiCount)
    })
}

func getNotificationsCount(sucess:(notificationCount:String)->Void){
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserSettings").child("NotificationsCount").observeEventType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? String{
            sucess(notificationCount: data)
        }
    })
}

func markNotificationAsRead(notificationId:String) {
    _ = fireBaseRef.child("Users").child(currentUser!.uid).child("Notifications").child(notificationId).observeSingleEventOfType(.Value, withBlock: { snapshot in
        if snapshot.childrenCount > 0 {
            //mark notification as READ
            let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Notifications").child(notificationId).child("isRead")
            ref.setValue(1)
        }
    })
}

func deleteNotification(notificationId:String) {
    //delete Notification
    _ = fireBaseRef.child("Users").child(currentUser!.uid).child("Notifications").child(notificationId).removeValue()
}

func likePost(postId:String)->[String:[String:String]]{
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Likes").childByAutoId()
    let likeDict:[String:String] = ["OwnerID":currentUser!.uid,"OwnerName":loggedInUserName ?? ""]
    ref.setValue(likeDict)
    
    calLikeCnt(postId)
    
    timelinePostBump(postId)

    newLikeNotification(postId)
    
    return [ref.key:likeDict]
}

func likeOrUnlike(postId:String,like:(likeDict:[String:[String:String]])->Void,unlike:(Void)->Void){
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Likes")
    ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
        if let data = snapshot.value as? [String:[String:String]] {
            let result = data.filter { return  $0.1["OwnerID"] == currentUser!.uid }
            if result.count > 0 {
                let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Likes").child(result[0].0)
                ref.removeValueWithCompletionBlock({ (error, ref) in
                    if error == nil{
                         unlike()
                        calLikeCnt(postId)
                    }
                })
            }
            else{
                like(likeDict: likePost(postId))
                calLikeCnt(postId)
            }
        }
        else{
            like(likeDict: likePost(postId))
            calLikeCnt(postId)
        }
    })
}

func upgradePlayer() {
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").child("UserStatus")
    ref.setValue("Premium")
}

func getPost(postId:String,sucessBlock:([String:AnyObject])->Void){
    fireBaseRef.child("TimelinePosts").child(postId).observeEventType(.Value, withBlock: { snapshot in
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
            sucessBlock(data)
        }
        else {
            sucessBlock([:])
        }
    })
}

func deleteSelectedPost(postId:String){
    //soft delete the post by setting the isDeleted value to 1
    fireBaseRef.child("TimelinePosts").child(postId).child("isDeleted").setValue("1")
    
    //API call for deleting the deleted timeline node from all Users nodes
    deleteTimelineNodes(postId)
}

func delComment(postId:String, commentId:String){
    fireBaseRef.child("TimelinePosts").child(postId).child("TimelineComments").child(commentId).removeValue()
   
    calCmtCnt(postId)
}

// call the API to delete all reference timeline nodes
func deleteTimelineNodes(postId:String){
    let timelineURL = serverBaseURL+"/deleteTimeline/"+postId
    let request = NSMutableURLRequest(URL: NSURL(string:timelineURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        guard error == nil && data != nil else {
            // check for fundamental networking error
            print("error=\(error)")
            return
        }
    })
    dataTask?.resume()
}


