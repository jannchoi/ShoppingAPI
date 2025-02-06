//
//  ShopView.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import UIKit

class ShopView: BaseView {
    lazy var  collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    let titleLabel = UILabel()
    let totalCount = UILabel()
    lazy var simOrder = orderButtonStyle(title: "정확도", tagInt: 0)
    lazy var dateOrder = orderButtonStyle(title: "날짜순", tagInt: 1)
    lazy var ascOrder = orderButtonStyle(title: "가격낮은순", tagInt: 2)
    lazy var dscOrder = orderButtonStyle(title: "가격높은순", tagInt: 3)
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 300)
        layout.scrollDirection = .vertical
        return layout
    }
    
    func orderButtonStyle(title: String, tagInt: Int) -> UIButton{
        let button = UIButton()
        button.tag = tagInt
        button.setTitle(title, for: .normal)
        button.titleDesign(title: title, size: 14, color: UIColor.white.cgColor)
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    override func configureHierachy() {
        addSubview(totalCount)
        addSubview(simOrder)
        addSubview(dateOrder)
        addSubview(ascOrder)
        addSubview(dscOrder)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        totalCount.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(10)
            make.trailing.greaterThanOrEqualTo(10)
            make.height.equalTo(20)
        }

        simOrder.snp.makeConstraints { make in
            make.top.equalTo(totalCount.snp.bottom).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        dateOrder.snp.makeConstraints { make in
            make.centerY.equalTo(simOrder)
            make.leading.equalTo(simOrder.snp.trailing).offset(8)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        ascOrder.snp.makeConstraints { make in
            make.centerY.equalTo(simOrder)
            make.leading.equalTo(dateOrder.snp.trailing).offset(8)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        dscOrder.snp.makeConstraints { make in
            make.centerY.equalTo(simOrder)
            make.leading.equalTo(ascOrder.snp.trailing).offset(8)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(simOrder.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        totalCount.textColor = .systemGreen
        totalCount.font = .boldSystemFont(ofSize: 15)
        collectionView.backgroundColor = .black
        titleLabel.textColor = .white
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }
}

