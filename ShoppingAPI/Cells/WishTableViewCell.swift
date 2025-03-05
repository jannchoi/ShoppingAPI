//
//  WishTableViewCell.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import UIKit
import SnapKit
import RxSwift

final class WishTableViewCell: UITableViewCell {
    static let id = "WishTableViewCell"
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let overviewLabel = UILabel()
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    func configureData<T>(item: T) {
        if let folder = item as? WishFolder {
            titleLabel.text = folder.name
            subTitleLabel.text = "\(folder.detail.count) 개"
        } else if let item = item as? WishItem{
            titleLabel.text = item.itemName
            subTitleLabel.text = item.date.formatted()
        }


    }
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.trailing.top.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
          make.height.equalTo(18)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.leading.equalTo(titleLabel.snp.leading)
          make.height.equalTo(18)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }

    }
    
    private func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(overviewLabel)
    }
    
    private func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 15)
        subTitleLabel.font = .systemFont(ofSize: 13)

    }
}

