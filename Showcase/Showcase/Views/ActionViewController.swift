//
//  ActionViewController.swift
//  Showcase
//
//  Created by Mikhail on 14.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {
    
    let actionControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Alert", at: 0, animated: true)
        sc.insertSegment(withTitle: "Action", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    lazy var showMeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Me", for: .normal)
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 9/255.0, green: 95/255.0, blue: 134/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setUpElements()
    }
    
    fileprivate func setUpElements() {
        view.addSubview(actionControl)
        actionControl.translatesAutoresizingMaskIntoConstraints = false
        actionControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        actionControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(showMeButton)
        showMeButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 150, height: 40))
        showMeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showMeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func performAction() {
        if actionControl.selectedSegmentIndex == 0 {
            let controller = UIAlertController(title: "This is an alert", message: "You've created an alert view", preferredStyle: .alert)
            let okAction : UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert: UIAlertAction!) in
                controller.dismiss(animated: true, completion: nil)
            })

            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)

        } else {

            let controller : UIAlertController = UIAlertController(title: "This is an action sheet", message: "You've created an action sheet", preferredStyle: .actionSheet)
            let okAction : UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert: UIAlertAction!) in
                controller.dismiss(animated: true, completion: nil)
            })

            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            
        }
        
    }

}
