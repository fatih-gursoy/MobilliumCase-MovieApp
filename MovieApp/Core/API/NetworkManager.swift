//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    func fetch<T:Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T:Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        let url = endPoint.url
        let headers = endPoint.headers
        
        let request = AF.request(url, method: endPoint.method,
                                 parameters: endPoint.params,
                                 headers: headers)
        
        request.validate().responseDecodable(of: T.self) { response in
                  
            guard let statusCode = response.response?.statusCode else { return }
            
            if statusCode == 200 {
                guard let data = response.value else {return}
                completion(.success(data))
            } else {
                guard let error = response.error else {return}
                completion(.failure(error))
            }
        }
    }
}
