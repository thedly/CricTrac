//
//  CTPicker.swift
//  CricTrac
//
//  Created by Renjith on 8/26/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CTPicker: NSObject {
    
   weak  var inputText:UITextField!
   weak var parent:UIViewController!
    var pickerView:UIPickerView = UIPickerView()
   var dataSource:[String]!
    var selecetedData = ""
    
   override init() {
    super.init()
    pickerView.dataSource = self
    pickerView.delegate = self
    }
    
    func showPicker(parent:UIViewController,inputText:UITextField,data:[String]){
        
        self.inputText = inputText
        self.parent = parent
        dataSource = data
        

            pickerView.frame = CGRectMake(0,0,parent.view.frame.size.width, 216)
            pickerView.backgroundColor = UIColor.whiteColor()
        
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CTPicker.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CTPicker.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
        inputText.inputView = pickerView
        selecetedData = dataSource[0]
    }

    func doneClick() {
        inputText.text = selecetedData
        inputText.resignFirstResponder()
    }
    func cancelClick() {
        inputText.resignFirstResponder()
    }
    
    
    class var sharedInstance: CTPicker {
        struct Static {
            static let instance = CTPicker()
        }
        return Static.instance
    }
    
    
}



extension CTPicker : UIPickerViewDelegate,UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
     func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        selecetedData = dataSource[row]
    }
    
}


public func showPicker(parent:UIViewController,inputText:UITextField,data:[String]){
    
    CTPicker.sharedInstance.showPicker(parent, inputText: inputText, data: data)
    
}

