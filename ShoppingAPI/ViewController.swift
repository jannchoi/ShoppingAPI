//
//  ViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/15/25.
//

import UIKit
import SnapKit


class ViewController: BaseViewController {
    
    var mainSearchView = SearchView()
    override func loadView() {
        view = mainSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainSearchView.titleLabel
        //navigationItem.title = "도봉러의 쇼핑쇼핑"
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white.cgColor]
        mainSearchView.searchBar.delegate = self
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
            searchBar.text = ""
        }
        else {
            let alert = UIAlertController(title: "주의", message: "두 글자 이상을 입력하세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                searchBar.text = ""
            }
            let cancel = UIAlertAction(title: "싫어요", style: .cancel) { _ in
                self.showAlert(title: "나가", text: "쇼핑 하지 마세요") {
                    searchBar.text = ""
                }
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
    }
}

extension UIViewController  {
    func showAlert(title: String, text: String, action: (() -> Void)? = nil) {
    
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            action?()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
