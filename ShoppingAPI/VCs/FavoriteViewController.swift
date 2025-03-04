//
//  FavoriteViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/4/25.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    var mainView = FavoriteView()
    let disposeBag = DisposeBag()
    let viewModel = FavoriteViewModel()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.collectionView.reloadData()
    
    }
    private func bindData() {
        let likeButtonTapped = PublishSubject<(LikeButton, String)>()
        let input = FavoriteViewModel.Input(likeButtonTapped: likeButtonTapped,recentText: mainView.searchBar.rx.text.orEmpty, keyboardDismiss: mainView.collectionView.rx.didScroll)
        let output = viewModel.transform(input: input)

        output.favoriteData
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: FavoriteCollectionViewCell.id, cellType: FavoriteCollectionViewCell.self))
            {
            (item, element, cell) in
            cell.configureData(item: element)
                cell.likeButton.rx.tap.map{(cell.likeButton, element.title)}
                .bind(to: likeButtonTapped).disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        
        output.toastTrigger.drive(with: self) { owner, value in
            owner.mainView.toastView.setMessage(status: value.0, title: value.1)
            owner.mainView.showToast(owner.mainView.toastView, duration: 2.0, position: .top)
        }.disposed(by: disposeBag)
        
        output.keyboardDismiss.drive(with: self) { owner, _ in
            owner.mainView.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)
    }

}
