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

func updateFriendTimeline(postId:String){
    
    
    
}

