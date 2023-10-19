//
//  WatchListPresenter.swift
//  Movies
//
//  Created by Нурдаулет on 19.10.2023.
//

import Foundation
import Alamofire

class WatchListPresenter {
    var transferDataDelegate: TransferOfFoundMovies?
    var defaultQueue = DispatchQueue.global(qos: .default)
    var movieIDs: [Int]!
    
    // Helper method to replace spaces with underscores in a string
    func removeWhiteSpaces(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "_")
    }
    
    func fetchMovieDetails() {
        var listOfFoundMovies = [SearchingMovieModel]()
        
        for movieID in self.movieIDs {
            AF.request("\(APIManager.shared.linkToGetJSONData)\(movieID)?api_key=\(APIManager.shared.apiKey)").responseDecodable(of: Movie.self) { response in
                switch response.result {
                case .success(let movie):
                    listOfFoundMovies.append(SearchingMovieModel(id: movie.id,
                                                                 title: movie.title,
                                                                 genre: movie.genres?.first?.name ?? "Not given",
                                                                 posterPath: movie.posterPath ?? "zQ8AxTPiCiS5nnwXpwTBPBHSaa5.jpg",
                                                                 voteAverage: Float(movie.voteAverage),
                                                                 runtime: movie.runtime ?? 120,
                                                                 releaseDate: movie.releaseDate))
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.transferDataDelegate?.didFailure(error: error)
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.transferDataDelegate?.didRetrievedMovies(movies: listOfFoundMovies)
        }
    }
}

