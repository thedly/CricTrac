//
//  PostSendable.swift
//  CricTrac
//
//  Created by Renjith on 24/11/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

protocol PostSendable:class {
    
    func sendNewPost(text:String)
    
}

protocol previousRefershable{
    
    func refresh(data:AnyObject)
}

protocol Deletable {
    
    func deletePost(index:Int)
}