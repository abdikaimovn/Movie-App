//
//  SearchPresenter.swift
//  Movies
//
//  Created by Нурдаулет on 15.07.2023.
//

import Foundation
import Alamofire

struct Movies: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}

protocol TransferOfFoundMovies {
    func didRetrievedMovies(movies: [SearchingMovieModel])
    func didFailure(error: Error)
}

final class SearchPresenter {
    var transferDataDelegate: TransferOfFoundMovies?
    
    func removeWhiteSpaces(string: String) -> String{
        var newString = ""
        for i in string{
            if i != " " {
                newString += String(i)
            }else{
                newString += "_"
            }
        }
        return newString
    }
    
    func fetchInfoAboutMovie(movieTitle: String){
        let apiURL = "https://api.themoviedb.org/3/search/movie?api_key=\(APIManager.shared.apiKey)&query=\(removeWhiteSpaces(string: movieTitle))"
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]
        
        AF.request(apiURL, parameters: parameters).responseDecodable(of: Movies.self) { response in
            switch response.result{
            case .success(let movieResponse):
                let movies = movieResponse.results
                var listOfFoundMovies = [SearchingMovieModel]()
                for movie in movies{
                    listOfFoundMovies.append(SearchingMovieModel(id: movie.id,
                                                                 title: movie.title,
                                                                 posterPath: movie.posterPath ?? "zQ8AxTPiCiS5nnwXpwTBPBHSaa5.jpg",
                                                                 voteAverage: Float(movie.voteAverage),
                                                                 releaseDate: movie.releaseDate))
                }
                self.transferDataDelegate?.didRetrievedMovies(movies: listOfFoundMovies)
            case .failure(let error):
                self.transferDataDelegate?.didFailure(error: error)
            }
        }
    }
}
