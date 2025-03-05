//
//  WishFolderRepository.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import Foundation
import RealmSwift

protocol FolderRepository {
    func fetchAll() -> Results<WishFolder>
    func createItem(folderName: String)
}
final class WishFolderRepository: FolderRepository {
    private let realm = try! Realm()
    
    func fetchAll() -> Results<WishFolder> {
        return realm.objects(WishFolder.self)
    }
    func createItem(folderName: String) {
        do {
            try realm.write {
                let folder = WishFolder(name: folderName)
                realm.add(folder)
            }
        } catch {
            print("폴더 저장 실패")
        }
    }
    func getFolder(id: ObjectId) -> List<WishItem> {
        let folder = realm.objects(WishFolder.self).where {
            $0.id == id
        }.first!
        return folder.detail
    }
}
