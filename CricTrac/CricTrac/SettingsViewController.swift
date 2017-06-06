//
//  SettingsViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 01/01/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ThemeChangeable,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var SettingsTableView: UITableView!
    
    @IBAction func closeBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        SettingsTableView.reloadData()
        setNavigationBarProperties()
        //initializeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        setNavigationBarProperties()
        // Do any additional setup after loading the view.
       
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func setNavigationBarProperties(){
        var currentTheme:CTTheme!
        currentTheme = cricTracTheme.currentTheme
        
        let menuButton: UIButton = UIButton(type:.Custom)
        menuButton.setImage(UIImage(named: "menu-icon"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: #selector(didMenuButtonTapp), forControlEvents: UIControlEvents.TouchUpInside)
        menuButton.frame = CGRectMake(0, 0, 40, 40)
        let leftbarButton = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = leftbarButton
        navigationController!.navigationBar.barTintColor = currentTheme.topColor //UIColor(hex: topColor)
        title = "THIRD UMPIRE"
        self.view.backgroundColor = currentTheme.topColor
       // let titleDict: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
       // navigationController!.navigationBar.titleTextAttributes = titleDict
    }
    
    @IBAction func didMenuButtonTapp(sender: UIButton){
        sliderMenu.setDrawerState(.Opened, animated: true)
    }
    
    func initializeView() {
        SettingsTableView.registerNib(UINib.init(nibName:"SettingsViewCell", bundle: nil), forCellReuseIdentifier: "SettingsViewCell")
        SettingsTableView.separatorStyle = .SingleLine
        SettingsTableView.dataSource = self
        SettingsTableView.delegate = self
        
        setBackgroundColor()
        //setUIBackgroundTheme(self.view)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMenuData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsViewCell", forIndexPath: indexPath) as! SettingsViewCell
        let itemTitle = settingsMenuData[indexPath.row]["title"] as! String
        let menuIcon = UIImage(named: settingsMenuData[indexPath.row]["img"]! as! String)
        let menuDesc = settingsMenuData[indexPath.row]["desc"] as! String
        var selectedValue = String()
        
        if settingsMenuData[indexPath.row]["vc"] == "ThemeSettingsViewController" {
            selectedValue = CurrentTheme
        }
        
        let toggleConfig = settingsMenuData[indexPath.row]["IsSwitchVisible"] as! Bool
        
        cell.backgroundColor = UIColor.clearColor()
        cell.menuItemName.text = itemTitle
        cell.menuItemIcon.image = menuIcon
        cell.menuItemSelectedValue.text = selectedValue
        
      //  cell.menuItemToggleSwitch.hidden = !toggleConfig
        cell.menuItemSelectedValue.hidden = toggleConfig
        cell.menuItemDescription.text = menuDesc
        
        if settingsMenuData[indexPath.row]["vc"] == "Version" {
            let formattedString = NSMutableAttributedString()
            formattedString.bold(itemTitle, fontName: appFont_black, fontSize: 15)
            formattedString.bold(": ", fontName: appFont_black, fontSize: 15)
            formattedString.normal(versionAndBuildNumber, fontName: appFont_black, fontSize: 15)
            cell.menuItemName.attributedText = formattedString
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vcName = settingsMenuData[indexPath.row]["vc"]
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if vcName == "ThemeSettingsViewController" {
            let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName! as! String)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if vcName == "ChangePassword" {
            let forgotPwdVC = viewControllerFrom("Main", vcid: "ForgotPasswordViewController") as! ForgotPasswordViewController
            self.presentViewController(forgotPwdVC, animated: true, completion: nil)
        }
        else if vcName == "MasterDataViewController" {
            let vc = storyboard.instantiateViewControllerWithIdentifier(vcName as! String)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if vcName == "Feedback" {
            openMailApp()
        }
        else if vcName == "StaticPageViewController" {
            let viewCtrl = storyboard.instantiateViewControllerWithIdentifier(vcName! as! String) as! StaticPageViewController
            viewCtrl.pageToLoad = settingsMenuData[indexPath.row]["contentToDisplay"] as! String + "?color=\(topColor)"
            viewCtrl.pageHeaderText = (settingsMenuData[indexPath.row]["title"] as! String).uppercaseString
            presentViewController(viewCtrl, animated: true, completion: nil)
        }
//        else if vcName == "About" {
//            let aboutVC = viewControllerFrom("Main",vcid:"AboutViewController") as! AboutViewController
//            self.presentViewController(aboutVC, animated: true, completion: nil)
//        }
        else if vcName == "Logout" {
            let alert = UIAlertController(title:"", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                 logout(self)
            }))
             alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            let vc  = storyboard.instantiateViewControllerWithIdentifier(vcName! as! String)
             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func openMailApp() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([feedbackEmail])
        mailComposerVC.setSubject("Let us know your feedback on CricTrac")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
        case MFMailComposeResultCancelled:
            print("Mail cancelled")
        case MFMailComposeResultSaved:
            print("Mail saved")
        case MFMailComposeResultSent:
            print("Mail sent")
        case MFMailComposeResultFailed:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }


}
