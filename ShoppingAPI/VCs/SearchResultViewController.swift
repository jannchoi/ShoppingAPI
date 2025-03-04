//
//  SearchResultViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultViewController: UIViewController {
    
    var mainView = ShopView()
    let viewModel = SearchResultViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    lazy var buttonList = [mainView.simOrder, mainView.dateOrder, mainView.ascOrder, mainView.dscOrder]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.collectionView.reloadData()
    
    }
    private func bindData() {
        let tappedButton = PublishSubject<Int>()
        let likeButtonTapped = PublishSubject<LikeButton>()
        let input = SearchResultViewModel.Input(tappedButton: tappedButton, prefetchItems:  mainView.collectionView.rx.prefetchItems, itemSelected: mainView.collectionView.rx.modelSelected(itemDetail.self),likeButtonTapped: likeButtonTapped)
        let output = viewModel.transform(input: input)


        for button in buttonList {
            button.rx.tap.map{button.tag}
                .bind(to: tappedButton).disposed(by: disposeBag)
        }
        output.selecteButtonIdx.drive(with: self) { owner, value in
            owner.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            owner.switchButtonColor(selected: value)
        }.disposed(by: disposeBag)

        
        output.shopData.map{String($0.total)}.asDriver(onErrorJustReturn: "0")
            .drive(with: self) {
                owner, value in
                owner.mainView.totalCount.text = value + "개의 검색 결과"
            }.disposed(by: disposeBag)
        
        
        output.shopData
            .map{$0.items}
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.id, cellType: SearchResultCollectionViewCell.self))
        {
            (item, element, cell) in
            cell.configureData(item: element)
            cell.likeButton.rx.tap.map{cell.likeButton}
                .bind(to: likeButtonTapped).disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        
        output.itemselected.drive(with: self, onNext: { owner, item in
                let vc = DetailViewController()
                vc.viewModel.selectedItem = item
                owner.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)

        output.errorMessageTrigger.drive(with: self) { owner, message in
            owner.showAlert(text: message, button: nil)
        }.disposed(by: disposeBag)

        mainView.titleLabel.text = output.query
        navigationItem.titleView = mainView.titleLabel
        
    }
    private func switchButtonColor(selected: Int) {
        for i in 0...3 {
            if buttonList[i].tag == selected {
                buttonList[i].backgroundColor = .white
                buttonList[i].titleDesign(title: buttonList[i].title(for: .normal)!, size: 14)
            }
            else {
                buttonList[i].backgroundColor = .black
                buttonList[i].titleDesign(title: buttonList[i].title(for: .normal)!, size: 14, color: UIColor.white.cgColor)
            }
        }
    }
    
}


