//
//  StyleGuide.swift
//  WhosHungry
//
//  Created by Kelsey Sparkman on 6/22/20.
//  Copyright © 2020 Kelsey Sparkman. All rights reserved.
//

import UIKit

extension UIView {
    
    func addCornerRadius(_ radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = UIColor.gray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func rotate(by radians: CGFloat = (-CGFloat.pi/2)) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

struct StyleConstants {
    static func setLabelBlackBorderStyle(label: UILabel) {
        label.layer.cornerRadius = 10
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
    }
    
    static func setLabelWhiteBorderStyle(label: UILabel) {
        label.layer.cornerRadius = 10
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
    }
    
    static func setButtonStyle(button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
    }
    
    static func setTextFieldStyle(textField: UITextField) {
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
    }
    
    static func setRadiusSliderStyle(slider: UISlider) {
        slider.layer.cornerRadius = 10
        slider.layer.borderColor = UIColor.white.cgColor
        slider.layer.borderWidth = 1
        slider.layer.masksToBounds = true
    }
}
