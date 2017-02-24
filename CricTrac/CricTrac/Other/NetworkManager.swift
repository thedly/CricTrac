//
//  NetworkManager.swift
//  CricTrac
//
//  Created by Renjith on 13/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import SwiftyJSON


let url = "http://crictracserver.azurewebsites.net/BowlingStyle"

let serverURL = NSURL(string: url)!

let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())


var dataTask: NSURLSessionDataTask?

func getDataFromNJS(){
    
    dataTask = defaultSession.dataTaskWithURL(serverURL, completionHandler: { (data, response, error) in
        
        
        let parsedData = JSON(data:data!)
        print(parsedData)
        
    })
    
    dataTask?.resume()
    
}

func updateTimelineWithNewPost(postId:String,result:(resultError:NSError?)->Void){
    
    let timelineURL = serverBaseURL+"/user/\(currentUser!.uid)/newPost/\(postId)"
    
    let request = NSMutableURLRequest(URL: NSURL(string:timelineURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        
        result(resultError: error)
     
    })
    
    dataTask?.resume()
    
}

var pageKey:String?


func getLatestTimelines(sucess:(JSON)->Void,failure:(NSError?)->Void){
    
    let timelineURL = NSURL(string:serverBaseURL+"/timeline/\(currentUser!.uid)")!
    
    dataTask = defaultSession.dataTaskWithURL(timelineURL, completionHandler: { (data, response, error) in
        
        if error != nil{
            failure(error)
        }else{
            
            let parsedData = JSON(data:data!)
            sucess(parsedData)
        }})
    dataTask?.resume()
    
}

//'/timeline/:userId/page/:key'

func LoadTimeline(key:String,sucess:(JSON)->Void,failure:(NSError?)->Void){
    
    let timelineURL = NSURL(string:serverBaseURL+"/timeline/\(currentUser!.uid)/page/\(key)")!
    
    dataTask = defaultSession.dataTaskWithURL(timelineURL, completionHandler: { (data, response, error) in
        
        if error != nil{
            failure(error)
        }else{
            
            let parsedData = JSON(data:data!)
            sucess(parsedData)
        }})
    dataTask?.resume()
    
}


func writeAutomaticMessage(matchId:String){1
    
   // guard let firstName = loggedInUserInfo["FirstName"] as? String else { return}
    
    let timelineURL = NSURL(string:serverBaseURL+"/timelineAutoPost/\(currentUser!.uid)/MatchId/\(matchId)")!
    
    dataTask = defaultSession.dataTaskWithURL(timelineURL, completionHandler: { (data, response, error) in })
    dataTask?.resume()
}
//
