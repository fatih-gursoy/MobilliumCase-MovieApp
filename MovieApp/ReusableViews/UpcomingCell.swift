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
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    func configureUI() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(dateLabel)
        setConstraints()
    }

    func setConstraints() {
        
        movieImageView.snp.makeConstraints { make in
            make.height.width.equalTo(104)
            make.leading.top.bottom.equalTo(contentView).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.top).offset(8)
            make.leading.equalTo(movieImageView.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(stackView.snp.bottom).offset(16)
        }
        
    }
    
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        dateLabel.text = "10.10.2022"
        
        guard let backdropPath = movie.backdropPath,
              let placeholder = UIImage(systemName: "person.fill") else {return}
        
        movieImageView.kf.indicatorType = .activity
        movieImageView.setImage(path: backdropPath) { result in
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
