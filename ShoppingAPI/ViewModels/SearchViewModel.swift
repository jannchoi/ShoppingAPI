//
//  SearchViewModel.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/6/25.
//

import Foundation

final class SearchViewModel {
    
    let inputSearchedTerm: Observable<String?> = Observable(nil)
    
    let outputSearchedTerm: Observable<String?> = Observable(nil)
    
    init() {
        print("SearchViewModel init")
        
        inputSearchedTerm.lazyBind { _ in
            self.checkSearchedTerm()
        }
    }
    
    deinit {
        print("SearchViewModel init")
    }
    func checkSearchedTerm() {
        guard let input = inputSearchedTerm.value else {return}
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedInput.count >= 2 {
            outputSearchedTerm.value = trimmedInput
        }else {
            outputSearchedTerm.value = nil
        }
    }
    
}
