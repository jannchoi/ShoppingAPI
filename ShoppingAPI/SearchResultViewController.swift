//
//  SearchResultViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import SnapKit
import Alamofire

struct Shop: Decodable {
    let total : Int
    let items : [itemDetail]
    
}
struct itemDetail: Decodable {
    let title : String
    let image: String
    let lprice : String
    let mallName : String
}
enum ButtonTag: Int {
    case simOrder = 0
    case dateOrder = 1
    case ascOrder = 2
    case dscOrder = 3
}

class SearchResultViewController: UIViewController {
    
    let titleLabel = UILabel()
    var searchedText : String?
    let totalCount = UILabel()
    lazy var simOrder = orderButtonStyle(title: "정확도", tagInt: 0)
    lazy var dateOrder = orderButtonStyle(title: "날짜순", tagInt: 1)
    lazy var ascOrder = orderButtonStyle(title: "가격낮은순", tagInt: 2)
    lazy var dscOrder = orderButtonStyle(title: "가격높은순", tagInt: 3)
    
    lazy var buttonList = [simOrder, dateOrder, ascOrder, dscOrder]
    
    lazy var  collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    var itemList = [itemDetail]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        configureView()
        navigationItem.titleView = titleLabel
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        callRequest(query: searchedText ?? "")

    }
    @objc
    func buttonTapped(_ button: UIButton)  {
        
        if let type = ButtonTag(rawValue: button.tag) {
            switch type {
                
            case .simOrder:
                callRequest(query: searchedText!)
            case .dateOrder:
                callRequest(query: searchedText!, sort: "date")
            case .ascOrder:
                callRequest(query: searchedText!, sort: "asc")
            case .dscOrder:
                callRequest(query: searchedText!, sort: "dsc")
            }
            switchButtonColor(selected: type.rawValue)
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
    func orderButtonStyle(title: String, tagInt: Int) -> UIButton{
        let button = UIButton()
        button.tag = tagInt
        button.setTitle(title, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.white.cgColor]), for: .normal)
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }
    
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 300)
        layout.scrollDirection = .vertical
        return layout
    }
    
    func configureView() {
        view.addSubview(totalCount)
        view.addSubview(simOrder)
        view.addSubview(dateOrder)
        view.addSubview(ascOrder)
        view.addSubview(dscOrder)
        view.addSubview(collectionView)
        
        
        totalCount.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(10)
            make.trailing.greaterThanOrEqualTo(10)
            make.height.equalTo(20)
        }

        simOrder.snp.makeConstraints { make in
            make.top.equalTo(totalCount.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        
        
        totalCount.textColor = .systemGreen
        totalCount.font = .boldSystemFont(ofSize: 15)
        
        collectionView.backgroundColor = .black
        titleLabel.text = searchedText ?? "알 수 없음"
        titleLabel.textColor = .white
    }
    
    func callRequest(query: String, sort: String = "sim") {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100&sort=\(sort)"
        let header: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverId, "X-Naver-Client-Secret" : APIKey.naverSecret]
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: Shop.self) { response in
                switch response.result {
                case .success(let value):
                    self.itemList = value.items
                    self.totalCount.text = String(value.total) + " 개의 검색 결과"
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
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
