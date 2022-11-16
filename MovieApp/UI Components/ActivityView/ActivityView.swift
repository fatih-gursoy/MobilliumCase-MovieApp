//
//  ActivityView.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit
import SnapKit

class ActivityView: UIActivityIndicatorView {
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.style = .medium
        self.hidesWhenStopped = true
        self.backgroundColor = .systemBackground
        self.startAnimating()
    }
}
