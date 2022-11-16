//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func configureUI()
    func showOnError(errorMessage: String)
    func showLoading()
    func endLoading()
}

class MovieDetailViewController: UIViewController {

    var viewModel: MovieDetailViewModelProtocol
    
    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie Title"
        view.addSubview(scrollView)
        setConstraints()
        viewModel.view = self
        viewModel.fetchMovieDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.addSubview(movieImageView)
        contentView.addSubview(midStackView)
        contentView.addSubview(bottomStackView)
        return contentView
    }()
    
    private lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.backgroundColor = .black
        overlayView.layer.opacity = 0.40
        return overlayView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addSubview(overlayView)
        return imageView
    }()
    
    private lazy var midStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imdbButton, ratingStackView, dotLabel, dateLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var imdbButton: UIButton = {
        let button = UIButton(type: .custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.setImage(.imdbLogo, for: .normal)
        button.addTarget(self, action: #selector(imdbButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = .rateIcon
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dotLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Display", size: 20)
        label.textColor = .dotColor
        label.text = "•"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Display", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    private lazy var activityView: UIView = {
        let activityView = ActivityView(frame: CGRect(x: 0, y: 0,
                                                      width: view.frame.size.width,
                                                      height: view.frame.size.height))
        return activityView
    }()
    
    @objc func imdbButtonTapped() {
        guard let imdbID = viewModel.movie?.imdbID,
              let url = URL(string: "https://www.imdb.com/title/" + imdbID) else {return}
        
        UIApplication.shared.open(url)
    }
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        movieImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(256)    
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        midStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(movieImageView.snp.bottom).offset(16)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(midStackView.snp.bottom).offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

}

extension MovieDetailViewController: MovieDetailViewProtocol {
    
    func configureUI() {
        
        guard let movie = viewModel.movie,
              let title = movie.title,
              let year = movie.releaseDate?.dateToYear() else {return}
        
        let movieTitle = "\(title) (\(year))"
        navigationItem.title = movieTitle
        titleLabel.text = movieTitle
        descriptionLabel.text = viewModel.movie?.overview
        
        if let rating = viewModel.movie?.voteAverage {
            let roundedRating = String(format: "%.1f", rating)
            let ratingString = "\(roundedRating)/10"
            ratingLabel.attributedText = ratingString.customAttributedText(withString: ratingString, font: UIFont.systemFont(ofSize: 13))
        }
        
        dateLabel.text = viewModel.movie?.releaseDate?.dateFormatter()
        movieImageView.setImage(path: movie.backdropPath, placeholder: .placeholder)
    }
    
    func showLoading() {
        view.addSubview(activityView)
    }
    
    func endLoading() {
        activityView.removeFromSuperview()
    }
    
    func showOnError(errorMessage: String) {
        presentAlert(title: "Lütfen Tekrar Deneyiniz", message: errorMessage, completion: nil)
    }
    
}
