//
//  utility.swift
//  CricTrac
//
//  Created by Renjith on 7/21/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import KYDrawerController
import FirebaseAuth

var sliderMenu = KYDrawerController()
var currentUser:FIRUser?

var groundNames = [String]()
var teamNames = [String]()
var opponentTeams = [String]()
var dismissals = [String]()
var tournaments = [String]()
var results = [String]()
var profileData = [String:String]()
var BattingStyles = [String]()
var BowlingStyles = [String]()
var PlayingRoles = [String]()
var PlayingLevels = [String]()
var genders = [String]()
var matchDataSource = [[String:String]]()
var profileDataChanged: Bool = false

public func viewControllerFrom(storyBoard:String,vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:storyBoard, bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
}


public func viewController(vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:"Main", bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
}


func += <K, V> (inout left: [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}


//MARK :- Firebase Auth

public func firebaseLogin(credential: FIRAuthCredential, sucess:(FIRUser)->Void,failure:(NSError)->Void){
    
    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
        
        if user != nil{
            sucess(user!)
        }
        else{
            failure(error!)
        }
        
    }
}


public func firebaseLoginWithFacebook(fbToken:String,sucess:(FIRUser)->Void,failure:(NSError)->Void){
    
    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(fbToken)
    firebaseLogin(credential, sucess: { (user) in
        
        sucess(user)
        
        }) { (error) in
            
        failure(error)
    }
}



public func firebaseLoginWithGoogle(idToken:String,accessToken:String,sucess:(FIRUser)->Void,failure:(NSError)->Void){
    
    let credential = FIRGoogleAuthProvider.credentialWithIDToken(idToken,
                                                                 accessToken:accessToken)
    firebaseLogin(credential, sucess: { (user) in
        
        sucess(user)
        
    }) { (error) in
        
        failure(error)
    }
}

public func directoryExistsInsideDocuments(name:String)->Bool{
    
    let fileManager = NSFileManager()
    var isDir : ObjCBool = false
    let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    if fileManager.fileExistsAtPath(docPath+"/\(name)", isDirectory:&isDir) {
        if isDir {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
    
}

public func fileExists(url:String)->Bool{
    
    let fileManager = NSFileManager()
    var isDir : ObjCBool = false
 
    if fileManager.fileExistsAtPath(url, isDirectory:&isDir) {
        if isDir {
            return false
        } else {
            return true
        }
    } else {
        return false
    }
    
}


public func createDirectoryInsideDocuments(name:String)->Bool{
    
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let documentsDirectory: AnyObject = paths[0]
    let dataPath = documentsDirectory.stringByAppendingPathComponent(name)
    
    do {
        try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
        return true
    } catch _ as NSError {
        return false
    }
}

var documentsDirectory:AnyObject {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
}

func saveToCachedImages(image:UIImage,imageName:String){

        if let data = UIImagePNGRepresentation(image) {
            let filename = documentsDirectory.stringByAppendingPathComponent("cachedImages/\(imageName).png")
             data.writeToFile(filename, atomically: false)
        }
}




