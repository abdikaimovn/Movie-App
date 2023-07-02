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

class HomeViewController: UIViewController {
    var rows = RowsInTableView.allCases
    
    private var tableView: UITableView = {
        var tv = UITableView()
        tv.register(RecommendedTVCell.self, forCellReuseIdentifier: "RecommendedTVCell")
        tv.register(CategoriesTVCell.self, forCellReuseIdentifier: "CategoriesTVCell")
        tv.register(ListTVCell.self, forCellReuseIdentifier: "ListTVCell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(hex: "#242A32")
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview().inset(0)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row]{
        case .recommended:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedTVCell", for: indexPath) as! RecommendedTVCell
            cell.backgroundColor = .clear
            return cell
        case .categories:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoriesTVCell", for: indexPath) as! CategoriesTVCell
            cell.backgroundColor = .clear
            return cell
        case .list:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath) as! ListTVCell
            cell.backgroundColor = .clear
            return cell
        }
    }
}

