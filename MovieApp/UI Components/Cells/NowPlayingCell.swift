//
//  NowPlayingCell.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 15.11.2022.
//

import UIKit
import SnapKit

class NowPlayingCell: UICollectionViewCell {
    
    static let identifier = String(describing: NowPlayingCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var movieView: UIView = {
        let movieView = UIView()
        movieView.addSubview(movieImageView)
        movieView.addSubview(stackView)
        return movieView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description"
        return label
    }()
    
    private func configureUI() {
        contentView.addSubview(movieView)
        setConstraints()
    }

    func setConstraints() {
      
        movieView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(16)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(with movie: Movie) {
        
        guard let posterPath = movie.posterPath,
              let placeholder = UIImage(named: "person.fill") else {return}
        
        movieImageView.kf.indicatorType = .activity
        movieImageView.setImage(url: posterPath) { result in
            switch result {
            case .success(let image):
                return self.movieImageView.image = image
            case .failure(let error):
                self.movieImageView.image = placeholder
                print(error)
            }
        }
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
    }
    
}
