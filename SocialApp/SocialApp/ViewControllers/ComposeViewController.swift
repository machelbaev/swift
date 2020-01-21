//
//  ComposeViewController.swift
//  SocialApp
//
//  Created by Mikhail on 18.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var tweetContent: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissView(_ sender: AnyObject) { }
    
    @IBAction func postToTwitter(_ sender: AnyObject) { }
    
}
