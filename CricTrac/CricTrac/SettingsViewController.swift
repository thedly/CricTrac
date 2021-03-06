//
//  SettingsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 22/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,ThemeChangeable {

    @IBOutlet weak var topColorTxt: UITextField!
    @IBOutlet weak var bottomColorTxt: UITextField!
    
    @IBOutlet weak var ThemeColorSet: UICollectionView!
    
    @IBOutlet weak var defaultView: UIView!
    
    @IBOutlet weak var sunsetView: UIView!
    
    @IBOutlet weak var dawnView: UIView!
    
    @IBOutlet weak var duskView: UIView!
    
    @IBOutlet weak var turquoiseView: UIView!
    
    @IBOutlet weak var instagramView: UIView!
    
    @IBOutlet weak var mangoView: UIView!
    
    @IBOutlet weak var hersheysView: UIView!
    
   
    @IBOutlet weak var cocktailView: UIView!
    
    @IBOutlet weak var earthlyView: UIView!
    
    
    
    
    var themes = [UIView]()
    
    private var _currentTheme:String = CurrentTheme
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func changeColorPressed(sender: AnyObject) {
        CurrentTheme = _currentTheme
        userDefaults.setValue(CurrentTheme, forKeyPath: "userTheme")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    func changeThemeSettigs(){
        
        
    }
    
    
    @IBAction func CloseBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initializeView() {
        
        ThemeColorSet.delegate = self
        ThemeColorSet.dataSource = self
        
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
            
            setCurrentTheme(Themes(rawValue: currentCell.theme)!)
            
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
