//
//  UIColor+Extension.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit

public extension UIColor {
    
    static var appDarkGray: UIColor {
        guard let color = Assets.Colors.appDarkGray else {return UIColor()}
        return color
    }
    
    static var dotColor: UIColor {
        guard let color = Assets.Colors.dotColor else {return UIColor()}
        return color
    }
}
