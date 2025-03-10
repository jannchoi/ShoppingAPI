//
//  Shop.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import Foundation

struct Shop: Decodable {
    var total : Int
    var items : [itemDetail]
    
}
struct itemDetail: Decodable {
    let title : String
    let link : String
    let image: String
    let lprice : String
    let mallName : String
    let productId : String
}
