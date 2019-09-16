//
//  ViewController.swift
//  SendMail
//
//  Created by Uran on 2017/11/13.
//  Copyright © 2017年 Uran. All rights reserved.
//

import UIKit
import MessageUI
class ViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sendMailBtn(_ sender: Any) {
        sendMail()
    }
    @IBAction func shareOther(_ sender: Any) {
        let shardItems : [Any] = ["Hello World"] as [Any]
        let activityVc = UIActivityViewController(activityItems: shardItems, applicationActivities: nil)
        activityVc.popoverPresentationController?.sourceView = self.view
        self.present(activityVc, animated: true, completion: nil)
    }
    func sendMail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        //更換email
        mailComposerVC.setToRecipients(["xxxx@gmail.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController.init(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(cancel)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error  {
            NSLog("Can't finish send error:\(error)")
            return
        }
        controller.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

