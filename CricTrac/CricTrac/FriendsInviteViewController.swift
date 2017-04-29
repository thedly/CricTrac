//
//  FriendsInviteViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 15/08/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//


import UIKit
import XLPagerTabStrip
import MessageUI

class FriendsInviteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IndicatorInfoProvider,ThemeChangeable,MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    
    var friendInviteDataArray = friendInviteData
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewWillAppear(animated: Bool) {
        setBackgroundColor()
        
    }

  
  override func viewDidLoad() {
        super.viewDidLoad()
      
        setBackgroundColor()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "INVITE")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendInviteDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCellWithIdentifier("SliderMenuViewCell", forIndexPath: indexPath) as? SliderMenuViewCell {
            let itemTitle = friendInviteDataArray[indexPath.row]["title"]
            let menuIcon = UIImage(named: friendInviteDataArray[indexPath.row]["img"]!)
            cell.menuName.text = itemTitle
            cell.menuIcon.frame.size.width = 20
            cell.menuIcon.frame.size.height = 20
            cell.menuIcon.contentMode = UIViewContentMode.ScaleAspectFit;
            cell.menuIcon.image = menuIcon
            return cell
        }
        return SliderMenuViewCell()
     }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       let itemTitle = friendInviteDataArray[indexPath.row]["title"]
        if itemTitle == "WHATSAPP" {
            openWhatsApp()
        }
        else if itemTitle == "MESSAGE" {
            openMessageApp()
        }
        else if itemTitle == "MAIL" {
            openMailApp()
        }
        else if itemTitle == "FACEBOOK" {
            openFaceBookApp()
        }
    }
    
    
    func openWhatsApp(){
        let message = "Install CricTrac from the Store"
        let urlStringEncoded = message.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        
        let whatsappURL:NSURL? = NSURL(string:"whatsapp://send?text=\(urlStringEncoded!)")
        if (UIApplication.sharedApplication().canOpenURL(whatsappURL!)) {
            UIApplication.sharedApplication().openURL(whatsappURL!)
        }
        else {
            let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
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
        
        //mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Install CricTrac from the Store")
        mailComposerVC.setMessageBody("Install CricTrac from the Store", isHTML: false)
        
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
    
    
    func openMessageApp() {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Install CricTrac from the Store";
        //messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self;
        self.presentViewController(messageVC, animated: false, completion: nil)
 
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    func openFaceBookApp() {
        
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



