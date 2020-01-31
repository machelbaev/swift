//
//  PlaceholderTextView.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    var placeholderLabel = UILabel()
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func setPlaceholder(_ fontSize: CGFloat, _ placeholder: String) {
        delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        font = UIFont.systemFont(ofSize: fontSize)
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 16 / 2)
        placeholderLabel.textColor = UIColor(red: 195 / 255, green: 195 / 255, blue: 197 / 255, alpha: 1)
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // limit text input with 500 characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > textView.text.count {
            return false
        }
        let newLength = textView.text.count + text.count - range.length
        
        if newLength > 500 {
            UIView.animate(withDuration: 1) {
                textView.backgroundColor = UIColor(named: "red")
                textView.backgroundColor = .clear
            }
        }
        
        return newLength <= 500
    }
}
