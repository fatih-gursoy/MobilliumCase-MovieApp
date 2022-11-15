//
//  MainViewModel.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    var view: MainViewProtocol? {get set}
    var nowPlayingList: [Movie] {get set}
    var upcomingList: [Movie] {get set}
    
    func viewDidLoad()
}

class MainViewModel: MainViewModelProtocol {
    
    private let service: NetworkManagerProtocol

    var nowPlayingList: [Movie] = []
    var upcomingList: [Movie] = []
    var page = 1
    
    weak var view: MainViewProtocol?
    
    init(service: NetworkManagerProtocol = NetworkManager.shared) {
        self.service = service
    }
    
    func viewDidLoad() {
        fetchData(listType: .nowPlaying)
        fetchData(listType: .upcoming)
    }
    
    private func fetchData(listType: ListType) {
        
        var request: APIRequest
        
        switch listType {
        case .nowPlaying:
            request = APIRequest.nowPlaying(page: page)
        case .upcoming:
            request = APIRequest.upcoming(page: page)
        }
        
        service.fetch(endPoint: request) { [weak self] (result: Result<ResponseModel, Error>) in
            switch result {
            case .success(let value):
                guard let data = value.results else {return}
                
                switch listType {
                case .nowPlaying:
                    self?.nowPlayingList = data
                case .upcoming:
                    self?.upcomingList = data
                }
                DispatchQueue.main.async { self?.view?.configureUI() }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

enum ListType {
    case nowPlaying
    case upcoming
}
