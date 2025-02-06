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

        buttonList.forEach { button in
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        bindData()

    }
    private func bindData() {
        viewModel.outputSearchedTerm.bind { text in
            self.mainView.titleLabel.text = text
            self.navigationItem.titleView = self.mainView.titleLabel
            self.viewModel.inputLoadDataTrigger.value = ()
        }
        viewModel.outputItem.lazyBind { shop in
            guard let shop else {return}
            self.mainView.collectionView.reloadData()
            self.mainView.totalCount.text = String(shop.total.formatted()) + " 개의 검색 결과"
        }
        viewModel.outputErrorMessage.lazyBind { message in
            if let message {
                self.showAlert(text: message, button: nil)
            }
        }
    }
    @objc
    func buttonTapped(_ button: UIButton)  {
        viewModel.inputButtonTapped.value = button.tag
        mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        switchButtonColor(selected: button.tag)
    }
    
    func switchButtonColor(selected: Int) {
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

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let shop = viewModel.outputItem.value else {return 0 }
        return shop.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as?  SearchResultCollectionViewCell, let shop = viewModel.outputItem.value else {return UICollectionViewCell()}
        let item = shop.items[indexPath.item]
        cell.configureData(item: item)
        return cell
    }

}
