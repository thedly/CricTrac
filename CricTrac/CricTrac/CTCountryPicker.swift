//
//  CTCountryPicker.swift
//  CricTrac
//
//  Created by Tejas on 7/26/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SwiftCountryPicker

import SwiftCSV

class CTCountryPicker: NSObject {
    
    var countryPicker: CountryPicker!
    var inputText:UITextField!
    var parent:UIViewController!
    private var states: [String]!
    var SelectedCountry: String {
        if countryPicker != nil , let _selectedCountry = countryPicker.pickedCountry! as? Country {
            return _selectedCountry.name
        }
        else
        {
            return String()
        }
    }
    
    var SelectedISO: String {
        if countryPicker != nil , let _selectedISO: Country = countryPicker.pickedCountry! as Country {
            return _selectedISO.iso
        }
        else
        {
            return String()
        }
    }
    
    var States: [String] {
        if let _states = states as? [String] {
            return _states
        }
        else
        {
            return [String]()
        }
        
    }
    
    func showPicker(parent:UIViewController,inputText:UITextField){
        
        self.inputText = inputText
        self.parent = parent
        if countryPicker == nil {
            countryPicker = CountryPicker(frame: CGRectMake(0,0,parent.view.frame.size.width, 216))
            countryPicker.backgroundColor = UIColor.whiteColor()
        }
        inputText.inputView = countryPicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(hex: "B12420")
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(CTCountryPicker.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CTCountryPicker.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        inputText.inputAccessoryView = toolBar
        
    }
    
    func doneClick() {
        inputText.text = countryPicker.pickedCountry?.name
        self.states = getStatesByISO((countryPicker.pickedCountry?.iso)!)
        inputText.resignFirstResponder()
    }
    func cancelClick() {
        inputText.resignFirstResponder()
    }
    
    func getStatesByISO(_iso : String) -> [String] {
        do {
            let states = try CSV(name: NSBundle.mainBundle().pathForResource("data", ofType: "csv")!)
            let iso : String = (_iso)
            
            var filteredStatesByISO = [String]()
            
            states.enumerateAsArray { array in
                if array[4] == iso {
                    filteredStatesByISO.append(array[2])
                }
            }
            return filteredStatesByISO
        }
        catch let error as NSError {
            print(error.debugDescription)
            return [String]()
        }
    }
    
}
