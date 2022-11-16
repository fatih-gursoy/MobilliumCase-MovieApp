//
//  MainViewModel.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    var view: MainViewProtocol? {get set}
    var router: MainViewRouterProtocol? {get set}
    var nowPlayingList: [Movie] {get set}
    var upcomingList: [Movie] {get set}
    var isPageLoading: Bool {get set}
    var isLastPage: Bool {get set}
    
    func fetchData(list: ListType)
    func routeToDetail(movieId: Int)
}

class MainViewModel: MainViewModelProtocol {

    private let service: NetworkManagerProtocol
    
    weak var view: MainViewProtocol?
    var router: MainViewRouterProtocol?
    
    var listType: ListType?
    var nowPlayingList: [Movie] = []
    var upcomingList: [Movie] = []
    var currentPage = 1
    var isPageLoading: Bool = false
    var isLastPage: Bool = false
    
    init(service: NetworkManagerProtocol = NetworkManager.shared) {
        self.service = service
    }
    
// MARK: - Functions
    
    func fetchData(list: ListType) {
        if currentPage == 1 { self.view?.showLoading() }
        switch list {
        case .nowPlaying:
            fetchNowPlaying()
        case .upcoming:
            fetchUpcoming()
        }
    }
    
    private func fetchNowPlaying() {
        let request = APIRequest.nowPlaying(page: 1)
        
        service.fetch(endPoint: request) { [weak self] (result: Result<ResponseModel, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                guard let data = value.results else {return}
                self.nowPlayingList.append(contentsOf: data.prefix(upTo: 5))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view?.reloadCollectionView()
                    self.view?.endLoading()
                }
            case .failure(let error):
                self.view?.showOnError(errorMessage: error.localizedDescription)
            }
        }
    }

    private func fetchUpcoming() {
        guard !isLastPage && !isPageLoading else {return}
        isPageLoading = true
        let request = APIRequest.upcoming(page: currentPage)
        
        service.fetch(endPoint: request) { [weak self] (result: Result<ResponseModel, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                guard let data = value.results else {return}
                self.upcomingList.append(contentsOf: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view?.reloadTableView()
                    self.view?.endLoading()
                }
                self.isPageLoading = false
                guard let totalPages = value.total_pages else {return}
                self.currentPage < totalPages ? (self.currentPage += 1) : (self.isLastPage = true)
            case .failure(let error):
                self.view?.showOnError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func routeToDetail(movieId: Int) {
        router?.routeToDetail(movieId: movieId)
    }
}

enum ListType {
    case nowPlaying
    case upcoming
}
