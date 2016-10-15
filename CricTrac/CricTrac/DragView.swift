//
//  DragView.swift
//  CricTrac
//
//  Created by Tejas Hedly on 30/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import UIKit

class DragView : UIView {
    
    
    var complimentTarget: DragView?
    var tossWon: Bool!
    var isBattingFirst: Bool!
    
    
    @IBOutlet weak var tossWonBtn: UIImageView!
    @IBOutlet weak var totalScore: UITextField!
    
    
    @IBOutlet weak var oversPlayed: UITextField!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var wicketsFallen: UITextField!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: complimentTarget, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
//        self.addConstraint(trailingConstraint)
//
//        
//        let trailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: complimentTarget, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
//        self.addConstraint(trailingConstraint)
        
        
        
        
        
        
        
        
//        let verticalTopConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
//        self.addConstraint(verticalTopConstraint)
//        
//        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Width, multiplier: 0.4, constant: 0)
//        self.addConstraint(widthConstraint)
//        
//        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Height, multiplier: 0.5, constant: 0)
//        self.addConstraint(heightConstraint)
        
        
        
    }
    
    
    func updateToNewConstraints() {
//        self.translatesAutoresizingMaskIntoConstraints = true
//        print(superview?.widthAnchor)
//        self.topAnchor.constraintEqualToAnchor(superview?.topAnchor).active = true
//        print(self.superview?.widthAnchor)
//        if (isBattingFirst == true) {
//            
//            self.widthAnchor.constraintEqualToAnchor(superview?.widthAnchor).active = true
//            
//            self.leadingAnchor.constraintEqualToAnchor(superview?.leadingAnchor).active = true
//            self.trailingAnchor.constraintEqualToAnchor(complimentTarget!.leadingAnchor).active = true
//        }
//        else {
//            self.leadingAnchor.constraintEqualToAnchor(complimentTarget?.trailingAnchor).active = true
//            self.trailingAnchor.constraintEqualToAnchor(superview?.trailingAnchor).active = true
//        }

        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        if (isBattingFirst == true) {
            let trailingCompConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: complimentTarget, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
            
            let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
            
            self.superview?.addConstraint(trailingCompConstraint)
            self.superview?.addConstraint(leadingConstraint)
        }
        else {
            
            let trailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
            
            let leadingCompConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: complimentTarget, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
            
            self.superview?.addConstraint(trailingConstraint)
            self.superview?.addConstraint(leadingCompConstraint)
            
        }
        
        
        
        
        
    
       
        
                   }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
            }
    
    
    
    @IBAction func incrementWicketsPressed(sender: AnyObject) {
        
        
    }
    
    
    @IBAction func decrementWicketsPressed(sender: AnyObject) {
        
        
    }
}
