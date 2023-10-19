//
//  DetailViewController.swift
//  Movies
//
//  Created by Нурдаулет on 15.07.2023.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    var delegate: DetailPresenter?
    private var movieID: Int?
    private var markButton: UIBarButtonItem!
    private var isMarked = false
    
    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var backdropImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.layer.cornerCurve = .continuous
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private var posterImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.layer.cornerCurve = .continuous
        return image
    }()
    
    private var bottomLine: UIView = {
        var line = UIView()
        line.backgroundColor = .darkGray
        return line
    }()
    
    private var movieTitle: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private var aboutMovie: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.text = "About Movie"
        return label
    }()
    
    private var movieDescription: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .justified
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        let presenter = DetailPresenter()
        delegate = presenter
        delegate?.detailVC = self
        setupViews()
    }
    
    func configure(model: DetailModel){
        if let safeBackImage = model.backDropPath {
            if let url = URL(string: "\(APIManager.shared.linkToFetchImages)\(safeBackImage)"){
                backdropImage.kf.setImage(with: url)
            }
        } else {
            backdropImage.image = UIImage(named: "backdrop")
        }
        
        if let safePoster = model.posterPath {
            if let url = URL(string: "\(APIManager.shared.linkToFetchImages)\(safePoster)"){
                posterImage.kf.setImage(with: url)
            }
        } else {
            posterImage.image = UIImage(named: "poster")
        }
        
        movieTitle.text = model.title
        movieDescription.text = model.overview
        
    }
    
    @objc func markPressed() {
        isMarked.toggle()
        
        if isMarked {
            markButton.image = UIImage(systemName: "bookmark.fill")
            self.delegate?.didMarkMovie(movieID: movieID!)
        }else {
            markButton.image = UIImage(systemName: "bookmark")
            self.delegate?.didUnmarkMovie(movieID: movieID!)
        }
    }
    
    func isBookMarked(movieID: Int) -> String{
        if BookmarkManager.shared.isMovieBookmarked(movieID) {
            isMarked = true
            return "bookmark.fill"
        }else{
            isMarked = false
            return "bookmark"
        }
    }
    
    private func setupViews(){
        view.backgroundColor = UIColor(hex: "#242A32")
        
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.red
        buttonView.layer.cornerRadius = 8
        
        markButton = UIBarButtonItem(image: UIImage(systemName: isBookMarked(movieID: movieID!)), style: .plain, target: self, action: #selector(markPressed))
        markButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = markButton
        
        view.addSubview(backdropImage)
        backdropImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(210)
        }
        
        view.addSubview(posterImage)
        posterImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.top.equalTo(backdropImage.snp.bottom).offset(-60)
            make.height.equalTo(120)
            make.width.equalTo(95)
        }
        
        view.addSubview(movieTitle)
        movieTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(136)
            make.right.equalToSuperview().inset(30)
            make.top.equalTo(backdropImage.snp.bottom).offset(10)
        }
        
        view.addSubview(aboutMovie)
        aboutMovie.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.top.equalTo(posterImage.snp.bottom).offset(30)
        }
        
        aboutMovie.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(aboutMovie.snp.bottom).offset(7)
            make.width.equalTo(aboutMovie.snp.width)
            make.height.equalTo(3)
        }
        
        view.addSubview(movieDescription)
        movieDescription.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(aboutMovie.snp.bottom).offset(30)
        }
        
    }
    
}
