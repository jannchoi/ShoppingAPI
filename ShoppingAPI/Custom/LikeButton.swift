//
//  LikeButton.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

final class LikeButton: UIButton {
    let realm = try! Realm()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var item: Product?
    
    init(item: Product) {
        self.item = item
        super.init(frame: .zero)
        tintColor = .red
        self.prepareDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func toggleDesign() {
        guard let item else {return}
        let isSaved = realm.objects(Product.self).contains(where: { $0.productId == item.productId
        })
        if isSelected {
            if !isSaved {
                do {
                    try realm.write {
                        let data = Product(productId: item.productId, title: item.title, image: item.image, lprice: item.lprice, mallName: item.mallName)
                        realm.add(data)
                    }
                } catch {
                    print("realm 저장 실패")
                }
            }
            setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            if isSaved {
                do {
                    try realm.write {
                        let target = realm.objects(Product.self).where { $0.productId == item.productId
                        }
                        realm.delete(target)
                    }
                } catch {
                    print("realm 데이터 삭제 실패")
                }
            }
            setImage((UIImage(systemName: "heart")), for: .normal)
        }
    }
    func prepareDesign() {
        guard let item else {return}
    if realm.objects(Product.self).contains(where: { $0.productId == item.productId
        })
        {
            isSelected = true
        }
        else {
            isSelected = false
        }
        toggleDesign()
    }

}
