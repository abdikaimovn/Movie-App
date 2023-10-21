//
//  WatchListViewController.swift
//  Movies
//
//  Created by Нурдаулет on 28.06.2023.
//

import UIKit
import SnapKit

//not implemented class

final class BookmarkViewController: BaseViewController {
    var markedMoviesIDs = BookmarkManager.shared.getBookmarkedMovieIDs()
    var movies = [SearchingMovieModel]()
    var delegate = BookmarkPresenter()
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
        delegate.movieIDs = BookmarkManager.shared.getBookmarkedMovieIDs()
        delegate.fetchMovieDetails()
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieID = movies[indexPath.row].id

        // Create an instance of DetailPresenter
        let detailPresenter = DetailPresenter()
        detailPresenter.delegate = self

        // Assign detailPresenter as the delegate to detailVC
        let detailVC = DetailViewController(movieID: movieID)
        detailVC.delegate = detailPresenter
        detailVC.delegate?.fetchMovieByID(movieId: String(movieID))

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationController?.pushViewController(detailVC, animated: true)
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


extension BookmarkViewController: TransferOfFoundMovies {
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

extension BookmarkViewController: DetailDelegate {
    func didFetchMovie(movie: DetailModel) {
        DispatchQueue.main.async {
            self.detailMovie = movie
            // Update the detail view controller if it's currently visible
            if let detailViewController = self.navigationController?.topViewController as? DetailViewController {
                detailViewController.configure(model: movie)
            }
        }
    }

    func didFail(error: Error) {
        print(error)
    }
}
