//
//  SearchResultViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/6/25.
//
import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class SearchResultViewModel {
    
    var total = 0
    private var inputSort = BehaviorRelay(value: "sim")
    private var page = 1
    private var isEnd = false
    
    var query = "dog"
    let disposeBag = DisposeBag()
    let shopData = BehaviorSubject(value: Shop(total: 0, items: []))
    let errorMessageTrigger = PublishSubject<String>()
    
    struct Input {
        let tappedButton : Observable<Int>
        let prefetchItems : ControlEvent<[IndexPath]>
        let itemSelected : ControlEvent<itemDetail>
        let likeButtonTapped : Observable<LikeButton>
    }
    struct Output {
        let shopData : Observable<Shop>
        
        let query: String
        let selecteButtonIdx : Driver<Int>
        let errorMessageTrigger : Driver<String>
        let itemselected : SharedSequence<DriverSharingStrategy, itemDetail>
        let toastTrigger : Driver<(Bool, String)>
    }
    func transform(input: Input) -> Output {
        getItemList()
        let selectedButtonIdx = PublishRelay<Int>()
        let toastTrigger = PublishSubject<(Bool, String)>()
        input.likeButtonTapped.bind(with: self, onNext: { owner, value in
            value.isSelected.toggle()
            value.toggleDesign()
            toastTrigger.onNext((value.isSelected, value.item?.title.replaceText() ?? ""))
        }).disposed(by: disposeBag)
        
        
        input.tappedButton.bind(with: self, onNext: { owner, value in
            selectedButtonIdx.accept(value)
            owner.changeOrder(selectedTag: value)
        }).disposed(by: disposeBag)
        
        inputSort.bind(with: self) { owner, sortType in
            owner.getItemList()
        }.disposed(by: disposeBag)

        input.prefetchItems
            .bind(with: self) { owner, indexPaths in
                guard let myData = try? owner.shopData.value() else {return}
                for idx in indexPaths {
                    if myData.items.count - 16 <= idx.item && owner.isEnd == false {
                        owner.page += 1
                        owner.getItemList()
                    }
                }
            }.disposed(by: disposeBag)

        
        return Output(shopData: shopData, query: query, selecteButtonIdx: selectedButtonIdx.asDriver(onErrorJustReturn: 0), errorMessageTrigger: errorMessageTrigger.asDriver(onErrorJustReturn: "unKnown Error"), itemselected: input.itemSelected.asDriver(), toastTrigger: toastTrigger.asDriver(onErrorJustReturn: (false, "")))
    }

 
    private func getItemList() {
        let sort = inputSort.value
        let target = Observable.just(query)
        target
            .flatMap{ query in
                NetworkManager.shared.callRequest(query: query, sort: sort, page: 1)
                    .catch { [weak self] error in
                        if let error = error as? NetworkError {
                            self?.errorMessageTrigger.onNext(error.errorMessage)
                        }
                        return Observable.just(Shop(total: 0, items: []))
                    }
            }
            .subscribe(with: self) { owner, value in
                guard var beforeData = try? owner.shopData.value() else {return}
                if owner.page * 100 > value.total {
                    owner.isEnd = true
                    return
                }
                if owner.page == 1 {
                    beforeData.total = value.total
                    beforeData.items = value.items

                } else {
                    beforeData.items.append(contentsOf: value.items)
                }

                owner.shopData.onNext(beforeData)
            } onError: { _, error in
                print("onError", error)
            } onCompleted: { _ in
                print("onCompleted")
            } onDisposed: { _ in
                print("Ondisposed")
            }.disposed(by: disposeBag)
        
    }
    private func changeOrder(selectedTag: Int) {
        
        let type = ButtonTag(rawValue: selectedTag)
            switch type {
            case .simOrder:
                inputSort.accept("sim")
            case .dateOrder:
                inputSort.accept("date")
            case .ascOrder:
                inputSort.accept("asc")
            case .dscOrder:
                inputSort.accept("dsc")
            case .none:
                return
            }
            self.page = 1
    }
}
