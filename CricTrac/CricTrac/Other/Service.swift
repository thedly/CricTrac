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
//MARK:- Match Data

func loadInitialValues(){
    
    
    fireBaseRef.child("Dismissals").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
        dismissals = value
        }
    })
    
    fireBaseRef.child("AgeGroup").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            AgeGroupData = value
        }
    })

    fireBaseRef.child("PlayingLevel").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            PlayingLevels = value
        }
    })
    
    fireBaseRef.child("Results").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            results = value
        }
    })
    
    fireBaseRef.child("Achievements").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            Achievements = value
        }
    })
    
    fireBaseRef.child("BattingStyle").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            BattingStyles = value
        }
    })
    
    fireBaseRef.child("PlayingRole").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            PlayingRoles = value
        }
    })
    
    fireBaseRef.child("MatchStage").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            MatchStage = value
        }
    })
    
    fireBaseRef.child("Gender").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            genders = value
        }
    })
    
    fireBaseRef.child("BowlingStyle").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            BowlingStyles = value
        }
    })
    
    fireBaseRef.child("Ground").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            groundNames = value
        }
    })
    
    fireBaseRef.child("Venue").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            venueNames = value
        }
    })
    
    loadCountriesData()
    
}

func addMatchData(key:NSString,data:[String:AnyObject], callback: [String:AnyObject] -> Void){
    
    var dataToBeModified = data
    
    //let formatter = NSDateFormatter()
    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    dataToBeModified["MatchAddedDate"] = NSDate().getCurrentTimeStamp() // formatter.stringFromDate(NSDate())
    dataToBeModified["MatchEditedDate"] = NSDate().getCurrentTimeStamp()// formatter.stringFromDate(NSDate())
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").childByAutoId()
    dataToBeModified["MatchId"] = ref.key
    ref.setValue(dataToBeModified)
    
    
    
    
    
    
    UpdateDashboardDetails()
    
    
    callback(dataToBeModified)
    
}

func addProfileImageData(profileDp:UIImage){
    
    let imageData:NSData = UIImageJPEGRepresentation(profileDp, 0.8)!
    
    let metaData = FIRStorageMetadata()
    metaData.contentType = "image/jpg"
    
    
//    if let usrId = FIRAuth.auth()?.currentUser?.uid {
    
        let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/UserProfile/profileImage"
        storageRef.child(filePath).putData(imageData, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                
                userImageMetaData = (metaData?.downloadURL())!
                
                LoggedInUserImage = profileDp
                
                
            }
        }
//    }
    
    
}




func updateMetaData(profileImgUrl: NSURL) {
    
    if profileData.userExists {
        let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile")
        let profileImageObject: [NSObject:AnyObject] = [ "ProfileImageURL"    : profileImgUrl.absoluteString]
        ref.updateChildValues(profileImageObject)
        if profileData.ProfileImageURL == "" {
            profileData.ProfileImageURL = profileImgUrl.absoluteString
        }
    }
    
    
    
    print("Image url updated successfully")
}

func getAllMatchData(sucessBlock:([String:AnyObject])->Void){
    
   fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
    
    if let data = snapshot.value! as? [String:AnyObject]{
        
        
        sucessBlock(data)
    }
    else{
        sucessBlock([:])
    }
    })
}

func getAllDashboardData(sucessBlock:([String:AnyObject])->Void){
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("Dashboard").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
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

func addNewTournamentName(tournamnet:String){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Tournaments").childByAutoId()
    ref.setValue(tournamnet)
}

func getAllUserData(sucessBlock:(AnyObject)->Void){
    
    fireBaseRef.child("Users").child(currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        if let data = snapshot.value{
            
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllUserProfileInfo(){
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        if let data = snapshot.value as? [String : AnyObject]{
            
            loggedInUserInfo = data
        }
        else{
            
        }
    })
}
//Users/1Gx1xGkrLchZY9ZRZXZu52Bf8Z43/UserProfile/City

func fetchFriendDetail(id:String,sucess:(city:String)->Void){
    
    fireBaseRef.child("Users").child(id).child("UserProfile").child("City").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        if let data = snapshot.value as? String{
            sucess(city: data)
        }
    })
    
}

func enableSync(){
    
    fireBaseRef.child(currentUser!.uid).keepSynced(true)
}


// MARK: - Profile



