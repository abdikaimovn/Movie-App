//
//  RecommendedTVCell.swift
//  Movies
//
//  Created by Нурдаулет on 30.06.2023.
//

import UIKit

class RecommendedTVCell: UITableViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: 144, height: 210)
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.delegate = self
        cView.backgroundColor = .clear
        cView.dataSource = self
        cView.showsVerticalScrollIndicator = false
        cView.register(RecommendedCollectionCell.self, forCellWithReuseIdentifier: "RecommendedCollectionCell")
        return cView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupView(){
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(25)
            make.left.right.equalTo(34)
            make.height.equalTo(210)
        }
    }
}

extension RecommendedTVCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionCell", for: indexPath) as! RecommendedCollectionCell
        return cell
    }
}
