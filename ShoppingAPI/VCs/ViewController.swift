//
//  ViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
final class ViewController: BaseViewController {
    
    var mainSearchView = SearchView()
    
    let viewModel = SearchViewModel()
    
    override func loadView() {
        view = mainSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainSearchView.titleLabel
        mainSearchView.searchBar.delegate = self
        
        bindData()
    }
    
    private func bindData() {
        viewModel.outputSearchedTerm.lazyBind { [weak self] text in
            if let text {
                let vc = SearchResultViewController()
                vc.viewModel.outputSearchedTerm.value = text
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                self?.showAlert(text: "두 글자 이상을 입력하세요.", button: nil)
            }
            self?.mainSearchView.searchBar.text = ""
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchedTerm.value = searchBar.text
    }
}


