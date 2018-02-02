//
//  Celebrity.swift
//  CricTrac
//
//  Created by Sajith Kumar on 02/02/18.
//  Copyright © 2018 CricTrac. All rights reserved.
//

import Foundation

class Celebrity {
    
    var ProfileInfo: [String] = []
    
    init(celebObj : [String: AnyObject]) {
        
        if let profileInfo = celebObj["Profile"] {
            self.ProfileInfo = profileInfo as! [String]
            
        }
        

        

    }
    
    var CelebrityObject: [String:AnyObject] {
        
            return [
                "ProfileInfo": self.ProfileInfo
            ]
    }
}

//extension String {
//    func whiteSpacesTrimmedString() -> String {
//        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//    }
//}

