//
//  NetworkManager.swift
//  CricTrac
//
//  Created by Renjith on 13/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import SwiftyJSON

let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

var dataTask: NSURLSessionDataTask?

func updateTimelineWithNewPost(postId:String){
    let timelineURL = serverBaseURL+"/user/\(currentUser!.uid)/newPost/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:timelineURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        //result(resultError: error)
    })
    dataTask?.resume()
}

func followNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/NFR/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func friendRequestReceivedNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/FRR/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func friendRequestAcceptedNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/FRA/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func coachRequestReceivedNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/CRR/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func coachRequesAcceptedtNotification(toId:String){
    let notificationURL = serverBaseURL+"/notifications/CRA/\((currentUser!.uid))/\(toId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func newPostNotification(postId:String){
    let notificationURL = serverBaseURL+"/notifications/NPA/\((currentUser!.uid))/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func newCommentNotification(postId:String){
    let notificationURL = serverBaseURL+"/notifications/NCA/\((currentUser!.uid))/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func newLikeNotification(postId:String){
    let notificationURL = serverBaseURL+"/notifications/NLA/\((currentUser!.uid))/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func newMatchNotification(matchId:String){
    let notificationURL = serverBaseURL+"/notifications/NMA/\((currentUser!.uid))/\(matchId)"
    let request = NSMutableURLRequest(URL: NSURL(string:notificationURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

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


func timelinePostBump(postId:String){
    let timelineBumpURL = serverBaseURL+"/editTimeline/\(postId)"
    let request = NSMutableURLRequest(URL: NSURL(string:timelineBumpURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func sendWelcomeMail(userId:String){
    let welcomeMailURL = serverBaseURL+"/welcomeMail/\((userId))"
    let request = NSMutableURLRequest(URL: NSURL(string:welcomeMailURL)!)
    request.HTTPMethod = "GET"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func sendUpgradeMail(userId:String){
    let welcomeMailURL = serverBaseURL+"/upgradeMail/\((userId))"
    let request = NSMutableURLRequest(URL: NSURL(string:welcomeMailURL)!)
    request.HTTPMethod = "GET"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}

func followCount(userId:String){
    let followCountURL = serverBaseURL+"/followCount/\((userId))"
    let request = NSMutableURLRequest(URL: NSURL(string:followCountURL)!)
    request.HTTPMethod = "POST"
    
    dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
    })
    dataTask?.resume()
}



var pageKey:String?

func getLatestTimelines(sucess:(JSON)->Void,failure:(NSError?)->Void){
    let timelineURL = NSURL(string:serverBaseURL+"/timeline/\(currentUser!.uid)")!
    dataTask = defaultSession.dataTaskWithURL(timelineURL, completionHandler: { (data, response, error) in
        if error != nil{
            failure(error)
        }
        else{
            let parsedData = JSON(data:data!)
            sucess(parsedData)
        }})
    dataTask?.resume()
}

func LoadTimeline(key:String,sucess:(JSON)->Void,failure:(NSError?)->Void){
    let timelineURL = NSURL(string:serverBaseURL+"/timeline/\(currentUser!.uid)/page/\(key)")!
    dataTask = defaultSession.dataTaskWithURL(timelineURL, completionHandler: { (data, response, error) in
        if error != nil{
            failure(error)
        }
        else{
            let parsedData = JSON(data:data!)
            sucess(parsedData)
        }})
    dataTask?.resume()
}

func writeAutomaticMessage(matchId:String){
    let timelineURL = serverBaseURL+"/timelineAutoPost/\(currentUser!.uid)/MatchId/\(matchId)"
    let request = NSMutableURLRequest(URL: NSURL(string: timelineURL)!)
    request.HTTPMethod = "POST"
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        guard error == nil && data != nil else {
            // check for fundamental networking error
            //print("error=\(error)")
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
}

