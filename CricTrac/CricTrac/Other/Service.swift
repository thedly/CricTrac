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
//MARK:- Match Data

func loadInitialValues(){
    
    
    fireBaseRef.child("Dismissals").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
        dismissals = value
        }
    })
    
    fireBaseRef.child("Results").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            results = value
        }
    })
}

func addMatchData(key:NSString,data:[String:String]){
    
    let ref = fireBaseRef.child(currentUser!.uid).child("Matches").childByAutoId()
    ref.setValue(data)
    
}

func addProfileImageData(profileDp:UIImage){
    
    let imageData:NSData = UIImageJPEGRepresentation(profileDp, 0.8)!
    
    let metaData = FIRStorageMetadata()
    metaData.contentType = "image/jpg"
    
    
    let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/UserProfile/profileImage"
    
    storageRef.child(filePath).putData(imageData, metadata: metaData){(metaData,error) in
        if let error = error {
            print(error.localizedDescription)
            return
        }else{
            
            updateMetaData(metaData!.downloadURL()!)
        
        }
    }
}

func updateMetaData(profileImgUrl: NSURL) {
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile")
    let profileImageObject: [NSObject:AnyObject] = [ "ProfileImageUrl"    : profileImgUrl.absoluteString]
    ref.updateChildValues(profileImageObject)
    print("Image url updated successfully")
}

func getAllMatchData(sucessBlock:([String:AnyObject])->Void){
    
   fireBaseRef.child(currentUser!.uid).child("Matches").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
    
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
    let ref = fireBaseRef.child(currentUser!.uid).child("Grounds").childByAutoId()
    ref.setValue(groundName)
}

func addNewTeamName(teamName:String){
    let ref = fireBaseRef.child(currentUser!.uid).child("Teams").childByAutoId()
    ref.setValue(teamName)
}

func addNewOppoSitTeamName(oTeamName:String){
    let ref = fireBaseRef.child(currentUser!.uid).child("OppositTeams").childByAutoId()
    ref.setValue(oTeamName)
}

func addNewTournamnetName(tournamnet:String){
    let ref = fireBaseRef.child(currentUser!.uid).child("Tournaments").childByAutoId()
    ref.setValue(tournamnet)
}

func getAllUserData(sucessBlock:(AnyObject)->Void){
    
    fireBaseRef.child(currentUser!.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        if let data = snapshot.value{
            
            sucessBlock(data)
        }
        else{
            sucessBlock([:])
        }
    })
}


func enableSync(){
    
    fireBaseRef.child(currentUser!.uid).keepSynced(true)
}


// MARK: - Profile

func loadInitialProfileValues(){
    
    
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
    
    fireBaseRef.child("PlayingLevel").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
        if let value = snapshot.value as? [String]{
            PlayingLevels = value
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
    
    
}


func addUserProfileData(data:[String:String], sucessBlock:(AnyObject)->Void){
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile")
    ref.setValue(data)
    sucessBlock(data)
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

func updateMatchData(key:String,data:[String:String]){
    
    let ref = fireBaseRef.child(currentUser!.uid).child("Matches").child(key)
    ref.updateChildValues(data)
    
}


//MARK:- Delete Match

func deleteMatchData(matchId:String, callback:(error:NSError?)->Void ){
    
    let ref = fireBaseRef.child(currentUser!.uid).child("Matches").child(matchId)
    
    ref.removeValueWithCompletionBlock { (error, dataRef) in
        callback(error: error)
    }
    
}

//MARK:- Login

func loginWithMailAndPassword(userName:String,password:String,callBack:(user:FIRUser?,error:NSError?)->Void){
    
    var uname = userName
    
    if uname == ""{
        
        uname = "r@test1.com"
    }
    
    var pward = password
    
    if pward == ""{
        
        pward = "test123"
    }
    
    
    FIRAuth.auth()?.signInWithEmail(uname, password: pward) { (user, error) in

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


func loadAllPostIds(callback: ()->Void){
    fetchedIndex = 0
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





func registerWithEmailAndPassword(userName:String,password:String,callBack:(user:FIRUser?,error:NSError?)->Void) {
    //if error?.code == 17011{
    
    
        FIRAuth.auth()?.createUserWithEmail(userName, password: password) { (user, error) in
            
            callBack(user: user,error: error)
            if error == nil{
                SCLAlertView().showInfo("User Created", subTitle: "")
            }
            
        }
        
    //}
}


func addThemeData(theme: String, sucessBlock:()->Void){
    
    let ref = fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").child("theme")
    ref.setValue(theme)
    sucessBlock()
    
}

func getUserThemeData(sucessBlock:(theme: String)->Void){
    
    fireBaseRef.child("Users").child(currentUser!.uid).child("UserProfile").child("theme").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let data: String = snapshot.value as? String {
                sucessBlock(theme: data)
            }
            else
            {
                sucessBlock(theme: "")
            }
    
        })
}




//fireBaseRef.child("Dismissals").setValue(["BOWLED","CAUGHT","HANDLED THE BALL","HIT WICKET","HIT THE BALL TWICE","LEG BEFORE WICKET (LBW)","OBSTRUCTING THE FIELD","RUN OUT","RETIRED","TIMED OUT"])

public func addTimelineData(){
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
    
   
    var data:[String:String] = ["post":"It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.","User":(currentUser?.uid)!]
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
}

