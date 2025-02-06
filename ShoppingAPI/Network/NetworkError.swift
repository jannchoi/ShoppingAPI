//
//  NetworkError.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/6/25.
//

import Foundation

enum NetworkError: Error {
    case badRequest //400
    case unauthorized //403
    case notFound //404
    case systemError //500
    
    var errorMessage : String {
        switch self {
        case .badRequest : return "The request was unacceptable"
        case .unauthorized : return "Invalid Access Token"
        case .notFound : return "The requested resource doesn’t exist"
        case .systemError : return "System Error"
        }
    }
}
