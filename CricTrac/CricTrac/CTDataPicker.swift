//
//  genderPicker.swift
//  CricTrac
//
//  Created by Tejas Hedly on 24/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

import SwiftCountryPicker

class DataPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var dataPicker: UIPickerView!
    var inputText:UITextField!
    var parent:UIViewController!
    var pickerData: [String]!
    var feetStr = String()
    var inchStr = String()
    
    private var _selectedValue: String!
    
    var selectedvalue: String {
        return _selectedValue ?? String()
    }
    
    func showPicker(parent:UIViewController,inputText:UITextField, data: [String]){
        
        self.inputText = inputText
        self.parent = parent
        pickerData = data
        
        if dataPicker == nil {
            dataPicker = UIPickerView(frame: CGRectMake(0,0,parent.view.frame.size.width, 216))
            dataPicker.backgroundColor = UIColor.whiteColor()
            dataPicker.dataSource = self
            dataPicker.delegate = self
        }
        inputText.inputView = dataPicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(DataPicker.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(DataPicker.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        inputText.text = _selectedValue
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
        
        _selectedValue = pickerData[row]
    }
    
}


