//
//  SliderViewController.swift
//  Showcase
//
//  Created by Mikhail on 14.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    var redColor:CGFloat = 0.5
    var greenColor:CGFloat = 0.5
    var blueColor:CGFloat = 0.5
    
    lazy var redLabel: UILabel = getLabel(with: "Red")
    lazy var greenLabel: UILabel = getLabel(with: "Green")
    lazy var blueLabel: UILabel = getLabel(with: "Blue")
    
    lazy var redValue: UITextField = getTextField()
    lazy var greenValue: UITextField = getTextField()
    lazy var blueValue: UITextField = getTextField()
    
    lazy var redSlider: UISlider = {
        let slider = getSlider()
        slider.addTarget(self, action: #selector(changeRed), for: .valueChanged)
        return slider
    }()
    
    lazy var greenSlider: UISlider = {
        let slider = getSlider()
        slider.addTarget(self, action: #selector(changeGreen), for: .valueChanged)
        return slider
    }()
    
    lazy var blueSlider: UISlider = {
        let slider = getSlider()
        slider.addTarget(self, action: #selector(changeBlue), for: .valueChanged)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateColor()
        setUpElements()
    }
    
    fileprivate func setUpElements() {
        view.addSubview(redLabel)
        redLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        view.addSubview(redSlider)
        redSlider.anchor(top: redLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 20, bottom: 0, right: 0), size: .init(width: view.frame.width * 2 / 3, height: 35))
        
        view.addSubview(redValue)
        redValue.anchor(top: nil, leading: redSlider.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        redValue.centerYAnchor.constraint(equalTo: redSlider.centerYAnchor).isActive = true
        
        view.addSubview(greenLabel)
        greenLabel.anchor(top: redSlider.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        view.addSubview(greenSlider)
        greenSlider.anchor(top: greenLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 20, bottom: 0, right: 0), size: .init(width: view.frame.width * 2 / 3, height: 35))
        
        view.addSubview(greenValue)
        greenValue.anchor(top: nil, leading: greenSlider.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        greenValue.centerYAnchor.constraint(equalTo: greenSlider.centerYAnchor).isActive = true
        
        view.addSubview(blueLabel)
        blueLabel.anchor(top: greenSlider.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        
        view.addSubview(blueSlider)
        blueSlider.anchor(top: blueLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 20, bottom: 0, right: 0), size: .init(width: view.frame.width * 2 / 3, height: 35))
        
        view.addSubview(blueValue)
        blueValue.anchor(top: nil, leading: blueSlider.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        blueValue.centerYAnchor.constraint(equalTo: blueSlider.centerYAnchor).isActive = true
    }
    
    fileprivate func getLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    fileprivate func getTextField() -> UITextField {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.isUserInteractionEnabled = false // to not show up the keyboard
        //tf.backgroundColor = .white // if uncommend this line, text field will be look like in tutorial
        tf.text = "123"
        return tf
    }
    
    fileprivate func getSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.setValue(255 / 2, animated: true)
        return slider
    }
    
    @objc func changeRed() {
        redColor = CGFloat(redSlider.value / 255)
        redValue.text = String(format: "%.0f",Float(redColor*255.0))
        updateColor()
    }
    
    @objc func changeGreen() {
        greenColor = CGFloat(greenSlider.value / 255)
        greenValue.text = String(format: "%.0f",Float(greenColor*255.0))
        updateColor()
    }
    
    @objc func changeBlue() {
        blueColor = CGFloat(blueSlider.value / 255)
        blueValue.text = String(format: "%.0f",Float(blueColor*255.0))
        updateColor()
    }
    
    fileprivate func updateColor() {
        view.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
    }

}

extension TrackViewController: UITextFieldDelegate {
    
}
