//
//  ViewController.swift
//  LocalizeMe
//
//  Created by Mikhail on 30.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var localeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var fifth: UILabel!
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var four: UILabel!
    @IBOutlet weak var five: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        let locale = NSLocale.autoupdatingCurrent
        let code = locale.languageCode!
        let language = locale.localizedString(forLanguageCode: code)!
        localeLabel.text = language

        one.text = NSLocalizedString("One", comment: "The number 1")
        two.text = NSLocalizedString("Two", comment: "The number 2")
        three.text = NSLocalizedString("Three", comment: "The number 3")
        four.text = NSLocalizedString("Four", comment: "The number 4")
        five.text = NSLocalizedString("Five", comment: "The number 5")
        
        let flagFile = NSLocalizedString("flag_usa", comment: "Name of the flag")
        flagImageView.image = UIImage(named: flagFile)
    }


}

