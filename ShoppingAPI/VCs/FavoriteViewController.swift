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
        let likeButtonTapped = PublishSubject<LikeButton>()
        let input = FavoriteViewModel.Input(likeButtonTapped: likeButtonTapped)
        let output = viewModel.transform(input: input)

        output.favoriteData
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: FavoriteCollectionViewCell.id, cellType: FavoriteCollectionViewCell.self))
        {
            (item, element, cell) in
            cell.configureData(item: element)
            cell.likeButton.rx.tap.map{cell.likeButton}
                .bind(to: likeButtonTapped).disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
    }

}
