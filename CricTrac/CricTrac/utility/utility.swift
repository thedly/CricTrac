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

public func viewControllerFrom(storyBoard:String,vcid:String)->UIViewController{
    
    let storyboard = UIStoryboard(name:storyBoard, bundle: nil)
    
    return storyboard.instantiateViewControllerWithIdentifier(vcid)
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




