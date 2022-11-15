//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 16.11.2022.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func configureUI()
}

class MovieDetailViewController: UIViewController {

    var viewModel: MovieDetailViewModelProtocol
    var activityView = ActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.view = self
        viewModel.viewDidLoad()
        
        view.addSubview(scrollView)
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.addSubview(activityView)
        contentView.addSubview(movieImageView)
        contentView.addSubview(stackView)
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
        imageView.addSubview(overlayView)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
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
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16)
            make.top.equalTo(movieImageView.snp.bottom).offset(16)
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
        self.navigationItem.title = viewModel.movie?.title        
        titleLabel.text = viewModel.movie?.title
        descriptionLabel.text = viewModel.movie?.overview
        
        guard let backdropPath = viewModel.movie?.backdropPath,
              let placeholder = UIImage(systemName:"person.fill") else {return}
        
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
        
        UIView.transition(with: self.view, duration: 1.5, options: [.transitionCrossDissolve]) {
            self.activityView.removeFromSuperview()
        }
    }
    
}
