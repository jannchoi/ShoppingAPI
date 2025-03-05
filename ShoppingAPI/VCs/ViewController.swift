//
//  ViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: BaseViewController {
    
    var mainSearchView = SearchView()
    
    private let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    
    override func loadView() {
        view = mainSearchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = mainSearchView.titleLabel
        mainSearchView.searchBar.becomeFirstResponder()
        bindData()
        barButtonItem()
    }
    
    private func bindData() {
        
        let input = SearchViewModel.Input(searchedWord: mainSearchView.searchBar.rx.searchButtonClicked.withLatestFrom(mainSearchView.searchBar.rx.text.orEmpty))
        let output = viewModel.transform(input: input)
        
        output.searchButtonTapped.drive(with: self) { owner, value in
            let vc = SearchResultViewController()
            vc.viewModel.query = value
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        output.alertTrigger.drive(with: self) { owner, message in
            owner.showAlert(text: message, button: nil)
            owner.mainSearchView.searchBar.text = ""
        }.disposed(by: disposeBag)
        
        

    }
    private func barButtonItem() {
        mainSearchView.wishListButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(WishFolderViewController(), animated: true)
            }.disposed(by: disposeBag)
        mainSearchView.favoriteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(FavoriteViewController(), animated: true)
            }.disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mainSearchView.wishListButton), UIBarButtonItem(customView: mainSearchView.favoriteButton)]
        
        
    }


}


