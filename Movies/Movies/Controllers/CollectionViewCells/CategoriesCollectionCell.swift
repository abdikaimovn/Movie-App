//
//  CategoriesCollectionCell.swift
//  Movies
//
//  Created by Нурдаулет on 01.07.2023.
//

import UIKit
import SnapKit

class CategoriesCollectionCell: UICollectionViewCell {
    var label: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.height.equalTo(33)
        }
    }
}

