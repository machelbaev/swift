//
//  MainTabBarController.swift
//  Showcase
//
//  Created by Mikhail on 14.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
        
    func setupViewControllers(){
        
        let trackViewController = TrackViewController()
        trackViewController.tabBarItem.image = #imageLiteral(resourceName: "track")
        trackViewController.tabBarItem.title = "Track"

        let sliderViewController = SliderViewController()
        sliderViewController.tabBarItem.image = #imageLiteral(resourceName: "slider")
        sliderViewController.tabBarItem.title = "Slider"

        let actionViewController = ActionViewController()
        actionViewController.tabBarItem.image = #imageLiteral(resourceName: "alert")
        actionViewController.tabBarItem.title = "Action"

        viewControllers = [
            trackViewController,
            sliderViewController,
            actionViewController
        ]

        tabBar.tintColor = .black
    }
    

}
