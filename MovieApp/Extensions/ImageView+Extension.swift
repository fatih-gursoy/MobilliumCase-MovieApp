//
//  ImageView+Extension.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        
        guard let url = URL(string: url) else {return}
        
        self.kf.setImage(with: url) { result in
            
            switch result {
            case .success(let image):
                let image = image.image
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
