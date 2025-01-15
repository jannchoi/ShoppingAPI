//
//  ViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let titleLabel = {
        let label = UILabel()
        label.text = "쇼핑쇼핑"
        label.textColor = .white
        return label
    }()
    let mainImage = {
        let img = UIImageView()
        img.image = UIImage(named: "shoppingImage")
        return img
    }()
    let centerLabel = {
        let label = UILabel()
        label.text = "쇼핑하러GO"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleLabel
        //navigationItem.title = "도봉러의 쇼핑쇼핑"
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white.cgColor]
        view.backgroundColor = .black
        searchBar.delegate = self
        configureView()
        configureSearchBar()
        
    }
    func configureView() {
        view.addSubview(searchBar)
        view.addSubview(mainImage)
        view.addSubview(centerLabel)
        
        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
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
    func configureSearchBar() {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드,상품,프로필,태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        searchBar.layer.cornerRadius = 5
        searchBar.clipsToBounds = true
        searchBar.barTintColor = .darkGray
        searchBar.searchTextField.leftView?.tintColor = .lightGray
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let input = searchBar.text ?? ""
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedInput.count >= 2 {
            let vc = SearchResultViewController()
            vc.searchedText = trimmedInput
            navigationController?.pushViewController(vc, animated: true)
            view.endEditing(true)
        }
        
    }
}
