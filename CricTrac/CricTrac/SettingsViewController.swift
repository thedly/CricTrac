//
//  SettingsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 22/09/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

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
        
        
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func CloseBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initializeView() {
        
        ThemeColorSet.delegate = self
        ThemeColorSet.dataSource = self
        
//        let sunsettap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleSunsetTap(_:)))
//        sunsettap.delegate = self
//        
//        let dusktap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleDuskTap(_:)))
//        dusktap.delegate = self
//        
//        let dawntap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleDawnTap(_:)))
//        dawntap.delegate = self
//        
//        let defaulttap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handledefaulttap(_:)))
//        dawntap.delegate = self
//        
//        
//        
//        
//        let earthlytap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleEarthlyTap(_:)))
//        sunsettap.delegate = self
//        
//        let cocktailtap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleCocktailTap(_:)))
//        dusktap.delegate = self
//        
//        
//        
//        
//        
//        
//        
//        let hersheystap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleHersheysTap(_:)))
//        dawntap.delegate = self
//        
//        let mangotap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleMangotap(_:)))
//        dawntap.delegate = self
//        
//        let instagramtap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleInstagramTap(_:)))
//        sunsettap.delegate = self
//        
//        let turquoisetap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleTurquoiseTap(_:)))
//        dusktap.delegate = self
        
       
//        defaultView.alpha = CurrentTheme == "MeanGreen" ? 1.0 : 0.5
//        sunsetView.alpha = CurrentTheme == "Sunset" ? 1.0 : 0.5
//        dawnView.alpha = CurrentTheme == "Dawn" ? 1.0 : 0.5
//        duskView.alpha = CurrentTheme == "Dusk" ? 1.0 : 0.5
//        
//        cocktailView.alpha = CurrentTheme == "Cocktail" ? 1.0 : 0.5
//        earthlyView.alpha = CurrentTheme == "Earthly" ? 1.0 : 0.5
//        mangoView.alpha = CurrentTheme == "Mango" ? 1.0 : 0.5
//        turquoiseView.alpha = CurrentTheme == "Turquoise" ? 1.0 : 0.5
//        
//        instagramView.alpha = CurrentTheme == "Instagram" ? 1.0 : 0.5
//        hersheysView.alpha = CurrentTheme == "Hersheys" ? 1.0 : 0.5
//        
//        
//        sunsetView.userInteractionEnabled = true
//        sunsetView.addGestureRecognizer(sunsettap)
//        
//        dawnView.userInteractionEnabled = true
//        dawnView.addGestureRecognizer(dawntap)
//        
//        duskView.userInteractionEnabled = true
//        duskView.addGestureRecognizer(dusktap)
//        
//        instagramView.userInteractionEnabled = true
//        instagramView.addGestureRecognizer(instagramtap)
//        
//        cocktailView.userInteractionEnabled = true
//        cocktailView.addGestureRecognizer(cocktailtap)
//        
//        turquoiseView.userInteractionEnabled = true
//        turquoiseView.addGestureRecognizer(turquoisetap)
//        
//        mangoView.userInteractionEnabled = true
//        mangoView.addGestureRecognizer(mangotap)
//        
//        hersheysView.userInteractionEnabled = true
//        hersheysView.addGestureRecognizer(hersheystap)
//        
//        defaultView.userInteractionEnabled = true
//        defaultView.addGestureRecognizer(defaulttap)
//        
//        earthlyView.userInteractionEnabled = true
//        earthlyView.addGestureRecognizer(earthlytap)
        
        
        // view.userInteractionEnabled = true
        
        //myView.addGestureRecognizer(tap)
    }

//    func handleDuskTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        duskView.alpha = 1.0
//        _currentTheme = "Dusk"
//    }
//    
//    func handleDawnTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        dawnView.alpha = 1.0
//        _currentTheme = "Dawn"
//    }
//
//    func handleSunsetTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        sunsetView.alpha = 1.0
//        _currentTheme = "Sunset"
//    }
//    
//    func handledefaulttap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        defaultView.alpha = 1.0
//        _currentTheme = "MeanGreen"
//    }
//    
//    func handleTurquoiseTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        turquoiseView.alpha = 1.0
//        _currentTheme = "Turquoise"
//    }
//    
//    func handleInstagramTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        instagramView.alpha = 1.0
//        _currentTheme = "Instagram"
//    }
//    
//    func handleHersheysTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        hersheysView.alpha = 1.0
//        _currentTheme = "Hersheys"
//    }
//    
//    func handleMangotap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        mangoView.alpha = 1.0
//        _currentTheme = "Mango"
//    }
//    
//    func handleEarthlyTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        earthlyView.alpha = 1.0
//        _currentTheme = "Earthly"
//    }
//    
//    func handleCocktailTap(sender: UITapGestureRecognizer? = nil) {
//        fadeViews()
//        cocktailView.alpha = 1.0
//        _currentTheme = "Cocktail"
//    }

    
    
//    func fadeViews(){
//        
//        defaultView.alpha = 0.5
//        dawnView.alpha = 0.5
//        sunsetView.alpha = 0.5
//        duskView.alpha = 0.5
//        
//        earthlyView.alpha = 0.5
//        instagramView.alpha = 0.5
//        mangoView.alpha = 0.5
//        cocktailView.alpha = 0.5
//        
//        hersheysView.alpha = 0.5
//        turquoiseView.alpha = 0.5
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColors.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let allCells = collectionView.visibleCells() as! [ThemeColorsCollectionViewCell]
        
        allCells.forEach({ cell in
            cell.cellIsSelected = false
        })
        
        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! ThemeColorsCollectionViewCell
        
        currentCell.cellIsSelected = true
        _currentTheme = currentCell.ThemeTitle.text!
        self.view.backgroundColor = currentCell.contentView.backgroundColor
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let aCell = collectionView.dequeueReusableCellWithReuseIdentifier("ThemeColorsCollectionViewCell", forIndexPath: indexPath) as? ThemeColorsCollectionViewCell {
            
            
            let intIndex = indexPath.row // where intIndex < myDictionary.count
            let index = themeColors.startIndex.advancedBy(intIndex) // index 1
            
            aCell.ThemeTitle.text = themeColors.keys[index]
            
            
            if let colorObject = themeColors[themeColors.keys[index]] {
                
                aCell.cellTopColor = colorObject["topColor"]!
                aCell.cellBottomColor = colorObject["bottomColor"]!
                
                
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
