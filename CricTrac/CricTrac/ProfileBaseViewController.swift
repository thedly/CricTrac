//
//  ProfileBaseViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 10/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ProfileBaseViewController: UIViewController , UIGestureRecognizerDelegate {
    
   
    
    @IBAction func nextBtnPressed(sender: AnyObject) {
        var toViewController: UIViewController
        switch profileData["UserType"] {
        case userProfileType.Player.rawValue? :
            toViewController = viewControllerFrom("Main", vcid: "PlayerExperienceViewController")
        case userProfileType.Coach.rawValue? :
            toViewController = viewControllerFrom("Main", vcid: "CoachingExperienceViewController")
        case userProfileType.Fan.rawValue? :
            toViewController = viewControllerFrom("Main", vcid: "CricketFanViewController")
        default:
            toViewController = viewControllerFrom("Main", vcid: "PlayerExperienceViewController")
        }
        toViewController.transitioningDelegate = self.transitionManager
        presentViewController(toViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var playerTextView: radioSelectView!
    @IBOutlet weak var coachTextView: radioSelectView!
    @IBOutlet weak var cricketFanTextView: radioSelectView!
    
    let transitionManager = TransitionManager.sharedInstance
    
    
    
    func handleProfileTap(sender: UITapGestureRecognizer? = nil) {
        deselectAll(self.view)
        playerTextView.isSelected = true
        profileData["UserType"] = userProfileType.Player.rawValue
    }
    
    func handleCoachTap(sender: UITapGestureRecognizer? = nil) {
        deselectAll(self.view)
        coachTextView.isSelected = true
        profileData["UserType"] = userProfileType.Coach.rawValue
    }
    
    func handleFanTap(sender: UITapGestureRecognizer? = nil) {
        deselectAll(self.view)
        cricketFanTextView.isSelected = true
        profileData["UserType"] = userProfileType.Fan.rawValue
    }
    
    
    
    
    
    @IBAction func disPressCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func setupControls() {
        
        let playertap = UITapGestureRecognizer(target: self, action: #selector(ProfileBaseViewController.handleProfileTap(_:)))
        playertap.delegate = self
        
        let coachtap = UITapGestureRecognizer(target: self, action: #selector(ProfileBaseViewController.handleCoachTap(_:)))
        coachtap.delegate = self
        
        let fantap = UITapGestureRecognizer(target: self, action: #selector(ProfileBaseViewController.handleFanTap(_:)))
        fantap.delegate = self

        
        
        playerTextView.userInteractionEnabled = true
        playerTextView.addGestureRecognizer(playertap)
        
        coachTextView.userInteractionEnabled = true
        coachTextView.addGestureRecognizer(coachtap)
        
        cricketFanTextView.userInteractionEnabled = true
        cricketFanTextView.addGestureRecognizer(fantap)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBackgroundTheme(self.view)
        setupControls()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func deselectAll(baseView: UIView) {
        for view in baseView.subviews {
            if view.accessibilityIdentifier == "radioSelect" {
                if let lbl: radioSelectView = view as? radioSelectView {
                    lbl.isSelected = false;
                }
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

