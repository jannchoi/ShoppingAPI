//
//  Product.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/4/25.
//

import Foundation
import RealmSwift

final class Product: Object {
    @Persisted(primaryKey: true) var productId : String
    @Persisted(indexed: true) var title : String
    @Persisted var image: String
    @Persisted var lprice : String
    @Persisted var mallName : String
    
    convenience init(productId: String, title: String, image: String, lprice: String, mallName: String) {
        self.init()
        self.productId = productId
        self.title = title
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
    }
    convenience init(item: itemDetail) {
        self.init()
        self.productId = item.productId
        self.title = item.title
        self.image = item.image
        self.lprice = item.lprice
        self.mallName = item.mallName
    }
    
}

