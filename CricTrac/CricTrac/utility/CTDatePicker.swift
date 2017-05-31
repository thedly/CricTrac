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
            
            let dateText = inputText.text
            if dateText != "" {
                let df = NSDateFormatter()
                df.dateFormat = "dd-MMM-yyyy"
                datePicker.date = df.dateFromString(dateText!)!
            }
            datePicker.maximumDate = NSDate()
        }
        inputText.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
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
        let gbDateFormat = NSDateFormatter.dateFormatFromTemplate("dd MMM YYYY", options: 0, locale: NSLocale(localeIdentifier: "en-GB"))

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateFormat = gbDateFormat
        
        let selectedDate = dateFormatter.stringFromDate(datePicker.date)
        
        inputText.text = selectedDate.replaceStr(" ", withString: "-")
        inputText.resignFirstResponder()
    }
    func cancelClick() {
        inputText.resignFirstResponder()
    }

}
