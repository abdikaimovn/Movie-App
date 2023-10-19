//
//  SearchVCsTableCell.swift
//  Movies
//
//  Created by Нурдаулет on 14.07.2023.
//

import UIKit
import SnapKit
import Kingfisher

class SearchTableCell: UITableViewCell {
    private var image: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.image = UIImage(named: "movie")
        return image
    }()
    
    private var movieNameLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var movieRatingLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private var movieGenreLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private var movieReleaseYearLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private var movieDurationLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private func addSfSymbolToLabel(labelText: String, symbolName: String, symbolColor: UIColor?) -> NSMutableAttributedString {
        let symbolImage = UIImage(systemName: symbolName)
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = symbolImage?.withTintColor(symbolColor ?? .white)
        let symbolString = NSAttributedString(attachment: symbolAttachment)
        let text = NSMutableAttributedString()
        text.append(symbolString)
        text.append(NSAttributedString(string: " \(labelText)"))
        return text
    }
    
    private func determineRateSymbolColor(rate: Float) -> UIColor{
        if rate > 7 {
            return .orange
        } else {
            return .white
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(movie: SearchingMovieModel){
        if let url = URL(string: "\(APIManager.shared.linkToFetchImages)\(movie.posterPath)"){
            image.kf.setImage(with: url)
        }
        
        movieNameLabel.text = movie.title
        movieRatingLabel.attributedText = addSfSymbolToLabel(labelText:     String(format: "%.1f", movie.voteAverage),
                                                             symbolName: "star",
                                                             symbolColor: determineRateSymbolColor(rate: movie.voteAverage))
        
        movieReleaseYearLabel.attributedText = addSfSymbolToLabel(labelText: movie.releaseDate,
                                                                  symbolName: "calendar",
                                                                  symbolColor: nil)
        movieGenreLabel.attributedText = addSfSymbolToLabel(labelText: movie.genre, symbolName: "ticket", symbolColor: nil)
        movieDurationLabel.attributedText = addSfSymbolToLabel(labelText: String(movie.runtime) + " minutes", symbolName: "clock", symbolColor: nil)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
    }
    
    private func setupViews(){
        self.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(hex: "#181c21")
        image.layer.masksToBounds = true
        
        self.selectionStyle = .none
        contentView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(150)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(movieNameLabel)
        movieNameLabel.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(image.snp.top)
        }
        
        contentView.addSubview(movieRatingLabel)
        movieRatingLabel.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(12)
            make.top.equalTo(movieNameLabel.snp.bottom).offset(8)
        }
        
        contentView.addSubview(movieGenreLabel)
        movieGenreLabel.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(12)
            make.top.equalTo(movieRatingLabel.snp.bottom).offset(8)
        }
        
        contentView.addSubview(movieReleaseYearLabel)
        movieReleaseYearLabel.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(12)
            make.top.equalTo(movieGenreLabel.snp.bottom).offset(8)
        }
        
        contentView.addSubview(movieDurationLabel)
        movieDurationLabel.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(12)
            make.top.equalTo(movieReleaseYearLabel.snp.bottom).offset(8)
        }
    }
}
