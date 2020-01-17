//
//  ViewController.swift
//  ShowMe
//
//  Created by Mikhail on 14.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textToSendField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showMe(sender: AnyObject) {
        NSLog("User Wrote: %@", textToSendField.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let messageController = segue.destination as! MessageViewController
        messageController.messageData = textToSendField.text
    }

}

