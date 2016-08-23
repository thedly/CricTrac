//
//  SuggestionView.swift
//  CricTrac
//
//  Created by Renjith on 8/16/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SuggestionView: UIView,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var suggestionTable:UITableView!
    private var dataSource:[String]? = nil
    weak var textField:UITextField? = nil
    var oldDelegate:UITextFieldDelegate? = nil
    private var filturedData:[String]? = nil
    
    
    @IBAction func didCancel(sender: AnyObject) {
        
        self.removeFromSuperview()
        textField!.delegate = oldDelegate
    }
    
    func setDataSource(data:[String]){
        
        dataSource = data
        filturedData = data
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let aCell = suggestionTable.dequeueReusableCellWithIdentifier("suggCell", forIndexPath: indexPath) as! SuggestionCell
        aCell.selectionStyle = .None
        aCell.contentlabel?.text = filturedData![indexPath.row]
        return aCell
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filturedData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        textField?.text = filturedData![indexPath.row]
        self.hidden = true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        self.removeFromSuperview()
        textField.delegate = oldDelegate
        return true
    }
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        self.hidden = false
        var newString = ""
        
        if string == ""{
            
            let textFieldVal = textField.text! as NSString
            
            newString = textFieldVal.stringByReplacingCharactersInRange(range, withString: string) as String
        }
        else {
            
            newString = textField.text!+string
            
        }
        if newString != ""{
        filturedData = dataSource!.filter() { $0.rangeOfString(newString, options: [.DiacriticInsensitiveSearch, .CaseInsensitiveSearch]) != nil }
            
            if filturedData?.count == 0{
                self.hidden = true
            }
            else{
                self.hidden = false
            }
            
        }
        else{
           self.hidden = true
        }
        suggestionTable.reloadData()
        return true
    }

    
    
}

var  suggestionView:SuggestionView{
    
    let suggestionView =  UINib(
        nibName: "SuggestionView",
        bundle: nil
        ).instantiateWithOwner(nil, options: nil)[0] as! SuggestionView

    suggestionView.suggestionTable.registerNib(UINib.init(nibName: "SuggestionCell", bundle: nil), forCellReuseIdentifier: "suggCell")
    
    return suggestionView
    
}

let sBox = suggestionView


func removeSuggestion(){
    
    if let _ = sBox.superview{
        
        sBox.removeFromSuperview()
    }
    
    sBox.textField?.delegate = sBox.oldDelegate
}



func addSuggstionBox(textField:UITextField,dataSource:[String],showSuggestions:Bool = false){
    
    let suggBox = sBox
    suggBox.setDataSource(dataSource)
    suggBox.textField = textField
    suggBox.oldDelegate = textField.delegate
    suggBox.hidden = !showSuggestions
    let theFrame = textField.frame
    suggBox.frame = CGRectMake(theFrame.minX, theFrame.maxY, theFrame.width, 20)
    
    if let _ = suggBox.superview{
        
        suggBox.removeFromSuperview()
    }
    
    textField.superview?.addSubview(suggBox)
    
    
    
   let heightConstraint =   NSLayoutConstraint(item: suggBox, attribute:
        .Height, relatedBy: .Equal, toItem: nil,
                 attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0,
                 constant: 100)
    
    let widthConstraint = NSLayoutConstraint(item: suggBox, attribute:
        .Width , relatedBy: .Equal, toItem: textField,
                 attribute: .Width , multiplier: 1.0,
                 constant: 10)
    
    let topConstraint = NSLayoutConstraint(item: suggBox, attribute:
        .Top , relatedBy: .Equal, toItem: textField,
                 attribute: .Bottom, multiplier: 1.0,
                 constant: 0)
    
    let leadingConstraint = NSLayoutConstraint(item: suggBox, attribute:
        .Leading , relatedBy: .Equal, toItem: textField,
               attribute: .Leading, multiplier: 1.0,
               constant: 0)
    
    
    UIView.animateWithDuration(0.5) { 
        
        suggBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([heightConstraint,widthConstraint,topConstraint,leadingConstraint])
        textField.delegate = suggBox
    }
    
    suggBox.suggestionTable.reloadData()
}

