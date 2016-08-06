//
//  ExtraViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/6/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import AnimatedTextInput

class ExtraViewController: UIViewController,IndicatorInfoProvider {
    
     @IBOutlet weak var commentsText:AnimatedTextInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         commentsText.type = .multiline
         commentsText.style =  CustomTextInputStyle()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "EXTRA")
    }
    
    
}
