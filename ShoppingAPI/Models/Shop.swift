//
//  Shop.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import Foundation

struct Shop: Decodable {
    let total : Int
    var items : [itemDetail]
    
}
struct itemDetail: Decodable {
    let title : String
    let image: String
    let lprice : String
    let mallName : String
}
