//
//  WatchListViewController.swift
//  Movies
//
//  Created by Нурдаулет on 28.06.2023.
//

import UIKit
import SnapKit

//not implemented class

final class WatchListViewController: BaseViewController {
    var markedMoviesIDs = BookmarkManager.shared.getBookmarkedMovieIDs()
    var movies = [SearchingMovieModel]()
    var delegate = WatchListPresenter()
    var detailMovie: DetailModel?
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

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Set the refreshControl for the tableView
        tableView.refreshControl = refreshControl

        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
    }
    
    @objc func refreshData() {
        // You can put your data fetching logic here
        delegate.fetchMovieDetails()
    }


}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    //MARK: - NEED TO FIX
//        let movieID = movies[indexPath.row].id
//
//        let detailVC = DetailViewController(movieID: movieID)
//        detailVC.delegate?.fetchMovieByID(movieId: String(movieID))
//
//        DispatchQueue.main.async {
//            detailVC.configure(model: self.detailMovie!)
//        }
//
//        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        backBarButtonItem.tintColor = .white
//        self.navigationItem.backBarButtonItem = backBarButtonItem
//        self.navigationController?.pushViewController(detailVC, animated: true)
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
        tableView.reloadData()
        
        // End the refreshing
        tableView.refreshControl?.endRefreshing()
    }


    func didFailure(error: Error) {
        print(error)
    }
}
//
//extension WatchListViewController: DetailDelegate {
//    func didFetchMovie(movie: DetailModel) {
//        DispatchQueue.main.async {
//            self.detailMovie = movie
//        }
//    }
//
//    func didFail(error: Error) {
//        print(error)
//    }
//}
