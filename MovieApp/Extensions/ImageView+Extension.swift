//
//  ImageView+Extension.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(path: String?, placeholder: UIImage) {
        self.kf.indicatorType = .activity
        guard let path else {
            self.image = placeholder
            return }
        
        guard let url = URL(string: Strings.imageBaseURL + path) else {return}
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