func addUserProfileData(data:[String:AnyObject], sucessBlock:([String:AnyObject])->Void){
    
    KRProgressHUD.showText("Updating ...")
    
    var dataToBeModified = data
    
//    let formatter = NSDateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    
    dataToBeModified["UserLastLoggedin"] = NSDate().getCurrentTimeStamp()
    
    
    
    if !profileData.userExists
    {
        dataToBeModified["UserAddedDate"] = NSDate().getCurrentTimeStamp()//formatter.stringFromDate(NSDate())
        dataToBeModified["UserEditedDate"] = NSDate().getCurrentTimeStamp()//formatter.stringFromDate(NSDate())
        
        
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
            
        }
        
    }
    
    
    KRProgressHUD.dismiss()
    sucessBlock(dataToBeModified)
}

func deleteAllPlayerData(){
    
    fireBaseRef.child("Users").child(currentUser!.uid).observeEventType(.Value, withBlock: { (snapshot) in
        
        if snapshot.hasChild("Dashboard"){
            snapshot.ref.child("Dashboard").removeValue()
        }
        
        if snapshot.hasChild("Matches"){
            snapshot.ref.child("Matches").removeValue()
        }
        
        if snapshot.hasChild("Matches"){
            snapshot.ref.child("Matches").removeValue()
        }
        
        if snapshot.hasChild("Opponents"){
            snapshot.ref.child("Opponents").removeValue()
        }
        
        if snapshot.hasChild("Grounds"){
            snapshot.ref.child("Grounds").removeValue()
        }
        
        if snapshot.hasChild("Matches"){
            snapshot.ref.child("Matches").removeValue()
        }
        
        if snapshot.hasChild("Teams"){
            snapshot.ref.child("Teams").removeValue()
        }
        
        if snapshot.hasChild("Tournaments"){
            snapshot.ref.child("Tournaments").removeValue()
        }
        
        if snapshot.hasChild("Venue"){
            snapshot.ref.child("Venue").removeValue()
        }
        
        
    })
}


func UpdateDashboardDetails(){
    
    if let usrId = currentUser?.uid {
        let requestUrl = "\(DashboardDataUpdateUrl)\(usrId)"
        let request = NSMutableURLRequest(URL: NSURL(string: requestUrl)!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
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
    
    
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
            
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}

func getAllProfiles(sucessBlock:([[String:AnyObject]])->Void){
    
    fireBaseRef.child("Users").observeEventType(.Value, withBlock: { (snapshot) in
        var users: [[String: AnyObject]] = []
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
            
            
            
            
            
            for (key, value) in data {
                if var profile = value["UserProfile"] as? [String : AnyObject] {
                    profile["Id"] = key
                    
                
                    users.append(profile)
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
            sucessBlock(UIImage(data: data)!)
        }
    }
    
    
    
//    profileImgRef.downloadURLWithCompletion({ (url, error) in
//                    if let userurl  = url,
//                data = NSData(contentsOfURL: userurl)
//            {
//                sucessBlock(UIImage(data: data)!)
//            }
//        
//        
//    })
    
}

//MARK:- Update  Match

func updateMatchData(key:String,data:[String:AnyObject], callback:(data:[String:AnyObject])->Void ){
    
    var dataToBeModified = data
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").child(key)
    
    //let formatter = NSDateFormatter()
    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    dataToBeModified["MatchEditedDate"] = NSDate().getCurrentTimeStamp() //formatter.stringFromDate(NSDate())
    
    
    ref.updateChildValues(dataToBeModified)
    callback(data: dataToBeModified)
    
    UpdateDashboardDetails()
    
}


//MARK:- Delete Match

func deleteMatchData(matchId:String, callback:(error:NSError?)->Void ){
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Matches").child(matchId)
    
    ref.removeValueWithCompletionBlock { (error, dataRef) in
        callback(error: error)
    }
    
}

//MARK:- Login

func loginWithMailAndPassword(userName:String,password:String,callBack:(user:FIRUser?,error:NSError?)->Void){
    
    
    FIRAuth.auth()?.signInWithEmail(userName, password: password) { (user, error) in

        callBack(user: user,error: error)
    
    }
    
    
   
}
func loadTimeline(callback: (timeline:[String:AnyObject])->Void){
   
        fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
      
            if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
                
                callback(timeline: data)
            }
            else{
                callback(timeline: [:])
            }
        
        
    })
    
    
}

public func loadTimeLineFromIDS(callback: (timeline:[[String:String]])->Void){
    
    loadAllPostIds {
        
        var timeLine = [[String:String]]()
        
        var postCount = loadedTimelineIds.count-1
        
        if postCount >= 5{
            
            postCount = 4
        }
        
        
            for postindex in 0...postCount{
                
                let postId = loadedTimelineIds[postindex]
                
                fireBaseRef.child("TimelinePosts").child(postId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
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
    fireBaseRef.child(currentUser!.uid).child("TimelineIDs").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        
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
        
       fireBaseRef.child("TimelinePosts").child(postId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let data: [String : AnyObject] = snapshot.value as? [String : AnyObject] {
            
            callback(timeline: data,postId:postId)
        }
        })
    }
    
   fetchedIndex += 1
    
}

func DoesUserExist() -> Bool {
    
    
    fireBaseRef.child("Users").child(currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
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


func addThemeData(theme: String, sucessBlock:()->Void){
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").child("theme")
    ref.setValue(theme)
    sucessBlock()
    
}





// MARK: - Friends

public func getAllFriendSuggestions(callback:()->Void) {
    
    getAllProfiles({ resultObj in
            UserProfilesData.removeAll()
            for profile in resultObj {
    
                var currentProfile = Profile(usrObj: profile)
    
    
                UserProfilesData.append(currentProfile)
                if let _imageUrl = profile["ProfileImageURL"] as? String where _imageUrl != ""  {
    
                    let userId = profile["Id"] as! String
    
                    getImageFromFirebase(_imageUrl) { (data) in
                        UserProfilesImages[userId] = data
                    }
                }
            }
        
            callback()
        
        })
    
    
}


public func AcceptFriendRequest(data: [String:[String:AnyObject]], callback:(data:String)->Void){
    
    var dataToBeManipulated = data
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("Friends").childByAutoId()
    ref.setValue(dataToBeManipulated["sentRequestData"], withCompletionBlock: { error, newlyCreateddata in
        
        var sentcreatedId = [String: AnyObject]()
        sentcreatedId["FriendRecordId"] = newlyCreateddata.key
        
        
        let receivedRequestRef = fireBaseRef.child("Users").child(dataToBeManipulated["sentRequestData"]!["SentTo"]! as! String).child("Friends").childByAutoId()
        
        dataToBeManipulated["ReceivedRequestData"]!["FriendRecordId"] = newlyCreateddata.key
        receivedRequestRef.setValue(data["ReceivedRequestData"], withCompletionBlock: { error, newlyCreatedReceivedRequestData in
            var createdId = [String: AnyObject]()
            createdId["FriendRecordId"] = newlyCreatedReceivedRequestData.key
            
            createdId["FriendRecordId"] = newlyCreateddata.key
            
            
            receivedRequestRef.updateChildValues(createdId)
            
            
            sentcreatedId["FriendRecordIdOther"] = newlyCreatedReceivedRequestData.key
            
            ref.updateChildValues(sentcreatedId)
            
            
            
            callback(data: newlyCreatedReceivedRequestData.key)
        })
        
    })

}



public func AddSentRequestData(data: [String:[String:AnyObject]], callback:(data:String)->Void) {
    
    var dataToBeManipulated = data
    
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
            
            
            
            callback(data: newlyCreatedReceivedRequestData.key)
        })
        
    })
}
 //MARK: - Friends


