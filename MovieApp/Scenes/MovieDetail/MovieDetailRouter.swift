//
//  MovieDetailRouter.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit

protocol MovieDetailRouterProtocol: AnyObject {
    var viewController: UIViewController {get set}
}

class MovieDetailRouter: MovieDetailRouterProtocol {
    
    unowned var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func createScreen(with movieId: Int) -> UIViewController {
        let viewModel = MovieDetailViewModel(id: movieId)
        let movieDetailVC = MovieDetailViewController(viewModel: viewModel)
        movieDetailVC.viewModel.router = MovieDetailRouter(viewController: movieDetailVC)
        return movieDetailVC
    }
}
