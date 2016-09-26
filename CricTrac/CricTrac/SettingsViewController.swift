//
//  SettingsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 22/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var topColorTxt: UITextField!
    @IBOutlet weak var bottomColorTxt: UITextField!
    
    
    @IBOutlet weak var defaultView: UIView!
    
    @IBOutlet weak var sunsetView: UIView!
    
    @IBOutlet weak var dawnView: UIView!
    
    @IBOutlet weak var duskView: UIView!
    
    var themes = [UIView]()
    
    private var _topColor:String = topColor
    private var _bottomColor:String = topColor
    private var _currentTheme:String = CurrentTheme
    
    
    @IBAction func changeColorPressed(sender: AnyObject) {
        
        topColor = "#\(_topColor)"
        bottomColor = "#\(_bottomColor)"
        appThemeChanged = true
        CurrentTheme = _currentTheme
        dismissViewControllerAnimated(true, completion: nil)
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func CloseBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initializeView() {
        
        
        
        let sunsettap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleSunsetTap(_:)))
        sunsettap.delegate = self
        
        let dusktap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleDuskTap(_:)))
        dusktap.delegate = self
        
        let dawntap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleDawnTap(_:)))
        dawntap.delegate = self
        
        let defaulttap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handledefaulttap(_:)))
        dawntap.delegate = self
       
        defaultView.alpha = CurrentTheme == "MeanGreen" ? 1.0 : 0.5
        
        sunsetView.alpha = CurrentTheme == "Sunset" ? 1.0 : 0.5
        
        dawnView.alpha = CurrentTheme == "Dawn" ? 1.0 : 0.5
        
        duskView.alpha = CurrentTheme == "Dusk" ? 1.0 : 0.5
        
        
        sunsetView.userInteractionEnabled = true
        sunsetView.addGestureRecognizer(sunsettap)
        
        
        dawnView.userInteractionEnabled = true
        dawnView.addGestureRecognizer(dawntap)
        
        duskView.userInteractionEnabled = true
        duskView.addGestureRecognizer(dusktap)
        
        defaultView.userInteractionEnabled = true
        defaultView.addGestureRecognizer(defaulttap)
        
        
        // view.userInteractionEnabled = true
        
        //myView.addGestureRecognizer(tap)
    }

    func handleDuskTap(sender: UITapGestureRecognizer? = nil) {
        fadeViews()
        duskView.alpha = 1.0
        
        _topColor = "000000"
        _bottomColor = "434343"
        _currentTheme = "Dusk"
    }
    
    func handleDawnTap(sender: UITapGestureRecognizer? = nil) {
        fadeViews()
        dawnView.alpha = 1.0
        
        _topColor = "4DA0B0"
        _bottomColor = "D39D38"
        _currentTheme = "Dawn"
        
    }

    func handleSunsetTap(sender: UITapGestureRecognizer? = nil) {
        fadeViews()
        sunsetView.alpha = 1.0
        
        _topColor = "FF9500"
        _bottomColor = "FF5E3A"
        _currentTheme = "Sunset"
    }
    
    func handledefaulttap(sender: UITapGestureRecognizer? = nil) {
        fadeViews()
        defaultView.alpha = 1.0
        
        _topColor = "84CC00"
        _bottomColor = "4D9D00"
        _currentTheme = "MeanGreen"
    }

    
    
    func fadeViews(){
        
        defaultView.alpha = 0.5
        dawnView.alpha = 0.5
        sunsetView.alpha = 0.5
        duskView.alpha = 0.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
