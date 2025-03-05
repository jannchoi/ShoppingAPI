//
//  WishFolderDetailViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class WishFolderDetailViewModel {
    private(set) var internalData : InternalData
    let disposeBag = DisposeBag()
    let itemRepository = WishItemsRepository()
    let folderRepository = WishFolderRepository()
    lazy var itemList = internalData.targetFolder.detail
    
    init(targetFolder: WishFolder) {
        internalData = InternalData(targetFolder: targetFolder)
    }
    
    struct Input {
        let recentText : Observable<ControlProperty<String>.Element>
    }
    struct Output {
        let itemList : BehaviorSubject<List<WishItem>>
    }
    struct InternalData {
        let targetFolder : WishFolder

    }
    
    func transform(input: Input) -> Output{
        //repository.getFileURL()
        let itemList = BehaviorSubject(value: itemList)
        input.recentText
            .map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .filter{!$0.isEmpty}
            .bind(with: self) { owner, text in
                owner.itemRepository.createItemInFolder(folderId: owner.internalData.targetFolder.id, itemName: text)
                itemList.onNext(owner.folderRepository.getFolder(id: owner.internalData.targetFolder.id))
            }.disposed(by: disposeBag)
        
        return Output(itemList: itemList)
    }
}
