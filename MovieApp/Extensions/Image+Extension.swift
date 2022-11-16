//
//  Image+Extension.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit

public extension UIImage {
    
    static var imdbLogo: UIImage {
        guard let image = Assets.Icons.imdbLogo else {return UIImage()}
        return image
    }
    
    static var rateIcon: UIImage {
        guard let image = Assets.Icons.rateIcon else {return UIImage()}
        return image
    }
    
    static var placeholder: UIImage {
        guard let image = Assets.Icons.placeholder else {return UIImage()}
        return image
    }
}
