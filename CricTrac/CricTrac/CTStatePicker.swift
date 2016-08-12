//
//  CTStatePicker.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import SwiftCountryPicker

import SwiftCSV

class CTStatePicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var statePicker: UIPickerView!
    var inputText:UITextField!
    var inputISO: String!
    var parent:UIViewController!
    var pickerData: [String]!
    
    private var _selectedState: String!
    
    var selectedState: String {
        return _selectedState ?? String()
    }
    
    func showPicker(parent:UIViewController,inputText:UITextField, states: [String]){
        
        if states.count == 0 {
            return
        }
        
        self.inputText = inputText
        self.parent = parent
        pickerData = states
        
        if statePicker == nil {
            statePicker = UIPickerView(frame: CGRectMake(0,0,parent.view.frame.size.width, 216))
            statePicker.backgroundColor = UIColor.whiteColor()
            statePicker.dataSource = self
            statePicker.delegate = self
        }
        inputText.inputView = statePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CTStatePicker.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CTStatePicker.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        inputText.text = _selectedState
        inputText.resignFirstResponder()
    }
    func cancelClick() {
        inputText.resignFirstResponder()
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _selectedState = pickerData[row]
    }
    
}


