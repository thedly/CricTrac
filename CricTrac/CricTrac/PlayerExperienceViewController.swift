//
//  PlayerExperienceViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 13/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class PlayerExperienceViewController: UIViewController {

    @IBOutlet weak var playingRole: UITextField!
    @IBOutlet weak var battingStyle: UITextField!
    @IBOutlet weak var bowlingStyle: UITextField!
    @IBOutlet weak var teamName: UITextField!
    
    lazy var ctDataPicker = DataPicker()
    
    var data:[String:String]{
        
        return ["PlayingRole":playingRole.textVal,"BattingStyle":battingStyle.textVal,"BowlingStyle":bowlingStyle.textVal,"TeamName":teamName.textVal]
    }
    
    let transitionManager = TransitionManager.sharedInstance
    
    
    @IBAction func goPreviousPage(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func goNextPage(sender: AnyObject) {
        let toViewController = viewControllerFrom("Main", vcid: "PlayerExperienceViewController")
        toViewController.transitioningDelegate = self.transitionManager
        presentViewController(toViewController, animated: true, completion: nil)
    }
    
    func initializeView() {
        playingRole.delegate = self
        battingStyle.delegate = self
        bowlingStyle.delegate = self
        teamName.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        
//        getAllProfileData { (data) in
//            
//            profileData = data as! [String:String]
//            
//            if profileData.count > 0 {
//                self.playingRole.text = profileData["PlayingRole"]
//                self.battingStyle.text = profileData["BattingStyle"]
//                self.bowlingStyle.text = profileData["BowlingStyle"]
//                self.teamName.text = profileData["TeamName"]
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        
        //initializeView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PlayerExperienceViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if  textField == playingRole{
            ctDataPicker = DataPicker()
            let indexPos = PlayingRoles.indexOf(playingRole.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: PlayingRoles, selectedValueIndex: indexPos)
        }
        else if  textField == battingStyle{
            ctDataPicker = DataPicker()
            let indexPos = BattingStyles.indexOf(battingStyle.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: BattingStyles,selectedValueIndex: indexPos)
        }
        else if  textField == bowlingStyle{
            ctDataPicker = DataPicker()
            let indexPos = BowlingStyles.indexOf(bowlingStyle.text!) ?? 0
            ctDataPicker.showPicker(self, inputText: textField, data: BowlingStyles, selectedValueIndex: indexPos)
        }
    }
}
