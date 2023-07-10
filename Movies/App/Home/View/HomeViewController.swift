//
//  ViewController.swift
//  Movies
//
//  Created by Нурдаулет on 27.06.2023.
//

import UIKit
import SnapKit

enum RowsInTableView: CaseIterable{
    case recommended, categories, list
}

final class HomeViewController: BaseViewController {
    let rows = RowsInTableView.allCases
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(RecommendedTableCell.self, forCellReuseIdentifier: "RecommendedTableCell")
        tableView.register(CategoriesTableCell.self, forCellReuseIdentifier: "CategoriesTableCell")
        tableView.register(ListTableCell.self, forCellReuseIdentifier: "ListTableCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row]{
        case .recommended:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedTableCell", for: indexPath) as! RecommendedTableCell
            cell.backgroundColor = .clear
            return cell
        case .categories:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
            cell.backgroundColor = .clear
            return cell
        case .list:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
            cell.backgroundColor = .clear
            return cell
        }
    }
}
