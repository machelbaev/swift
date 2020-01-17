//
//  MessageViewController.swift
//  ShowMe
//
//  Created by Mikhail on 14.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    var messageData: String?
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.text = messageData
    }

}
