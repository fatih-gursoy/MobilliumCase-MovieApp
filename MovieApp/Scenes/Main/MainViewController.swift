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
}

class MainViewController: UIViewController {

    var viewModel: MainViewModelProtocol
    
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
        
        view.addSubview(scrollView)
        setConstraints()
        
        configureCollectionView()
        configureTableView()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
//MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(tableView)
        contentView.backgroundColor = .yellow
        return contentView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NowPlayingCell.self, forCellWithReuseIdentifier: NowPlayingCell.identifier)
        collectionView.backgroundColor = .brown
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
        let tableView = UITableView()
        tableView.register(UpcomingCell.self, forCellReuseIdentifier: UpcomingCell.identifier)
        tableView.backgroundColor = .blue
        tableView.isScrollEnabled = false
        tableView.rowHeight = 136
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
            make.width.equalTo(scrollView)
            make.height.equalTo(2500)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(256)
            make.bottom.equalTo(pageControl.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(collectionView)
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutIfNeeded()
        let tableHeight = tableView.contentSize.height
        tableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
    }
    
}

extension MainViewController: MainViewProtocol {
    
    func configureUI() {
        collectionView.reloadData()
        tableView.reloadData()
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
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
        
        cell.configure(with: viewModel.upcomingList[indexPath.row])
        return cell
    }
    
}
