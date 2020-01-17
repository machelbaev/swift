//
//  ViewController.swift
//  InTouch
//
//  Created by Mikhail on 16.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sendEmail(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.setSubject("MySubject")
            mailVC.setToRecipients(["machelbaev@edu.hse.ru"])
            mailVC.setMessageBody("<p>Hello!</p>", isHTML: true)
            mailVC.mailComposeDelegate = self;

            self.present(mailVC, animated: true, completion: nil)

        } else {

            print("This device is currently unable to send email")

        }
    }

    @IBAction func sendText(_ sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            let smsVC : MFMessageComposeViewController = MFMessageComposeViewController()
            smsVC.messageComposeDelegate = self
            smsVC.recipients = ["1234500000"]
            smsVC.body = "Please call me back."

            self.present(smsVC, animated: true, completion: nil)
            
        } else {

            print("This device is currently unable to send text messages")

        }
    }

    @IBAction func openWebsite(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: "http://hse.ru")!, options: [:], completionHandler: nil)
    }

}


extension ViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case MessageComposeResult.sent:
            print("Result: Text Message Sent!")
        case MessageComposeResult.cancelled:
            print("Result: Text Message Cancelled.")
        case MessageComposeResult.failed:
            print("Result: Error, Unable to Send Text Message.")
        default:
            print("Something unpredictable")
        }
        self.dismiss(animated:true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        
        case MFMailComposeResult.sent:
            print("Result: Email Sent!")
        case MFMailComposeResult.cancelled:
            print("Result: Email Cancelled.")
        case MFMailComposeResult.failed:
            print("Result: Error, Unable to Send Email.")
        case MFMailComposeResult.saved:
            print("Result: Mail Saved as Draft.")
        default:
            print("Something unpredictable")
        }

        self.dismiss(animated: true, completion: nil)
    }
    
}

