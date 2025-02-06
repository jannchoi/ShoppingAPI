//
//  UIButton+Extension.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import UIKit
extension UIButton {
    func titleDesign(title: String, size: CGFloat,weight: UIFont.Weight = .regular,  color: CGColor = UIColor.black.cgColor) {
        setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: size, weight: weight), NSAttributedString.Key.foregroundColor : color]), for: .normal)
    }
}
