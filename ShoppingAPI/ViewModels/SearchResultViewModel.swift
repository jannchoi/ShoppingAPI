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
    
    var inputSort = "sim"
    
    var outputSearchedTerm: Observable<String?> = Observable(nil)
    var outputItem: Observable<Shop?> = Observable(nil)
    var outputErrorMessage: Observable<String?> = Observable("")
    
    init() {
        print("SearchResultViewModel init")
        
        inputLoadDataTrigger.lazyBind { _ in
            self.loadData()
        }
        
        inputButtonTapped.lazyBind { _ in
            self.changeOrder()
        }
    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
    
    private func loadData() {
        guard let query = outputSearchedTerm.value else {return}
        NetworkManager.shared.callRequest(query: query, sort: inputSort, page : 1) { response in
            switch response {
            case .success(let value) :
                self.outputItem.value = value
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
            self.loadData()
        }
    }
}
