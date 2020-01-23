//
//  ViewController.swift
//  BlurApp
//
//  Created by Mikhail on 22.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var blurEffectView: UIVisualEffectView?
    
    let imageSet: [UIImage] = [#imageLiteral(resourceName: "1280x720_cmsv2_ed60ad2d-acc5-564f-ae7d-e77e0f69b709-3190772"), #imageLiteral(resourceName: "tour_img-1096032-146"), #imageLiteral(resourceName: "5vu6hywf6jo"), #imageLiteral(resourceName: "vb34156199_1100")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(4))
        // Apply blurring effect
        backgroundImageView.image = imageSet[selectedImageIndex]

        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView!)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }

}