func getAllFriendRequests(sucessBlock:([String: AnyObject])->Void){
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let data = snapshot.value as? [String : AnyObject] {
            
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}


func getAllFriends(sucessBlock:([String: AnyObject])->Void){
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("Friends").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let data = snapshot.value as? [String : AnyObject] {
            
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
        
        
    })
    
        }


func getFriendRequestById(id: String) -> [String: String]{
    if let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("ReceivedRequest").child(id) as? [String: String] {
        return ref
    }
    return [:]
}
   


 //MARK: - Add Post


func addNewPost(postText:String, sucess:(data:[String:AnyObject])->Void){
    
    KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
    
    let userName = loggedInUserName ?? "No Name"
    
    let addedTime = "\(NSDate().timeIntervalSince1970 * 1000)"
    let timelineDict:[String:String] = ["AddedTime":addedTime,"CommentCount":"0","LikeCount":"0","OwnerID":currentUser!.uid,"OwnerName":userName,"isDeleted":"0","Post":postText,"PostedBy":currentUser!.uid]
    
    let ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    
    ref.setValue(timelineDict)
    
    let postKey = ref.key
    let returnData = ["timeline":["Post":postText,"CommentCount":"0","LikeCount":"0","OwnerName":userName,"postId":postKey,"OwnerID":currentUser!.uid,"PostedBy":currentUser!.uid]]
    
    sucess(data: returnData)
    
    updateTimelineWithNewPost(postKey) { (resultError) in
        
        KRProgressHUD.dismiss()
    }
    
}

func addNewComment(postId:String,comment:String){
    
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("TimelineComments").childByAutoId()
    
    let commentDict:[String:String] = ["Comment":comment,"OwnerID":currentUser!.uid,"OwnerName":loggedInUserName ?? "","isDeleted":"0"]
    
    ref.setValue(commentDict)
    
}

