//
//  ResponseModel.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import Foundation

struct ResponseModel: Codable {
    let page: Int?
    let results: [Movie]?
    let total_results: Int?
    let total_pages: Int?
}
