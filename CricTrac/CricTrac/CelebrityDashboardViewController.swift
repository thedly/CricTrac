//
//  CelebrityDashboardViewController.swift
//  CricTrac
//
//  Created by Arjun Innovations on 01/02/18.
//  Copyright © 2018 CricTrac. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CelebrityDashboardViewController: UIViewController,ThemeChangeable {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    

    
    @IBOutlet weak var playingRole: UILabel!
    @IBOutlet weak var bowlingStyle: UILabel!
    @IBOutlet weak var majorTeams: UILabel!
    @IBOutlet weak var profile: UILabel!
    
    //batting
    @IBOutlet weak var BatTestsMat: UILabel!
    @IBOutlet weak var BatTestsInns: UILabel!
    @IBOutlet weak var BatTestsNO: UILabel!
    @IBOutlet weak var BatTestsRuns: UILabel!
    @IBOutlet weak var BatTestsHS: UILabel!
    @IBOutlet weak var BatTestsAve: UILabel!
    @IBOutlet weak var BatTestsBF: UILabel!
    @IBOutlet weak var BatTestsSR: UILabel!
    @IBOutlet weak var BatTests100: UILabel!
    @IBOutlet weak var BatTests50: UILabel!
    @IBOutlet weak var BatTests4s: UILabel!
    @IBOutlet weak var BatTests6s: UILabel!
    @IBOutlet weak var BatTestsCt: UILabel!
    @IBOutlet weak var BatTestsSt: UILabel!
    
    @IBOutlet weak var BatODIsMat: UILabel!
    @IBOutlet weak var BatODIsInns: UILabel!
    @IBOutlet weak var BatODIsNO: UILabel!
    @IBOutlet weak var BatODIsRuns: UILabel!
    @IBOutlet weak var BatODIsHS: UILabel!
    @IBOutlet weak var BatODIsAve: UILabel!
    @IBOutlet weak var BatODIsBF: UILabel!
    @IBOutlet weak var BatODIsSR: UILabel!
    @IBOutlet weak var BatODIs100: UILabel!
    @IBOutlet weak var BatODIs50: UILabel!
    @IBOutlet weak var BatODIs4s: UILabel!
    @IBOutlet weak var BatODIs6s: UILabel!
    @IBOutlet weak var BatODIsCt: UILabel!
    @IBOutlet weak var BatODIsSt: UILabel!
    
    @IBOutlet weak var BatT20IsMat: UILabel!
    @IBOutlet weak var BatT20IsInns: UILabel!
    @IBOutlet weak var BatT20IsNO: UILabel!
    @IBOutlet weak var BatT20IsRuns: UILabel!
    @IBOutlet weak var BatT20IsHS: UILabel!
    @IBOutlet weak var BatT20IsAve: UILabel!
    @IBOutlet weak var BatT20IsBF: UILabel!
    @IBOutlet weak var BatT20IsSR: UILabel!
    @IBOutlet weak var BatT20Is100: UILabel!
    @IBOutlet weak var BatT20Is50: UILabel!
    @IBOutlet weak var BatT20Is4s: UILabel!
    @IBOutlet weak var BatT20Is6s: UILabel!
    @IBOutlet weak var BatT20IsCt: UILabel!
    @IBOutlet weak var BatT20IsSt: UILabel!
    
    @IBOutlet weak var BatFirstclassMat: UILabel!
    @IBOutlet weak var BatFirstclassInns: UILabel!
    @IBOutlet weak var BatFirstclassNO: UILabel!
    @IBOutlet weak var BatFirstclassRuns: UILabel!
    @IBOutlet weak var BatFirstclassHS: UILabel!
    @IBOutlet weak var BatFirstclassAve: UILabel!
    @IBOutlet weak var BatFirstclassBF: UILabel!
    @IBOutlet weak var BatFirstclassSR: UILabel!
    @IBOutlet weak var BatFirstclass100: UILabel!
    @IBOutlet weak var BatFirstclass50: UILabel!
    @IBOutlet weak var BatFirstclass4s: UILabel!
    @IBOutlet weak var BatFirstclass6s: UILabel!
    @IBOutlet weak var BatFirstclassCt: UILabel!
    @IBOutlet weak var BatFirstclassSt: UILabel!
    
    @IBOutlet weak var BatListAMat: UILabel!
    @IBOutlet weak var BatListAInns: UILabel!
    @IBOutlet weak var BatListANO: UILabel!
    @IBOutlet weak var BatListARuns: UILabel!
    @IBOutlet weak var BatListAHS: UILabel!
    @IBOutlet weak var BatListAAve: UILabel!
    @IBOutlet weak var BatListABF: UILabel!
    @IBOutlet weak var BatListASR: UILabel!
    @IBOutlet weak var BatListA100: UILabel!
    @IBOutlet weak var BatListA50: UILabel!
    @IBOutlet weak var BatListA4s: UILabel!
    @IBOutlet weak var BatListA6s: UILabel!
    @IBOutlet weak var BatListACt: UILabel!
    @IBOutlet weak var BatListASt: UILabel!
    
    @IBOutlet weak var BatT20sMat: UILabel!
    @IBOutlet weak var BatT20sInns: UILabel!
    @IBOutlet weak var BatT20sNO: UILabel!
    @IBOutlet weak var BatT20sRuns: UILabel!
    @IBOutlet weak var BatT20sHS: UILabel!
    @IBOutlet weak var BatT20sAve: UILabel!
    @IBOutlet weak var BatT20sBF: UILabel!
    @IBOutlet weak var BatT20sSR: UILabel!
    @IBOutlet weak var BatT20s100: UILabel!
    @IBOutlet weak var BatT20s50: UILabel!
    @IBOutlet weak var BatT20s4s: UILabel!
    @IBOutlet weak var BatT20s6s: UILabel!
    @IBOutlet weak var BatT20sCt: UILabel!
    @IBOutlet weak var BatT20sSt: UILabel!
    
    //bowling
    @IBOutlet weak var BowlTestsMat: UILabel!
    @IBOutlet weak var BowlTestsInns: UILabel!
    @IBOutlet weak var BowlTestsBalls: UILabel!
    @IBOutlet weak var BowlTestsRuns: UILabel!
    @IBOutlet weak var BowlTestsWkts: UILabel!
    @IBOutlet weak var BowlTestsAve: UILabel!
    @IBOutlet weak var BowlTestsBBI: UILabel!
    @IBOutlet weak var BowlTestsSR: UILabel!
    @IBOutlet weak var BowlTestsBBM: UILabel!
    @IBOutlet weak var BowlTestsEcon: UILabel!
    @IBOutlet weak var BowlTests4w: UILabel!
    @IBOutlet weak var BowlTests5w: UILabel!
    @IBOutlet weak var BowlTests10w: UILabel!
    
    @IBOutlet weak var BowlODIsMat: UILabel!
    @IBOutlet weak var BowlODIsInns: UILabel!
    @IBOutlet weak var BowlODIsBalls: UILabel!
    @IBOutlet weak var BowlODIsRuns: UILabel!
    @IBOutlet weak var BowlODIsWkts: UILabel!
    @IBOutlet weak var BowlODIsAve: UILabel!
    @IBOutlet weak var BowlODIsBBI: UILabel!
    @IBOutlet weak var BowlODIsSR: UILabel!
    @IBOutlet weak var BowlODIsBBM: UILabel!
    @IBOutlet weak var BowlODIsEcon: UILabel!
    @IBOutlet weak var BowlODIs4w: UILabel!
    @IBOutlet weak var BowlODIs5w: UILabel!
    @IBOutlet weak var BowlODIs10w: UILabel!

    @IBOutlet weak var BowlT20IsMat: UILabel!
    @IBOutlet weak var BowlT20IsInns: UILabel!
    @IBOutlet weak var BowlT20IsBalls: UILabel!
    @IBOutlet weak var BowlT20IsRuns: UILabel!
    @IBOutlet weak var BowlT20IsWkts: UILabel!
    @IBOutlet weak var BowlT20IsAve: UILabel!
    @IBOutlet weak var BowlT20IsBBI: UILabel!
    @IBOutlet weak var BowlT20IsSR: UILabel!
    @IBOutlet weak var BowlT20IsBBM: UILabel!
    @IBOutlet weak var BowlT20IsEcon: UILabel!
    @IBOutlet weak var BowlT20Is4w: UILabel!
    @IBOutlet weak var BowlT20Is5w: UILabel!
    @IBOutlet weak var BowlT20Is10w: UILabel!
    
    @IBOutlet weak var BowlFirstclassMat: UILabel!
    @IBOutlet weak var BowlFirstclassInns: UILabel!
    @IBOutlet weak var BowlFirstclassBalls: UILabel!
    @IBOutlet weak var BowlFirstclassRuns: UILabel!
    @IBOutlet weak var BowlFirstclassWkts: UILabel!
    @IBOutlet weak var BowlFirstclassAve: UILabel!
    @IBOutlet weak var BowlFirstclassBBI: UILabel!
    @IBOutlet weak var BowlFirstclassSR: UILabel!
    @IBOutlet weak var BowlFirstclassBBM: UILabel!
    @IBOutlet weak var BowlFirstclassEcon: UILabel!
    @IBOutlet weak var BowlFirstclass4w: UILabel!
    @IBOutlet weak var BowlFirstclass5w: UILabel!
    @IBOutlet weak var BowlFirstclass10w: UILabel!
    
    @IBOutlet weak var BowlListAMat: UILabel!
    @IBOutlet weak var BowlListAInns: UILabel!
    @IBOutlet weak var BowlListABalls: UILabel!
    @IBOutlet weak var BowlListARuns: UILabel!
    @IBOutlet weak var BowlListAWkts: UILabel!
    @IBOutlet weak var BowlListAAve: UILabel!
    @IBOutlet weak var BowlListABBI: UILabel!
    @IBOutlet weak var BowlListASR: UILabel!
    @IBOutlet weak var BowlListABBM: UILabel!
    @IBOutlet weak var BowlListAEcon: UILabel!
    @IBOutlet weak var BowlListA4w: UILabel!
    @IBOutlet weak var BowlListA5w: UILabel!
    @IBOutlet weak var BowlListA10w: UILabel!
    
    @IBOutlet weak var BowlT20sMat: UILabel!
    @IBOutlet weak var BowlT20sInns: UILabel!
    @IBOutlet weak var BowlT20sBalls: UILabel!
    @IBOutlet weak var BowlT20sRuns: UILabel!
    @IBOutlet weak var BowlT20sWkts: UILabel!
    @IBOutlet weak var BowlT20sAve: UILabel!
    @IBOutlet weak var BowlT20sBBI: UILabel!
    @IBOutlet weak var BowlT20sSR: UILabel!
    @IBOutlet weak var BowlT20sBBM: UILabel!
    @IBOutlet weak var BowlT20sEcon: UILabel!
    @IBOutlet weak var BowlT20s4w: UILabel!
    @IBOutlet weak var BowlT20s5w: UILabel!
    @IBOutlet weak var BowlT20s10w: UILabel!

    //career
    @IBOutlet weak var TestDebut: UILabel!
    @IBOutlet weak var LastTest: UILabel!
    @IBOutlet weak var ODIDebut: UILabel!
    @IBOutlet weak var LastODI: UILabel!
    @IBOutlet weak var T20IDebut: UILabel!
    @IBOutlet weak var LastT20I: UILabel!
    @IBOutlet weak var FirstclassDebut: UILabel!
    @IBOutlet weak var LastFirstclass: UILabel!
    @IBOutlet weak var ListADebut: UILabel!
    @IBOutlet weak var LastListA: UILabel!
    @IBOutlet weak var T20sDebut: UILabel!
    @IBOutlet weak var LastT20s: UILabel!
    
    @IBOutlet weak var careerTestView: UIView!
    @IBOutlet weak var careerODIView: UIView!
    @IBOutlet weak var careerT20IView: UIView!
    @IBOutlet weak var careerFirstclassView: UIView!
    @IBOutlet weak var careerListA: UIView!
    @IBOutlet weak var careerT20sView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAds()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
    }
    
    func loadBannerAds() {
        if showAds == "1" {
            self.bannerViewHeightConstraint.constant = 50
            bannerView.adUnitID = adUnitId
            bannerView.rootViewController = self
            bannerView.loadRequest(GADRequest())
        }
        else {
            self.bannerViewHeightConstraint.constant = 0
        }
    }

    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        topBarView.backgroundColor = currentTheme.topColor
        currentTheme.boxColor
        self.view.backgroundColor = currentTheme.topColor
    }
    
    
    
    

}
