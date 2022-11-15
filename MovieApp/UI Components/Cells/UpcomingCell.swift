//
//  UpcomingCell.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 15.11.2022.
//

import UIKit

class UpcomingCell: UITableViewCell {

    static let identifier = String(describing: UpcomingCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    func configureUI() {
        contentView.addSubview(titleLabel)
        setConstraints()
    }

    func setConstraints() {
      
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
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
    
}
