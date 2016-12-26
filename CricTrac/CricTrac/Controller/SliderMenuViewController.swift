//
//  SliderMenuViewController.swift
//  CricTrac
//
//  Created by Renjith on 7/28/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import SCLAlertView

class SliderMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userName.text = currentUser?.displayName
        baseView.backgroundColor = UIColor().darkerColorForColor(UIColor(hex: topColor))
        
        getAllProfileData({ data in
            profileData = Profile(usrObj: data)
            
            if profileData.ProfileImageUrl == "" {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                if let token = userDefaults.valueForKey("loginToken") {
                    if token["Facebooktoken"] != nil || token["googletoken"] != nil{
                        let profileimage = getImageFromFacebook()
                        addProfileImageData(profileimage)
                    }
                }
            }
            
            getImageFromFirebase(profileData.ProfileImageUrl) { (imgData) in
                self.profileImage.image = imgData
            }

            
        })
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(sender: UIButton) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = userDefaults.valueForKey("loginToken"){
            
            userDefaults.removeObjectForKey("loginToken")
            
        }
        
        let window = UIWindow()
        
        let loginBaseViewController = viewControllerFrom("Main", vcid: "LoginViewController")
        
        window.rootViewController = loginBaseViewController
        self.presentViewController(loginBaseViewController, animated: true) {
             SCLAlertView().showInfo("Logout",subTitle: "Data saved is cleared, Kill the app and relaunch for now")
        }
    
        
       
        
    }

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SliderMenuViewCell", forIndexPath: indexPath) as! SliderMenuViewCell
        let itemTitle = menuData[indexPath.row]["title"]
        
        let menuIcon = UIImage(named: menuData[indexPath.row]["img"]!)
        
        cell.menuName.text = itemTitle
        cell.menuIcon.image = menuIcon
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var vcName = menuData[indexPath.row]["vc"]
        
        if menuData[indexPath.row]["title"] == "PROFILE" && profileData.fullName != " "{
            vcName = "ProfileReadOnlyViewController"
        }
        
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName!)
        sliderMenu.mainViewController.presentViewController(vc, animated: true, completion: nil)
        sliderMenu.setDrawerState(.Closed, animated: true)
    }

}
