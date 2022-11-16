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
        guard let path else {return}
        guard let url = URL(string: Strings.imageBaseURL + path) else {return}
        
        self.kf.setImage(with: url, placeholder: placeholder) { result in
            switch result {
            case .success(let image):
                let image = image.image
                self.image = image
            case .failure(let error):
                self.image = placeholder
                print(error.localizedDescription)
            }
        }
    }
}
