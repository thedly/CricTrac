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

func updateTimelineWithNewPost(postId:String){
    let timelineURL = serverBaseURL+"/user/\(currentUser!.uid)/newPost/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:timelineURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func friendRequestReceivedNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/FRR/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func friendRequestAcceptedNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/FRA/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func newPostNotification(postId:String){
    let notificationURL = serverBaseURL+"/notifications/NPA/\((currentUser!.uid))/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func newCommentNotification(postId:String){
    let notificationURL = serverBaseURL+"/notifications/NCA/\((currentUser!.uid))/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func newLikeNotification(postId:String){
    let notificationURL = serverBaseURL+"/notifications/NLA/\((currentUser!.uid))/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func newMatchNotification(matchId:String){
    let notificationURL = serverBaseURL+"/notifications/NMA/\((currentUser!.uid))/\(matchId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func timelinePostBump(postId:String){
    let timelineBumpURL = serverBaseURL+"/editTimeline/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:timelineBumpURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
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

/*
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
*/

func writeAutomaticMessage(matchId:String){
    
    let timelineURL = serverBaseURL+"/timelineAutoPost/\(currentUser!.uid)/MatchId/\(matchId)"
    let request = NSMutableURLRequest(URL: NSURL(string: timelineURL)!)
    request.HTTPMethod = "POST"
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        guard error == nil && data != nil else {
            // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
            // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
        print("responseString = \(responseString)")
    }
    task.resume()
    
   // guard let firstName = loggedInUserInfo["FirstName"] as? String else { return}
    
    //let timelineURL = NSURL(string:serverBaseURL+"/timelineAutoPost/\(currentUser!.uid)/MatchId/\(matchId)")!

    //dataTask = defaultSession.dataTaskWithURL(timelineURL, completionHandler: { (data, response, error) in
    
      //  print(response)
        
      //  print(error)
    //})
    //dataTask?.resume()
    
}
//
