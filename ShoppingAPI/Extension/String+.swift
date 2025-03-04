//
//  String+.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/4/25.
//

import Foundation

extension String {
    func replaceText() -> String {
        var result = self.replacingOccurrences(of: "<b>", with: "")
        result = result.replacingOccurrences(of: "</b>", with: "")
        return result
    }
}
