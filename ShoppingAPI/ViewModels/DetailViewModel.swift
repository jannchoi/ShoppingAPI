//
//  DetailViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {
    private let disposeBag = DisposeBag()
    var selectedItem = itemDetail(title: "", image: "", lprice: "", mallName: "", productId: "")
    
    struct Input {
        let likeButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let likeButtonTapped: SharedSequence<DriverSharingStrategy, Void>
    }
    func trnasform(input: Input) -> Output {
        return Output(likeButtonTapped: input.likeButtonTapped.asDriver())
    }
}
