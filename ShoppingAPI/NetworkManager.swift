//
//  NetworkManager.swift
//  ShoppingAPI
//
//  Created by 최정안 on 1/16/25.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func callRequest(query: String, sort: String = "sim", page: Int, completionHandler: @escaping (Shop) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&sort=\(sort)&start=\(page)"
        let header: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverId, "X-Naver-Client-Secret" : APIKey.naverSecret]
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: Shop.self) { response in
                switch response.result {
                case .success(let value):
                    print(url)
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
