//
//  WishFolderViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/5/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift


final class WishFolderViewController: UIViewController {
    let viewModel = WishFolderViewModel()
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func bind() {
        let input = WishFolderViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.folderList.bind(to: tableView.rx.items(cellIdentifier: WishTableViewCell.id, cellType: WishTableViewCell.self)) {
            (row, element, cell) in
            cell.configureData(item: element)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(WishFolder.self).bind(with: self) { owner, folder in
            let vc = WishFolderDetailViewController(viewModel: WishFolderDetailViewModel(targetFolder: folder))
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    func configuration() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(WishTableViewCell.self, forCellReuseIdentifier: WishTableViewCell.id)
        navigationItem.title = "곧 살 것 임"
    }
    
    
}
