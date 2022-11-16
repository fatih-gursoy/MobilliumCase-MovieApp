//
//  ViewController.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 14.11.2022.
//

import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    func configureUI()
    func showOnError(errorMessage: String)
}

class MainViewController: UIViewController {

    var viewModel: MainViewModelProtocol
    var activityView = ActivityView()
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(activityView)
        view.addSubview(scrollView)

        setConstraints()        
        prepareRefreshControl()

        viewModel.view = self
        viewModel.fetchNowPlaying()
        viewModel.fetchUpcoming()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureNavBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func prepareRefreshControl() {
        refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.bounds = CGRect(x: 0, y: -50, width: refreshControl.frame.width, height: refreshControl.frame.height)
        scrollView.refreshControl = refreshControl
    }
    
    @objc func pullRefresh() {
        viewModel.fetchNowPlaying()
        viewModel.fetchUpcoming()
        refreshControl.endRefreshing()
    }
    
//MARK: - UI Components
    
    private var refreshControl = UIRefreshControl()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(tableView)
        return contentView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 256)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = DynamicTableView()
        tableView.register(UpcomingCell.self, forCellReuseIdentifier: UpcomingCell.identifier)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 136
        tableView.isMultipleTouchEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        return pageControl
    }()
    
    func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(256)
        }
        
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.bottom)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
        }
    }
    
}

extension MainViewController: MainViewProtocol {
    
    func configureUI() {
        collectionView.reloadData()
        tableView.reloadData()
        pageControl.numberOfPages = viewModel.nowPlayingList.count
        activityView.removeFromSuperview()
    }
    
    func showOnError(errorMessage: String) {
        presentAlert(title: "Lütfen Tekrar Deneyiniz", message: errorMessage, completion: nil)
    }
    
}

//MARK: - CollectionView

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nowPlayingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.identifier, for: indexPath) as? NowPlayingCell else { fatalError("Could not load") }
        
        cell.configureCell(with: viewModel.nowPlayingList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.nowPlayingList[indexPath.row].id else {return}
        viewModel.routeToDetail(movieId: id)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let width = collectionView.frame.width
            pageControl.currentPage = Int(collectionView.contentOffset.x / width)
        }
    }
    
}

//MARK: - TableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingCell.identifier) as? UpcomingCell
        else { fatalError("TableView Cell error") }
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.configure(with: viewModel.upcomingList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = viewModel.upcomingList[indexPath.row].id else {return}
        viewModel.routeToDetail(movieId: id)
    }

}

extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView {
            let contentHeight = scrollView.contentSize.height
            let scrollOffset = scrollView.contentOffset.y
            let height = scrollView.frame.size.height

            if (scrollOffset > contentHeight - height - 100) {
                viewModel.fetchUpcoming()
            }
        }
    }
}
