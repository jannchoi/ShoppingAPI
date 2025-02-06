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
    
    func callRequest(query: String, sort: String = "sim", page: Int, completionHandler: @escaping (Result<Shop, Error>) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&sort=\(sort)&start=\(page)"
        let header: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverId, "X-Naver-Client-Secret" : APIKey.naverSecret]
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...200)
            .responseDecodable(of: Shop.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    let code = response.response?.statusCode
                    completionHandler(.failure(self.getErrorMessage(code: code ?? 500)))
                    print(error)
                }
            }
    }
    private func getErrorMessage(code: Int) -> NetworkError {
        switch code {
        case 400: return .badRequest
        case 403: return .unauthorized
        case 404: return .notFound
        default: return .systemError
        }
    }
}
