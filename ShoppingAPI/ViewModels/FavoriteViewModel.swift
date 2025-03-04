//
//  FavoriteViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/4/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class FavoriteViewModel {
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    lazy var list = realm.objects(Product.self)
    lazy var favoriteItem = BehaviorSubject(value: list)
    let errorMessageTrigger = PublishSubject<String>()
    
    struct Input {
        let likeButtonTapped : Observable<LikeButton>
    }
    struct Output {
        let favoriteData : Observable<[Product]>
    }
    func transform(input: Input) -> Output {
        input.likeButtonTapped.bind(with: self, onNext: { owner, value in
            value.isSelected.toggle()
            value.toggleDesign()

        }).disposed(by: disposeBag)
        
        return Output(favoriteData: favoriteItem.map{Array($0)})
    }
    
}
