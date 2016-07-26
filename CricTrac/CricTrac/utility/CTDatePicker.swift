//
//  CTDatePicker.swift
//  CricTrac
//
//  Created by Renjith on 7/26/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CTDatePicker: NSObject {
    
    var datePicker:UIDatePicker!
    var inputText:UITextField!
    var parent:UIViewController!
    
    func showPicker(parent:UIViewController,inputText:UITextField){
        
        self.inputText = inputText
        self.parent = parent
        
        // DatePicker
        if datePicker == nil{
        datePicker = UIDatePicker(frame:CGRectMake(0, 0, parent.view.frame.size.width, 216))
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.datePickerMode = UIDatePickerMode.Date
        }
        inputText.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "BB4440")
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CTDatePicker.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CTDatePicker.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
       
    }
    
    func doneClick() {
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateStyle = .MediumStyle
        dateFormatter1.timeStyle = .NoStyle
        inputText.text = dateFormatter1.stringFromDate(datePicker.date)
        inputText.resignFirstResponder()
    }
    func cancelClick() {
        inputText.resignFirstResponder()
    }

}
