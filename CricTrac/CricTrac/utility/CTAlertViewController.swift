//
//  CTAlertViewController.swift
//  CricTrac
//
//  Created by Renjith on 8/31/16.
//  Copyright © 2016 CricTrac. All rights reserved.
//

import UIKit

class CTAlertViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var textLabel:UILabel!
    
    var message:String = ""
    weak var delegate:CTAlertDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = message
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(){
        
        dismissViewControllerAnimated(true) {}
        delegate?.cancelClicked()
    }
    
    @IBAction func ok(){
        dismissViewControllerAnimated(true) {}
        delegate?.okClicked()
    }

}



extension CTAlertDelegate where Self:UIViewController {
    
    func showCTAlert(message:String){
        
        let detailsVC = viewControllerFrom("Main", vcid: "CTAlertViewController") as! CTAlertViewController
        detailsVC.message = message
        detailsVC.delegate = self
        detailsVC.modalPresentationStyle = .OverCurrentContext
        presentViewController(detailsVC, animated: true) {}
        
    }
    
    func showCTAlertWithCancel(){
        
    }
}

protocol CTAlertDelegate:class {
    func cancelClicked()
    func okClicked()
}