func getAllComments(postId:String,sucess:(data:[[String:String]])->Void){
    
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("TimelineComments")
    
    ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let data = snapshot.value as? [String:[String:String]] {
            
            var result = [[String:String]]()
            for (key,value) in data{
                var dataval = value
                dataval["postId"] = key
                result.append(dataval)
            }
            
            sucess(data: result)
        }
        
        
        
    })
    
}


func likePost(postId:String)->[String:[String:String]]{
    
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Likes").childByAutoId()
    let likeDict:[String:String] = ["OwnerID":currentUser!.uid,"OwnerName":loggedInUserName ?? ""]
    ref.setValue(likeDict)
    return [ref.key:likeDict]
}


func likeOrUnlike(postId:String,like:(likeDict:[String:[String:String]])->Void,unlike:(Void)->Void){
    
    let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Likes")
    
    ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let data = snapshot.value as? [String:[String:String]] {
            
            let result = data.filter { return  $0.1["OwnerID"] == currentUser!.uid }
            
            if result.count > 0 {
                
                let ref = fireBaseRef.child("TimelinePosts").child(postId).child("Likes").child(result[0].0)
                ref.removeValueWithCompletionBlock({ (error, ref) in
                    if error == nil{
                        unlike()
                    }
                })
                
                
            }else{
                
                like(likeDict: likePost(postId))
            }
            
        }else{
            
            like(likeDict: likePost(postId))
        }
        
        
        
        
    })
    
}



//fireBaseRef.child("Dismissals").setValue(["BOWLED","CAUGHT","HANDLED THE BALL","HIT WICKET","HIT THE BALL TWICE","LEG BEFORE WICKET (LBW)","OBSTRUCTING THE FIELD","RUN OUT","RETIRED","TIMED OUT"])

//public func addTimelineData(){
//    
//    fireBaseRef.child("TimelinePosts").child(postId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//        
//        if let data = snapshot.value as? String {
//            
//            timeLine.insert(["post":data], atIndex: 0)
//            
//            if postindex == postCount{
//                
//                callback(timeline: timeLine)
//                
//            }
//        }
//    })
//}
     /*
    
    var ref = fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").childByAutoId()
    
    var data:[String:String] = ["post":"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.","User":(currentUser?.uid)!,"postid":"-KS2CNMS03F--DUbm8Bz"]
    
    ref.setValue(data)
    
    data = ["post":"Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like.","User":(currentUser?.uid)!,"postid":"-KS2EAh7hG6dZo-LRYDA"]
     ref = fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").childByAutoId()
    ref.setValue(data)
    
    
    data = ["post":"t was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.","User":(currentUser?.uid)!,"postid":"-KS2EAh7hG6dZo-LRYDB"]
   ref = fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").childByAutoId()
    ref.setValue(data)
    
    data = ["post":"Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words,","User":(currentUser?.uid)!,"postid":"-KS2EAh7hG6dZo-LRYDC"]
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").childByAutoId()
    ref.setValue(data)
    
     data = ["post":"consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero,","User":(currentUser?.uid)!,"postid":"-KS2EAh8Vv10TDPSr1LS"]
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineDetailed").childByAutoId()
    ref.setValue(data)
    
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineIDs").childByAutoId()
    
    ref.setValue("-KS2EAh8Vv10TDPSr1LT")
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineIDs").childByAutoId()
    
    ref.setValue("-KS2EAh8Vv10TDPSr1LU")
    
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineIDs").childByAutoId()
    
    ref.setValue("-KS2EAh8Vv10TDPSr1LV")
    
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineIDs").childByAutoId()
    
    ref.setValue("-KS2EAh8Vv10TDPSr1LW")
    
    
    ref = fireBaseRef.child(currentUser!.uid).child("TimelineIDs").childByAutoId()
    
    ref.setValue("-KS2EAh9AzfDpZT2nLMc")
    

     
    var data:[String:String] = ["postImage":"https://firebasestorage.googleapis.com/v0/b/arjun-innovations.appspot.com/o/TestImages%2Fone.jpg?alt=media&token=57b0217a-840c-4146-85b5-48cb6a36b639","User":(currentUser?.uid)!]
    var ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    
    data = ["post":"Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like.","User":(currentUser?.uid)!]
     ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    data = ["post":"t was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    data = ["post":"Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words,","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    data = ["post":"consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero,","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    
    data = ["post":"written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    
    data = ["post":"The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    
    data = ["post":"There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    
    data = ["post":"All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.","User":(currentUser?.uid)!]
    ref = fireBaseRef.child("TimelinePosts").childByAutoId()
    ref.setValue(data)
    
    */


