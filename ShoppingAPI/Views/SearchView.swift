//
//  SearchView.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import UIKit

class SearchView: BaseView {
    
    let searchBar = UISearchBar()
    let titleLabel = UILabel()
    let mainImage = {
        let img = UIImageView()
        img.image = UIImage(named: "shoppingImage")
        return img
    }()
    let centerLabel = UILabel()
    let wishListButton = UIButton()
    let favoriteButton = UIButton()

    
    override func configureHierachy() {
        addSubview(searchBar)
        addSubview(mainImage)
        addSubview(centerLabel)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        mainImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(250)
        }
        centerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(mainImage)
            make.top.equalTo(mainImage.snp.bottom).offset(40)
        }
    }
    
    override func configureView() {
        backgroundColor = .black
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드,상품,프로필,태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.layer.cornerRadius = 5
        searchBar.clipsToBounds = true
        searchBar.barTintColor = .darkGray
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        
        labelDesign(label: titleLabel, title: "쇼핑쇼핑", color: .white)
        labelDesign(label: centerLabel, title: "쇼핑하러Go", color: .white)
        centerLabel.font = .boldSystemFont(ofSize: 18)
        wishListButton.setTitle("Wish", for: .normal)
        favoriteButton.setTitle("Like", for: .normal)
    }
    
    func labelDesign(label: UILabel, title: String, color: UIColor) {
        label.text = title
        label.textColor = color
    }
    
}

