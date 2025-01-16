//
//  SearchResultViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import SnapKit
import Alamofire


class SearchResultViewController: UIViewController {
    
    var mainView = ShopView()
    override func loadView() {
        view = mainView
    }
    var searchedText : String?

    lazy var buttonList = [mainView.simOrder, mainView.dateOrder, mainView.ascOrder, mainView.dscOrder]

    var itemList = [itemDetail]()
    var page = 1
    var isEnd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        //navigationItem.title = "쇼핑"
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        
        mainView.titleLabel.text = searchedText ?? "알 수 없음"
        navigationItem.titleView = mainView.titleLabel
        loadData(query: searchedText ?? "", page: page)
        
        buttonList.forEach { button in
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

    }
    @objc
    func buttonTapped(_ button: UIButton)  {
        if let type = ButtonTag(rawValue: button.tag) {
            page = 1
            
            switch type {
            case .simOrder:
                loadData(query: searchedText!, page: page)
            case .dateOrder:
                loadData(query: searchedText!,sort: "date", page: page)
            case .ascOrder:
                loadData(query: searchedText! ,sort: "asc", page: page)
            case .dscOrder:
                loadData(query: searchedText!,sort: "dsc", page: page)
            }
            mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            switchButtonColor(selected: type.rawValue)
        }
    }
    func loadData(query: String, sort: String = "sim", page: Int)
    {
        NetworkManager.shared.callRequest(query: query, sort: sort, page: page) { value in
            if self.page == 1 {
                self.itemList = value.items
            } else {
                self.itemList.append(contentsOf: value.items)
            }
            self.mainView.totalCount.text = String(value.total) + " 개의 검색 결과"
            if self.page * 30 >= value.total {
                self.isEnd = true
            }
            self.mainView.collectionView.reloadData()
        }
    }

    func switchButtonColor(selected: Int) {
        for i in 0...3 {
            if buttonList[i].tag == selected {
                buttonList[i].backgroundColor = .white
                buttonList[i].setAttributedTitle(NSAttributedString(string: buttonList[i].title(for: .normal)!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black.cgColor]), for: .normal)
            }
            else {
                buttonList[i].backgroundColor = .black
                buttonList[i].setAttributedTitle(NSAttributedString(string: buttonList[i].title(for: .normal)!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white.cgColor]), for: .normal)
            }
        }
    }
    
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            print(itemList.count, item.row, isEnd)
            if itemList.count - 20 == item.row && isEnd == false {
                page += 1
                loadData(query: searchedText ?? "", page: page)
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as?  SearchResultCollectionViewCell else {return UICollectionViewCell()}
        let item = itemList[indexPath.item]
        cell.configureData(item: item)
        return cell
    }

}
