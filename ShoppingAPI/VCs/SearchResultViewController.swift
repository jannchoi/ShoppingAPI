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
    var searchedText : String?
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    lazy var buttonList = [mainView.simOrder, mainView.dateOrder, mainView.ascOrder, mainView.dscOrder]
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.prefetchDataSource = self
        bindData()

    }
    private func bindData() {
        let tappedButton = PublishSubject<Int>()
        let input = SearchResultViewModel.Input(tappedButton: tappedButton, prefetchItems:  mainView.collectionView.rx.prefetchItems)
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
                owner.navigationController?.navigationItem.title = value + "개의 검색 결과"
            }.disposed(by: disposeBag)
        
        output.shopData
            .map{$0.items}
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.id, cellType: SearchResultCollectionViewCell.self))
        {
            (item, element, cell) in
            cell.configureData(item: element)
        }.disposed(by: disposeBag)

        viewModel.outputErrorMessage.lazyBind { [weak self] message in
            if let message {
                self?.showAlert(text: message, button: nil)
            }
        }

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
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            viewModel.inputPrefetchingTrigger.value = item.item
        }
    }
    
    
}

