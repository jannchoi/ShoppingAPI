//
//  WishItem.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import Foundation
import RealmSwift

class WishItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var itemName: String
    @Persisted var date: Date
    
    @Persisted(originProperty: "detail")
    var folder: LinkingObjects<WishFolder>
    
    convenience init(itemName: String) {
        self.init()
        self.itemName = itemName
        self.date = Date()
    }
}

