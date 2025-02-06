//
//  SearchResultViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    var mainView = ShopView()
    let viewModel = SearchResultViewModel()
    var searchedText : String?
    
    override func loadView() {
        view = mainView
    }
    lazy var buttonList = [mainView.simOrder, mainView.dateOrder, mainView.ascOrder, mainView.dscOrder]
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        setAction()
        bindData()

    }
    private func bindData() {
        viewModel.outputSearchedTerm.bind { [weak self] text in
            self?.mainView.titleLabel.text = text
            self?.navigationItem.titleView = self?.mainView.titleLabel
            self?.viewModel.inputLoadDataTrigger.value = ()
        }
        viewModel.outputItem.lazyBind { [weak self] shop in
            print("outputItem bind", self?.viewModel.total)
            self?.mainView.collectionView.reloadData()
            self?.mainView.totalCount.text  = String(self?.viewModel.total.formatted() ?? "") + " 개의 검색 결과"
        }
        viewModel.outputErrorMessage.lazyBind { [weak self] message in
            if let message {
                self?.showAlert(text: message, button: nil)
            }
        }
    }
    private func setAction() {
        buttonList.forEach { button in
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func buttonTapped(_ button: UIButton)  {
        viewModel.inputButtonTapped.value = button.tag
        mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        switchButtonColor(selected: button.tag)
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
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputItem.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as?  SearchResultCollectionViewCell else {return UICollectionViewCell()}
        let item = viewModel.outputItem.value[indexPath.item]
        cell.configureData(item: item)
        return cell
    }

}
