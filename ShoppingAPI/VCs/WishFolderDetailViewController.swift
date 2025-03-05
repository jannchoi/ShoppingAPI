//
//  WishFolderDetailViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RealmSwift


final class WishFolderDetailViewController: UIViewController {
    let viewModel : WishFolderDetailViewModel
    let disposeBag = DisposeBag()

    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        bind()
    }
    init(viewModel: WishFolderDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bind() {
        let input = WishFolderDetailViewModel.Input(recentText: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty))
        let output = viewModel.transform(input: input)
        
        output.itemList.bind(to: tableView.rx.items(cellIdentifier: WishTableViewCell.id, cellType: WishTableViewCell.self)) {
            (row, element, cell) in
            cell.configureData(item: element)
        }.disposed(by: disposeBag)
        
        
        
        
    }
    func configuration() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        navigationItem.title = viewModel.internalData.targetFolder.name
        
        tableView.register(WishTableViewCell.self, forCellReuseIdentifier: WishTableViewCell.id)
    }
    
    
}

