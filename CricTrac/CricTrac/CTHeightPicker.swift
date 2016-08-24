//
//  HeightPicker.swift
//  CricTrac
//
//  Created by Tejas Hedly on 24/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import Foundation

import SwiftCountryPicker


class HeightPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var heightPicker: UIPickerView!
    var inputText:UITextField!
    var parent:UIViewController!
    var pickerData: [[String]]!
    var feetStr = String()
    var inchStr = String()
    private var _selectedHeight: String!
    
    var selectedHeight: String {
        return _selectedHeight ?? String()
    }
    
    func showPicker(parent:UIViewController,inputText:UITextField){
        
        self.inputText = inputText
        self.parent = parent
        pickerData = heights
        
        if heightPicker == nil {
            heightPicker = UIPickerView(frame: CGRectMake(0,0,parent.view.frame.size.width, 216))
            heightPicker.backgroundColor = UIColor.whiteColor()
            heightPicker.dataSource = self
            heightPicker.delegate = self
        }
        inputText.inputView = heightPicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(HeightPicker.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(HeightPicker.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        inputText.text = _selectedHeight
        inputText.resignFirstResponder()
    }
    func cancelClick() {
        inputText.resignFirstResponder()
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heights[component].count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            feetStr = pickerData[component][row]
        }
        else if component == 1 {
            inchStr = pickerData[component][row]
        }
        _selectedHeight = "\(feetStr) \(inchStr)"
    }
    
}


