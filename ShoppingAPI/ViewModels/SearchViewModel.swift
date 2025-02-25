//
//  SearchViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/6/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {

    let disposeBag = DisposeBag()
    struct Input {
        let searchedWord : Observable<ControlProperty<String>.Element>
    }
    struct Output {
        let searchButtonTapped: Driver<String>
        let alertTrigger : Driver<String>
    }
    func transform(input: Input) -> Output {
        let alertTrigger = PublishSubject<String>()
        let searchedWord = PublishSubject<String>()
        input.searchedWord.bind(with: self) { owner, value in
            if value.count <= 2{
                alertTrigger.onNext("두 글자 이상을 입력하세요.")
            } else {
                searchedWord.onNext(value)
            }
        }.disposed(by: disposeBag)
        return Output(searchButtonTapped: searchedWord.asDriver(onErrorJustReturn: "None"), alertTrigger: alertTrigger.asDriver(onErrorJustReturn: "error"))
    }

    
}
