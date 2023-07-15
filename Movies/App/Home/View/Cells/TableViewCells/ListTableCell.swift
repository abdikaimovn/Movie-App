//
//  WatchListTVCell.swift
//  Movies
//
//  Created by Нурдаулет on 01.07.2023.
//

import UIKit
import SnapKit

class ListTableCell: UITableViewCell {
    var listTableMovies = [HomeModel]()
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
        cView.register(ListCollectionCell.self, forCellWithReuseIdentifier: "ListCollectionCell")
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
    
    func configure(listOfMovies: [HomeModel]){
        listTableMovies = listOfMovies
        collectionView.reloadData()
    }
}

extension ListTableCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = String(listTableMovies[indexPath.row].id)
        detailPresenter.fetchMovieByID(movieId: movieId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTableMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath) as! ListCollectionCell
        cell.configure(urlForImage: listTableMovies[indexPath.row].stringImage)
        return cell
    }
}

extension ListTableCell: DetailDelegate {
    func didFetchMovie(movie: DetailModel) {
        let detailVC = DetailViewController()
        detailVC.configure(model: movie)
        if let parentVC = self.parentViewController {
            parentVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func didFail(error: Error) {
        print(error)
    }
}
