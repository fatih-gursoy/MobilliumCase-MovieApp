//
//  AppRouter.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit

final class AppRouter {
    
    static let shared = AppRouter()
    
    func start() -> UIViewController {
        let mainViewController = MainViewRouter.createScreen()
        return UINavigationController(rootViewController: mainViewController)
    }
}
