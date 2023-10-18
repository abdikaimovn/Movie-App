//
//  WatchListTVCell.swift
//  Movies
//
//  Created by Нурдаулет on 01.07.2023.
//

import UIKit
import SnapKit

class TableCell: UITableViewCell {
    var tableMovies = [PosterModel]()
    var detailPresenter = DetailPresenter()
    weak var parentViewController: HomeViewController?
    
    private lazy var collectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 144)
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.backgroundColor = .clear
        cView.delegate = self
        cView.dataSource = self
        cView.isScrollEnabled = false
        cView.register(TableCollectionCell.self, forCellWithReuseIdentifier: "ListCollectionCell")
        return cView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        self.backgroundColor = .clear
        selectionStyle = .none
        detailPresenter.delegate = self
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(475)
        }
    }
    
    func configure(listOfMovies: [PosterModel]){
        tableMovies = listOfMovies
        collectionView.reloadData()
    }
}

extension TableCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = String(tableMovies[indexPath.row].id)
        detailPresenter.fetchMovieByID(movieId: movieId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath) as! TableCollectionCell
        cell.configure(urlForImage: tableMovies[indexPath.row].stringImage)
        return cell
    }
}

extension TableCell: DetailDelegate {
    func didFetchMovie(movie: DetailModel) {
        let detailVC = DetailViewController()
        detailVC.configure(model: movie)
        if let parentVC = self.parentViewController {
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            backBarButtonItem.tintColor = .white
            parentVC.navigationItem.backBarButtonItem = backBarButtonItem
            parentVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func didFail(error: Error) {
        print(error)
    }
}
