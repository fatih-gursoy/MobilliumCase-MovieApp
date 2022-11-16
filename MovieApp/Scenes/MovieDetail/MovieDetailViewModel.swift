//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import Foundation

protocol MovieDetailViewModelProtocol: AnyObject {
    var view: MovieDetailViewProtocol? {get set}
    var router: MovieDetailRouterProtocol? {get set}
    var movieId: Int {get set}
    var movie: MovieDetail? {get set}
    
    func fetchMovieDetail()
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    private let service: NetworkManagerProtocol
    
    weak var view: MovieDetailViewProtocol?
    var router: MovieDetailRouterProtocol?

    var movieId: Int
    var movie: MovieDetail?
    
    init(id: Int, service: NetworkManagerProtocol = NetworkManager.shared) {
        self.service = service
        self.movieId = id
    }
    
    func fetchMovieDetail() {
        let request = APIRequest.detail(id: movieId)
        view?.showLoading()
        service.fetch(endPoint: request) { [weak self] (result: Result<MovieDetail, Error>) in
            guard let self = self else {return}

            switch result {
            case .success(let movie):
                self.movie = movie
                self.view?.configureUI()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view?.endLoading()
                }
            case .failure(let error):
                self.view?.showOnError(errorMessage: error.localizedDescription)
            }
        }
    }
}
