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
func addMatchData(key:NSString,data:[String:String]){
    
    let ref = fireBaseRef.child(currentUser!.uid).child("Matches").childByAutoId()
    ref.setValue(data)
    
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
