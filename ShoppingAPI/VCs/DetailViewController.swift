//
//  DetailViewController.swift
//  ShoppingAPI
//
//  Created by 최정안 on 2/26/25.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController {
    var webView: WKWebView!
    var myURL = "https://smartstore.naver.com/main/products/10874993754"
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: myURL)
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
    }

}
