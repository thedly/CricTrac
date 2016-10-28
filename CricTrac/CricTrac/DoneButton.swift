//
//  DoneButton.swift
//  CricTrac
//
//  Created by Tejas Hedly on 21/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation
import UIKit

class DoneButtonClass: NSObject {
    
    weak  var inputText:UITextField!
    
    func AddDoneButtonTo(inputText:UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(DoneButtonClass.doneClick(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(DoneButtonClass.cancelClick(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
    }
    
    func doneClick(inputText:UIButton) {
        inputText.resignFirstResponder()
    }
    func cancelClick(inputText:UIButton) {
        inputText.resignFirstResponder()
    }
    
    
       
}