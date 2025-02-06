//
//  SearchResultViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/6/25.
//

import Foundation

class SearchResultViewModel {
    
    var inputLoadDataTrigger: Observable<Void?> = Observable(nil)
    var inputButtonTapped: Observable<Int?> = Observable(nil)
    var inputPrefetchingTrigger: Observable<Int?> = Observable(nil)

    var outputSearchedTerm: Observable<String?> = Observable(nil)
    var outputItem: Observable<[itemDetail]> = Observable([])
    var outputErrorMessage: Observable<String?> = Observable("")
    var total = 0
    private var inputSort = "sim"
    private var page = 1
    private var isEnd = false
    
    init() {
        print("SearchResultViewModel init")
        
        inputLoadDataTrigger.lazyBind { _ in
            self.loadData()
        }
        
        inputButtonTapped.lazyBind { _ in
            self.changeOrder()
        }
        inputPrefetchingTrigger.lazyBind { _ in
            self.isprefetchItem()
        }
    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
    
    private func isprefetchItem() {
        guard let idx = self.inputPrefetchingTrigger.value else {return}
        if self.outputItem.value.count - 16 <= idx && self.isEnd == false {
            page += 1
            loadData()
        }
    }
    
    private func loadData() {
        guard let query = outputSearchedTerm.value else {return}
        NetworkManager.shared.callRequest(query: query, sort: inputSort, page : self.page) { response in
            switch response {
            case .success(let value) :
                if self.page * 100 > value.total {
                    self.isEnd = true
                    return
                }
                if self.page == 1 {
                    self.total = value.total
                    self.outputItem.value = value.items

                } else {
                    self.outputItem.value.append(contentsOf: value.items)
                }
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.outputErrorMessage.value = errorType.errorMessage
                }
            }

        }
    }
    private func changeOrder() {
        if let tagNum = inputButtonTapped.value {
            let type = ButtonTag(rawValue: tagNum)
            switch type {
            case .simOrder:
                inputSort = "sim"
            case .dateOrder:
                inputSort = "date"
            case .ascOrder:
                inputSort = "asc"
            case .dscOrder:
                inputSort = "dsc"
            case .none:
                return
            }
            self.page = 1
            self.loadData()
        }
    }
}
