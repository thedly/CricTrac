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

class ForgotPasswordViewController: UIViewController,ThemeChangeable {

    @IBOutlet weak var resetLinkEmailTxt: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    func changeThemeSettigs() {
        let currentTheme = cricTracTheme.currentTheme
        self.view.backgroundColor = currentTheme.topColor
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
       // KRProgressHUD.show(progressHUDStyle: .White, message: "Loading...")
        let email = resetLinkEmailTxt.textVal
        
        
        FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
            
          //  KRProgressHUD.dismiss()
            
            if error != nil {
//                SCLAlertView().showError("Error", subTitle: "Email was not sent")
                let alert = UIAlertController(title: "Error", message: "Invalid Details", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                
              // self.dismissViewControllerAnimated(true, completion: {void in
               // SCLAlertView().showInfo("Verify email", subTitle: "A reset password link has been sent to your mail account")
              let alert = UIAlertController(title: "Verify email", message: "A reset password link has been sent to your mail account", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                     self.dismissViewControllerAnimated(true, completion: nil)
                    }))
              self.presentViewController(alert, animated: true, completion: nil)
              //  })
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
