//
//  NumberFormatter.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import Foundation

class NumberFormatter {
    static let formatter = NumberFormatter()
    private init() { }
    
    func StringIntFormat(value: String) -> String {
        let intValue = Int(value)
        let formatted = intValue?.formatted() ?? "0"
        let result = String(formatted)
        return result
    }
}
