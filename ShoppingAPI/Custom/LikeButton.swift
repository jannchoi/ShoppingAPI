//
//  LikeButton.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LikeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var id: String?

    init(id: String) {
        self.id = id
        super.init(frame: .zero)
        setImage(UIImage(systemName: "heart"), for: .normal)
        tintColor = .red
        self.prepareDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func toggleDesign() {
        guard let id else {return}
        if isSelected {
            if !UserDefaultsManager.like.contains(id) {
                UserDefaultsManager.like.append(id)
            }
            setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            if let idx = UserDefaultsManager.like.firstIndex(of: id) {
                UserDefaultsManager.like.remove(at: idx)
            }
            setImage((UIImage(systemName: "heart")), for: .normal)
        }
    }
    private func prepareDesign() {
        guard let id else {return}
        if UserDefaultsManager.like.contains(id) {
            isSelected = true
        }
        else {
            isSelected = false
        }
        toggleDesign()
    }

}
