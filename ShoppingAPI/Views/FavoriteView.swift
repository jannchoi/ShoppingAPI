//
//  FavoriteView.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/4/25.
//

import UIKit

class FavoriteView: BaseView {
    lazy var  collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    let toastView = ToastView()
    let searchBar = UISearchBar()
    let titleLabel = UILabel()
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 300)
        layout.scrollDirection = .vertical
        return layout
    }

    
    override func configureHierachy() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .black
        titleLabel.textColor = .white
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.id)
    }
}
