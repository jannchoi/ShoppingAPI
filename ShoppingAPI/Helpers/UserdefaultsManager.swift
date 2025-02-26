//
//  UserdefaultsManager.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import Foundation

@propertyWrapper struct MyDefaults<T> {
    
    let key: String
    let empty: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case like
    }
    
    @MyDefaults(key: Key.like.rawValue, empty: [String]())
    static var like
}
