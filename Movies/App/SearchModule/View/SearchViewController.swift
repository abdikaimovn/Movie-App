//
//  SearchViewController.swift
//  Movies
//
//  Created by Нурдаулет on 28.06.2023.
//

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    var delegate = SearchPresenter()
    var listOfFoundMovies = [SearchingMovieModel]()
    var valueOfTextField: String?
    var detailPresenter = DetailPresenter()
    var movieModel: DetailModel?
    
    private var textField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.textColor = .black
        textField.placeholder = "Name of the movie..."
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = false
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: "SearchTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var errorMessageView: UIView = {
        var view = UIView()
        return view
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.text = "We Are Sorry, We Can Not Find The Movie :("
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorMessageImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "magnifier")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate.transferDataDelegate = self
        errorMessageView.isHidden = true
        setupViews()
    }
    
    private func setupViews(){
        view.addSubview(textField)
        detailPresenter.delegate = self
        
        view.addSubview(errorMessageView)
        errorMessageView.backgroundColor = .clear
        errorMessageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(190)
        }
        
        errorMessageView.addSubview(errorMessageImage)
        errorMessageImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(76)
        }
        
        errorMessageView.addSubview(errorMessageLabel)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(190)
            make.top.equalTo(errorMessageImage.snp.bottom).offset(20)
        }
        
        //setting the left margin for the texfield
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.delegate = self
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(42)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(15)
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailPresenter.fetchMovieByID(movieId: String(listOfFoundMovies[indexPath.row].id))
    }
}

extension SearchViewController: DetailDelegate {
    func didFetchMovie(movie: DetailModel) {
        let detailVC = DetailViewController()
        detailVC.configure(model: movie)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationController?.pushViewController(detailVC.self, animated: true)
    }
    
    func didFail(error: Error) {
        print(error)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFoundMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell") as! SearchTableCell
        cell.configure(movie: listOfFoundMovies[indexPath.row])
        return cell
    }
}

extension SearchViewController: TransferOfFoundMovies {
    func didRetrievedMovies(movies: [SearchingMovieModel]) {
        listOfFoundMovies = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailure(error: Error) {
        print(error)
    }
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate.fetchInfoAboutMovie(movieTitle: textField.text ?? "")
        if listOfFoundMovies.count > 0 {
            errorMessageView.isHidden = true
            tableView.isHidden = false
        } else {
            errorMessageView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
