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
    var categoriesTableCell = CategoriesTableCell()
    let home = HomePresenter()
    
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
        selectionStyle = .none
        contentView.addSubview(collectionView)
        home.delegate = self
        categoriesTableCell.categoryDelegate = self
        categoriesTableCell.obtainCategoryNumber()
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(475)
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

extension ListTableCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTableMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath) as! ListCollectionCell
        cell.configure(urlForImage: listTableMovies[indexPath.row].stringImage)
        collectionView.reloadData()
        return cell
    }
}

extension ListTableCell: TransferDataBetweenControllesDelegate{
    func handleDataFromAPI(movies: [MovieResponse]) {
        DispatchQueue.main.async {
            for i in 0..<9 {
                self.listTableMovies.append(HomeModel(id: movies[i].id, stringImage: movies[i].poster_path))
            }
            self.collectionView.reloadData()
        }
    }
    
    func handleError(error: Error) {
        print(error)
    }
}

extension ListTableCell: CategoriesDelegate{
    func didChangeCategory(_ indexOfCategory: Int){
        DispatchQueue.main.async {
            self.home.fetchDataFromAPI(category: self.identifyTheCategoryNumber(indexOfCategory))
        }
    }
}
