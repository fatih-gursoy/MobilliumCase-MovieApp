//
//  EndPoint.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import Foundation
import Alamofire

protocol EndPoint {
    var baseURL: String {get}
    var url: URL {get}
    var headers: HTTPHeaders? {get}
    var method: HTTPMethod {get}
    var path: String {get}
    var params: [String: String] {get}
}

enum APIRequest: EndPoint {
    
    case nowPlaying(page: Int)
    case upcoming(page: Int)
    case detail(id: Int)
    
    var baseURL: String { Strings.baseURL }
    
    var url: URL {
        var components = URLComponents(string: baseURL)!
        components.path = "/3/movie" + path
        return components.url!
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default: return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .nowPlaying(_):
            return "/now_playing"
        case .upcoming(_):
            return "/upcoming"
        case .detail(let id):
            return "/\(id)"
        }
    }
    
    var params: [String: String] {
        
        switch self {
        case .nowPlaying(let page), .upcoming(let page):
            return ["api_key": Strings.apiKey,
                    "page": "\(page)"]
            
        case .detail(_):
            return ["api_key": Strings.apiKey]
        }
    }
}
