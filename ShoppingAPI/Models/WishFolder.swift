//
//  WishFolder.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import Foundation
import RealmSwift

class WishFolder: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var detail: List<WishItem>
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.detail = detail
    }
}
