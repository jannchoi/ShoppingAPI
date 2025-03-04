//
//  ToastView.swift
//  ShoppingAPI
//
//  Created by 최정안 on 3/4/25.
//


import UIKit
import SnapKit
final class ToastView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0.0, y: 0.0, width: 380.0, height: 100.0)
        self.backgroundColor = .white
        self.configureView()
    }

    let message = UILabel()
    private func configureView() {
        self.addSubview(self.message)
        message.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        message.textColor = .red.withAlphaComponent(0.5)
        message.font = .boldSystemFont(ofSize: 14)
        message.numberOfLines = 0
        message.textAlignment = .center
    }
    func setMessage(status: Bool, title: String) {
        if status {
            message.text = title + " 좋아요!"
        } else {
            message.text = title + " 안 좋아요!"
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
