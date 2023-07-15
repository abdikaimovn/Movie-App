//
//  RecommendedTVCell.swift
//  Movies
//
//  Created by Нурдаулет on 30.06.2023.
//

import UIKit
import Alamofire

class RecommendedTableCell: UITableViewCell {
    var recommendedMovies = [HomeModel]()
    let detailPresenter = DetailPresenter()
    weak var parentViewController: HomeViewController?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: 144, height: 210)
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.delegate = self
        cView.backgroundColor = .clear
        cView.dataSource = self
        cView.showsHorizontalScrollIndicator = false
        cView.register(ListCollectionCell.self, forCellWithReuseIdentifier: "ListCollectionCell")
        return cView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(recommendedMovies: [HomeModel]){
        self.recommendedMovies = recommendedMovies
    }
    
    private func setupView(){
        selectionStyle = .none
        detailPresenter.delegate = self
        self.backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(25)
            make.left.right.equalToSuperview()
            make.height.equalTo(210)
        }
    }
}

extension RecommendedTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = String(recommendedMovies[indexPath.row].id)
        detailPresenter.fetchMovieByID(movieId: movieId)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath) as! ListCollectionCell
        cell.configure(urlForImage: self.recommendedMovies[indexPath.row].stringImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 35.0, bottom: 0.0, right: 35.0)
    }
}

extension RecommendedTableCell: DetailDelegate {
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
