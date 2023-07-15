//
//  WatchListCollectionCell.swift
//  Movies
//
//  Created by Нурдаулет on 01.07.2023.
//

import UIKit
import SnapKit
import Kingfisher

class ListCollectionCell: UICollectionViewCell {
    private let image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "movie")
        img.clipsToBounds = true
        img.layer.cornerRadius = 15
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(urlForImage: String){
        if let url = URL(string: "\(APIManager.shared.linkToFetchImages)\(urlForImage)"){
            image.kf.setImage(with: url)
        }
        
    }
    
    private func setupView(){
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
            make.height.equalTo(144)
            make.width.equalTo(100)
        }
    }
}
