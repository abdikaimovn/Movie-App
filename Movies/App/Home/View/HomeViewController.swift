//
//  ViewController.swift
//  Movies
//
//  Created by Нурдаулет on 27.06.2023.
//

import UIKit
import SnapKit
import SkeletonView

enum RowsInTableView: CaseIterable{
    case recommended, categories, list
}

final class HomeViewController: BaseViewController {
    let rows = RowsInTableView.allCases
    let homePresenterDelegate = HomePresenter()
    var recommendedMovies = [HomeModel]()
    var listTableMovies = [HomeModel]()
    var isDataLoaded = false
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.register(RecommendedTableCell.self, forCellReuseIdentifier: "RecommendedTableCell")
        tableView.register(CategoriesTableCell.self, forCellReuseIdentifier: "CategoriesTableCell")
        tableView.register(ListTableCell.self, forCellReuseIdentifier: "ListTableCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        homePresenterDelegate.delegate = self
        homePresenterDelegate.fetchDataFromAPI(category: .popular)
        homePresenterDelegate.receiveDataForListTableCell(category: .nowPlaying)
        tableView.isUserInteractionEnabled = true
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func identifyTheCategoryNumber(_ categoryNumber: Int) -> Categories{
        var category = Categories.nowPlaying
        switch categoryNumber{
        case 0:
            category = .nowPlaying
        case 1:
            category = .upcoming
        case 2:
            category = .topRated
        case 3:
            category = .popular
        default:
            break
        }
        return category
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDataLoaded {
            switch rows[indexPath.row]{
            case .recommended:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedTableCell", for: indexPath) as! RecommendedTableCell
                cell.configure(recommendedMovies: self.recommendedMovies)
                cell.parentViewController = self
    
                return cell
                
            case .categories:
                
                let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
                cell.categoryDidSelect = { [weak self] categoryIndex in
                    let index = self?.identifyTheCategoryNumber(categoryIndex)
                    self?.homePresenterDelegate.receiveDataForListTableCell(category: index ?? .popular)
                }
                return cell

            case .list:
                
                let cell  = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
                cell.configure(listOfMovies: listTableMovies)
                cell.parentViewController = self
                return cell
            }
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            return cell
        }
    }
}

extension HomeViewController: HomePresenterDelegate {
    func handleDataFromAPI(movies: [HomeModel]) {
        self.recommendedMovies = movies
        isDataLoaded = true
        self.tableView.reloadData()
    }
    
    func handleError(error: Error) {
        print(error)
    }
    
    func didReceivedDataForListTable(movies: [HomeModel]) {
        self.listTableMovies = movies
        let indexPath = IndexPath(item: 2, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

