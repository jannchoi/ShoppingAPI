//
//  UIViewController+.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/6/25.
//

import UIKit

extension UIViewController  {
    func showAlert(text: String, button: String?,  action: (() -> Void)? = nil) {
    
        let alert = UIAlertController(title: "알림", message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default)
        if let action {
            let button = UIAlertAction(title: button ?? "버튼", style: .default) { _ in
                action()
            }
            alert.addAction(button)
            
        }
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
