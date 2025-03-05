//
//  WishFolderViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift



final class WishFolderViewModel {
    let disposeBag = DisposeBag()
    let repository = WishFolderRepository()
    var internalData : InternalData
    var isInitial : Bool
    
    struct InternalData {
        let folderList : BehaviorSubject<Results<WishFolder>>
    }
    
    init() {
        internalData = InternalData(folderList: BehaviorSubject(value: repository.fetchAll()))
        self.isInitial = repository.fetchAll().isEmpty
    }
    
    struct Input {

    }
    struct Output {
        let folderList : Observable<[WishFolder]>
    }

    
    func transform(input: Input) -> Output {
        if isInitial {
            initialFolderData()
        }
        let folderList = internalData.folderList.map{Array($0)}
        return Output(folderList: folderList)
    }
    private func initialFolderData() {
        repository.createItem(folderName: "옷")
        repository.createItem(folderName: "학용품")
        repository.createItem(folderName: "전자기기")
        repository.createItem(folderName: "음식")
    }
}
