//
//  DetailPresenter.swift
//  Movies
//
//  Created by Нурдаулет on 15.07.2023.
//

import Foundation
import Alamofire

struct MovieDetail: Decodable{
    let backdropPath: String?
    let posterPath: String?
    let name: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case name = "title"
        case overview
    }
}

protocol DetailDelegate{
    func didFetchMovie(movie: DetailModel)
    func didFail(error: Error)
}

class DetailPresenter{
    var delegate: DetailDelegate?
    
    func fetchMovieByID(movieId: String){
        let apiUrl = "\(APIManager.shared.linkToGetJSONData)\(movieId)?api_key=\(APIManager.shared.apiKey)"
        
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]
        
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
                self.delegate?.didFetchMovie(movie: movieResponse)
            case .failure(let error):
                self.delegate?.didFail(error: error)
            }
        }
    }
}
