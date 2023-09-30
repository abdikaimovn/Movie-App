//
//  ViewController.swift
//  Movies
//
//  Created by Нурдаулет on 27.06.2023.
//

import UIKit
import SnapKit

enum RowsInTableView: CaseIterable{
    case recommended, categories, table
}

final class HomeViewController: BaseViewController {
    // *rows* is just array of all possible cases from RowsInTableView to divide the main tableView to several sections
    let rows = RowsInTableView.allCases
    let homePresenterDelegate = HomePresenter()
    var categoryType = Categories.nowPlaying
    
    var recommendedMovies: [PosterModel]?
    var tableMovies = [PosterModel]()
    
    //Main tableView that contains three sections: Recommended, Categories, Table
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // Registering all sections
        tableView.register(RecommendedTableCell.self, forCellReuseIdentifier: "RecommendedTableCell")
        tableView.register(CategoriesTableCell.self, forCellReuseIdentifier: "CategoriesTableCell")
        tableView.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        return tableView
    }()
    
    // MARK: - ViewController's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        homePresenterDelegate.delegate = self
        
        // Setting primary values to sections
        homePresenterDelegate.fetchDataFromAPI(category: .topRated)
        homePresenterDelegate.receiveDataForListTableCell(category: .nowPlaying)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .recommended:
            if let movies = recommendedMovies {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedTableCell", for: indexPath) as! RecommendedTableCell
                cell.configure(recommendedMovies: movies)
                // Assign parentVC to have an opportunity to push a new VC
                cell.parentViewController = self
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.backgroundColor = .clear
                return cell
            }
            
        case .categories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
            cell.categoryDidSelect = { [weak self] categoryIndex in
                // Identify category type by selected category index
                self?.homePresenterDelegate.identifyCategoryType(categoryIndex)
                let index = self?.categoryType
                self?.homePresenterDelegate.receiveDataForListTableCell(category: index ?? .popular)
            }
            return cell

        case .table:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
            cell.configure(listOfMovies: tableMovies)
            cell.parentViewController = self
            return cell
        }
    }

}

extension HomeViewController: HomePresenterDelegate {
    func didGetCategoryType(_ categoryType: Categories) {
        self.categoryType = categoryType
    }
    
    func handleDataFromAPI(movies: [PosterModel]) {
        self.recommendedMovies = movies
        self.tableView.reloadData()
    }
    
    func handleError(error: Error) {
        print(error)
    }
    
    func didReceivedDataForListTable(movies: [PosterModel]) {
        self.tableMovies = movies
        let indexPath = IndexPath(item: 2, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

