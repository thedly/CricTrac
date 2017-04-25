//
//  SettingsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 22/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class ThemeSettingsViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,ThemeChangeable {

    @IBOutlet weak var topColorTxt: UITextField!
    @IBOutlet weak var bottomColorTxt: UITextField!
    @IBOutlet weak var ThemeColorSet: UICollectionView!

    var themes = [UIView]()
    var testTheme:String?
    
    private var _currentTheme:String = CurrentTheme
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func changeColorPressed(sender: UIButton) {
        if testTheme != nil {
        CurrentTheme = testTheme!
        cricTracTheme.currentTheme = cricTracTheme.testTheme
        userDefaults.setValue(testTheme, forKeyPath: "userTheme")
        NSNotificationCenter.defaultCenter().postNotificationName("ThemeChanged", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
        //save the theme to database
        addThemeData(testTheme!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "Back-100"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(CloseBtnPressed), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        menuButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        
        let applyButton:UIButton = UIButton(type:.Custom)
        applyButton.frame = CGRectMake(0, 0, 50, 40)
        applyButton.setTitle("APPLY", forState: .Normal)
        applyButton.titleLabel?.font = UIFont(name: appFont_bold, size: 15)
        applyButton.addTarget(self, action: #selector(changeColorPressed), forControlEvents:UIControlEvents.TouchUpInside)
        let rightBarButton = UIBarButtonItem(customView: applyButton)
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController!.navigationBar.barTintColor = currentTheme.topColor
        self.title = "THEMES"
    }
    
    func changeThemeSettigs(){
        //        var currentTheme:CTTheme!
        //        currentTheme = cricTracTheme.currentTheme
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
        self.title = "THEMES"
    }
    
    @IBAction func CloseBtnPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func initializeView() {
        ThemeColorSet.delegate = self
        ThemeColorSet.dataSource = self
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
        self.title = "THEMES"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarProperties()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColors.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        

        if let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as? ThemeColorsCollectionViewCell{
            if (testTheme != currentCell.theme) && (CurrentTheme != currentCell.theme) {
                setCurrentTheme(Themes(rawValue: currentCell.theme)!)
                testTheme = currentCell.theme
                navigationController!.navigationBar.barTintColor = cricTracTheme.testTheme.topColor
                setTestBackgroundColor()
                //self.view.setBackgroundColor()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThemeColorsCollectionViewCell", forIndexPath: indexPath) as? ThemeColorsCollectionViewCell {
            
            let intIndex = indexPath.row // where intIndex < myDictionary.count
            let index = themeColors.startIndex.advancedBy(intIndex) // index 1
            let key = themeColors.keys[index]
            aCell.ThemeTitle.text = themeColors.keys[index]
            
            if let colorObject = themeColors[themeColors.keys[index]] {
                
                aCell.cellTopColor = colorObject["topColor"]!
                aCell.cellBottomColor = colorObject["bottomColor"]!
                aCell.theme = themeColors[key]!["theme"]!
                setCustomUIBackgroundTheme(aCell.contentView, _topColor: colorObject["topColor"]!, _bottomColor: colorObject["bottomColor"]!)
                
                if CurrentTheme == themeColors[key]!["theme"]! {
                    aCell.alpha = 1.0
                    aCell.layer.borderWidth = 5
                    aCell.layer.borderColor = UIColor.whiteColor().CGColor
                }
                
                return aCell
            }
            else
            {
                return ThemeColorsCollectionViewCell()
            }
        }
        return ThemeColorsCollectionViewCell()
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
