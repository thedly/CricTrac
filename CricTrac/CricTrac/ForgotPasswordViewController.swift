//
//  ForgotPasswordViewController.swift
//  CricTrac
//
//  Created by Tejas Hedly on 20/10/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCLAlertView
import KRProgressHUD
import MessageUI

class ForgotPasswordViewController: UIViewController,ThemeChangeable,MFMailComposeViewControllerDelegate{

    @IBOutlet weak var resetLinkEmailTxt: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
        barView.backgroundColor = currentTheme.topColor
        setPlainShadow(barView, color: currentTheme.bottomColor.CGColor)
       // navigationController!.navigationBar.barTintColor = currentTheme.topColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUIBackgroundTheme(self.view)
        setBackgroundColor()
        // Do any additional setup after loading the view.
        forgotPasswordLabel.text = "RESET PASSWORD"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendResetPwdLinkBtnPressed(sender: AnyObject) {
        let email = resetLinkEmailTxt.textVal
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Invalid Details", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Verify email", message: "A reset password link has been sent to your mail account", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                     self.dismissViewControllerAnimated(true, completion: nil)
                    }))
              self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func contactUsButtonTapped(sender: AnyObject) {
        
        openMailApp()
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
        mailComposerVC.setSubject("Trouble signing in - iOS")
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
            //Thank you for contacting CricTrac. We will get back to you soon.
            let sendMailConfirmationAlert = UIAlertView(title: "", message: "Thank you for contacting CricTrac. We will get back to you soon.", delegate: self, cancelButtonTitle: "OK")
            sendMailConfirmationAlert.show()
        case MFMailComposeResultFailed:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
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
