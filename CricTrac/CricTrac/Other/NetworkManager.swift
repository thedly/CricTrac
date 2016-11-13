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
     
    })
    
    dataTask?.resume()
    
}

