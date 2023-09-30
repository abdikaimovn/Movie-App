//
//  CategoriesCollectionCell.swift
//  Movies
//
//  Created by Нурдаулет on 01.07.2023.
//

import UIKit
import SnapKit

class CategoriesCollectionCell: UICollectionViewCell {
    private var lineUnderTheCategory: UIView = {
        var line = UIView()
        line.backgroundColor = .darkGray
        return line
    }()
    
    private var label: UILabel = {
        var label = UILabel()
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
    
    func configure(category: Category) {
        label.text = category.text
        lineUnderTheCategory.isHidden = !category.isSelected
    }
    
    private func setupView(){
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        label.addSubview(lineUnderTheCategory)
        lineUnderTheCategory.snp.makeConstraints { make in
            make.width.equalTo(label.snp.width).offset(-10)
            make.top.equalTo(label.snp.bottom).offset(10)
            make.height.equalTo(3)
        }
    }
}

