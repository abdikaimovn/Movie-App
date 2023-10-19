//
//  WatchListViewController.swift
//  Movies
//
//  Created by Нурдаулет on 28.06.2023.
//

import UIKit
import SnapKit

//not implemented class

final class WatchListViewController: UIViewController {
    var markedMoviesIDs = BookmarkManager.shared.getBookmarkedMovieIDs()
    var movies = [SearchingMovieModel]()
    var delegate = WatchListPresenter()
    
    lazy private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: "SearchTableCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#242A32")
        
        delegate.movieIDs = markedMoviesIDs
        delegate.transferDataDelegate = self
        delegate.fetchMovieDetails()
        
        setupView()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell") as! SearchTableCell
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
}


extension WatchListViewController: TransferOfFoundMovies {
    func didRetrievedMovies(movies: [SearchingMovieModel]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailure(error: Error) {
        print(error)
    }
}
