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
    
    private lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = .black
        overlayView.layer.opacity = 0.40
        return overlayView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        label.font = UIFont(name: "SF Pro Display", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private func configureUI() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(stackView)
        setConstraints()
    }
    
    func setConstraints() {
        
        movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
    }
    
    func configureCell(with movie: Movie) {
        guard let title = movie.title,
              let year = movie.releaseDate?.dateToYear() else {return}
        
        let movieTitle = "\(title) (\(year))"
        titleLabel.text = movieTitle
        descriptionLabel.text = movie.overview
        movieImageView.setImage(path: movie.backdropPath, placeholder: .placeholder)
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
}
