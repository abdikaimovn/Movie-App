//
//  RecommendedCollectionCell.swift
//  Movies
//
//  Created by Нурдаулет on 30.06.2023.
//

import UIKit
import SnapKit

class RecommendedCollectionCell: UICollectionViewCell {
    private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "movie")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        contentView.clipsToBounds = true
        
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
            make.height.equalTo(210)
        }
    }
    
}
