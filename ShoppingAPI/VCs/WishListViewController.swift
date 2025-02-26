//
//  WishListViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import UIKit
import Kingfisher
import SnapKit
import Alamofire

struct WishItem: Hashable, Identifiable {
    let id = UUID()
    let itemName : String
    let date : String
}

class WishListViewController: UIViewController {
    enum Section: CaseIterable{
        case main
    }
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, WishItem>!
    var list = [WishItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        configureDataSource()
      
    }
    func configuration() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.delegate = self
        collectionView.delegate = self
        navigationItem.title = "곧 살 것 임"
        
    }
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WishItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot)
        
    }
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .systemPink.withAlphaComponent(0.4)
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    private func configureDataSource() {
        let registeration: UICollectionView.CellRegistration<UICollectionViewListCell, WishItem> = UICollectionView.CellRegistration {
            cell, indexPath, itemIdentifier in

            var backgroundConfig = UIBackgroundConfiguration.listCell()
            backgroundConfig.backgroundColor = .systemPink.withAlphaComponent(0.3)
            cell.backgroundConfiguration = backgroundConfig

            let url = URL(string: "https://picsum.photos/200")!
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        var content = UIListContentConfiguration.valueCell()
                        content.text = itemIdentifier.itemName
                        content.textProperties.font = .boldSystemFont(ofSize: 14)
                        content.secondaryText = itemIdentifier.date
                        content.image = UIImage(data: data)
                        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
                        cell.contentConfiguration = content
                    }
                } catch {
                    print(error)
                }
            }
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registeration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }

}
extension WishListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let newItem = WishItem(itemName: trimmedText, date: Date().formatted())
        list.insert(newItem, at: 0)
        updateSnapShot()
        searchBar.text = ""
    }
}
extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        list.remove(at: indexPath.item)
        updateSnapShot()
    }
}
