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
        let likeButtonTapped : Observable<(LikeButton, String)>
        let recentText: ControlProperty<String>
        let keyboardDismiss: ControlEvent<Void>
    }
    struct Output {
        let favoriteData : Observable<[Product]>
        let toastTrigger : Driver<(Bool, String)>
        let keyboardDismiss: Driver<Void>
    }
    func transform(input: Input) -> Output {
        let itemData = favoriteItem
        let toastTrigger = PublishSubject<(Bool, String)>()
        input.likeButtonTapped.bind(with: self, onNext: { owner, value in
            value.0.isSelected.toggle()
            value.0.toggleDesign()
            toastTrigger.onNext((value.0.isSelected, value.1.replaceText()))
            itemData.onNext(owner.realm.objects(Product.self))
        }).disposed(by: disposeBag)
        
        
        
        input.recentText.bind(with: self) { owner, text in
            if text.isEmpty {
                itemData.onNext(owner.list)
            } else {
                let query1 = NSPredicate(format: "title CONTAINS[c] %@", text)
                let query2 = NSPredicate(format: "mallName CONTAINS[c] %@", text)
                let query = NSCompoundPredicate(type: .or, subpredicates: [query1, query2])
                let filteredList = owner.list.filter(query)
                itemData.onNext(filteredList)
            }
        }.disposed(by: disposeBag)
        
        return Output(favoriteData: itemData.map{Array($0)},toastTrigger: toastTrigger.asDriver(onErrorJustReturn: (false, "")), keyboardDismiss: input.keyboardDismiss.asDriver())
    }
    
}
