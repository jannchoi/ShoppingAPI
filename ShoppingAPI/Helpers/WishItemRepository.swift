//
//  WishItemRepository.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import Foundation
import RealmSwift

protocol WishItemRepository {
    func getFileURL()
    func fetchAll() -> Results<WishItem>
    func createItem(itemName: String)
    func deleteItem(data: WishItem)
    func createItemInFolder(folderId: ObjectId, itemName: String)
}
final class WishItemsRepository:WishItemRepository {
    private let realm = try! Realm()
    func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    func fetchAll() -> RealmSwift.Results<WishItem> {
        return realm.objects(WishItem.self)
    }
    
    func createItem(itemName: String) {
        do {
            try realm.write {
                let data = WishItem(itemName: itemName)
                realm.add(data)
                print("wishItem 저장 완료")
            }
        } catch {
            print("wishItem 저장 실패")
        }
    }
    
    func deleteItem(data: WishItem) {
        do {
            try realm.write {
                realm.delete(data)
                print("wishItem 삭제 완료")
            }
        } catch {
            print("wishItem 삭제 실패")
        }
    }
    
    func createItemInFolder(folderId: RealmSwift.ObjectId, itemName: String) {
        do {
            try realm.write {
                let folder = realm.objects(WishFolder.self).where {
                    $0.id == folderId
                }.first!
                folder.detail.append(WishItem(itemName: itemName))
                print("wishItem 저장 완료")
            }
        } catch {
            print("wishItem 저장 실패")
        }
    }
    
    
}
