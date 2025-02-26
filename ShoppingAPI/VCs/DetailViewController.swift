//
//  DetailViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Alamofire

final class DetailViewController: UIViewController {
    let itemName = UILabel()
    let itemPrice = UILabel()
    let mallName = UILabel()
    let itemImage = UIImageView()
    let disposeBag = DisposeBag()
    let viewModel = DetailViewModel()
    lazy var likeButton = LikeButton(id: viewModel.selectedItem.productId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        bind()
    }
    private func bind() {
        likeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.likeButton.isSelected.toggle()
                owner.likeButton.toggleDesign()
            }.disposed(by: disposeBag)
    }
    private func configure() {
        view.backgroundColor = .black
        view.addSubview(itemImage)
        view.addSubview(likeButton)
        view.addSubview(mallName)
        view.addSubview(itemName)
        view.addSubview(itemPrice)
        itemImage.snp.makeConstraints { make in
            make.top.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(330)
        }
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(itemImage).inset(4)
        }
        mallName.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(itemImage.snp.horizontalEdges)
            
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(mallName.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(itemImage.snp.horizontalEdges)
            
        }
        itemPrice.snp.makeConstraints { make in
            make.top.equalTo(itemName.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(itemImage.snp.horizontalEdges)
            
        }
        configureItem()
        setUpItem()
        
        
    }
    private func configureItem() {
        itemImage.layer.cornerRadius = 8
        itemImage.clipsToBounds = true
        mallName.textColor = .gray
        mallName.font = UIFont.systemFont(ofSize: 12)
        mallName.textColor = .white
        itemName.font = UIFont.boldSystemFont(ofSize: 15)
        itemName.textColor = .white
        itemName.numberOfLines = 2
        itemPrice.font = .systemFont(ofSize: 14)
        itemPrice.textColor = .white
    }
    private func setUpItem() {
        let item = viewModel.selectedItem
        let url = URL(string: item.image)
        itemImage.kf.setImage(with: url)
        
        mallName.text = item.mallName
        itemName.text = replaceText(text: item.title)
        itemPrice.text = NumberFormatter.formatter.StringIntFormat(value: item.lprice)
    }

    private func replaceText(text: String) -> String {
        var result = text.replacingOccurrences(of: "<b>", with: "")
        result = result.replacingOccurrences(of: "</b>", with: "")
        return result
    }

   

}
