//
//  Service.swift
//  CricTrac
//
//  Created by Renjith on 8/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import Firebase

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
            print("Successfully uploaded profile image")
        
        }
    }
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
    let ref = fireBaseRef.child(currentUser!.uid).child("UserProfile")
    ref.setValue(data)
    sucessBlock(data)
}

func getAllProfileData(sucessBlock:([String:AnyObject])->Void){
    
    fireBaseRef.child(currentUser!.uid).child("UserProfile").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        
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

func getImageFromFirebase(sucessBlock:(UIImage)->Void){
    
    
    let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/UserProfile/profileImage"
    
    
    let profileImgRef  = storageRef.child(filePath)
    
    
    profileImgRef.downloadURLWithCompletion({ (url, error) in
                    if let userurl  = url,
                data = NSData(contentsOfURL: userurl)
            {
                sucessBlock(UIImage(data: data)!)
            }
        
        
    })
    
}


//fireBaseRef.child("Dismissals").setValue(["BOWLED","CAUGHT","HANDLED THE BALL","HIT WICKET","HIT THE BALL TWICE","LEG BEFORE WICKET (LBW)","OBSTRUCTING THE FIELD","RUN OUT","RETIRED","TIMED OUT"])

