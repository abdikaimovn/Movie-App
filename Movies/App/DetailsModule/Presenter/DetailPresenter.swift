//
//  DetailPresenter.swift
//  Movies
//
//  Created by Нурдаулет on 15.07.2023.
//

import Foundation
import Alamofire

protocol DetailDelegate{
    func didFetchMovie(movie: DetailModel)
    func didFail(error: Error)
}

protocol DetailVCDelegate: AnyObject {
    func didMarkMovie(movieID: Int)
    func didUnmarkMovie(movieID: Int)
}

class DetailPresenter{
    var delegate: DetailDelegate?
    var defaultQueue = DispatchQueue.global(qos: .default)
    var detailVC: DetailViewController?
    
    func fetchMovieByID(movieId: String){
        let apiUrl = "\(APIManager.shared.linkToGetJSONData)\(movieId)?api_key=\(APIManager.shared.apiKey)"
        
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]
        
        defaultQueue.async {
            AF.request(apiUrl, parameters: parameters).responseDecodable(of: MovieDetail.self) {response in
                switch response.result{
                case .success(let movieResponse):
                    let movie = movieResponse
                    let movieResponse = DetailModel(
                        title: movie.name,
                        posterPath: movie.posterPath ?? nil,
                        backDropPath: movie.backdropPath ?? nil,
                        overview: movie.overview
                    )
                    DispatchQueue.main.async {
                        self.delegate?.didFetchMovie(movie: movieResponse)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.delegate?.didFail(error: error)
                    }
                }
            }
        }
    }
}

extension DetailPresenter: DetailVCDelegate {
    func didMarkMovie(movieID: Int) {
        BookmarkManager.shared.addMovieID(movieID)
    }
    
    func didUnmarkMovie(movieID: Int) {
        BookmarkManager.shared.removeMovieID(movieID)
    }
}
