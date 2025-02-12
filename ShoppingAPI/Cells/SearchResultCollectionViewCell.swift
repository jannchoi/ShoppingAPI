//
//  SearchResultCollectionViewCell.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    static let id = "SearchResultCollectionViewCell"
    
    let itemImage = UIImageView()
    let malName = UILabel()
    let itemName = UILabel()
    let lowPrice = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    func configureData(item: itemDetail) {
        let url = URL(string: item.image)
        itemImage.kf.setImage(with: url)
        
        malName.text = item.mallName
        itemName.text = replaceText(text: item.title)
        lowPrice.text = NumberFormatter.formatter.StringIntFormat(value: item.lprice)
    }
    func replaceText(text: String) -> String {
        var result = text.replacingOccurrences(of: "<b>", with: "")
        result = result.replacingOccurrences(of: "</b>", with: "")
        return result
    }
    override func configureHierachy() {
        contentView.addSubview(itemImage)
        contentView.addSubview(malName)
        contentView.addSubview(itemName)
        contentView.addSubview(lowPrice)
    }
    override func configureLayout() {
        itemImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.snp.width)
            make.centerX.equalToSuperview()
        }
        malName.snp.makeConstraints { make in
            make.leading.equalTo(itemImage).offset(8)
            make.top.equalTo(itemImage.snp.bottom).offset(4)
            make.trailing.greaterThanOrEqualTo(itemImage.snp.trailing).inset(8)
            make.height.equalTo(15)
        }
        itemName.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(itemImage).inset(10)
            make.top.equalTo(malName.snp.bottom).offset(2)
            make.height.equalTo(40)
        }
        lowPrice.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(itemImage).inset(10)
            make.top.equalTo(itemName.snp.bottom).offset(2)
            make.height.equalTo(25)
        }
    }
    override func configureView() {
        itemImage.layer.cornerRadius = 8
        itemImage.clipsToBounds = true
        malName.textColor = .gray
        malName.font = UIFont.systemFont(ofSize: 12)
        malName.textColor = .white
        itemName.font = UIFont.systemFont(ofSize: 14)
        itemName.textColor = .white
        itemName.numberOfLines = 2
        lowPrice.font = .boldSystemFont(ofSize: 20)
        lowPrice.textColor = .white
    }
}
