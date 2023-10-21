//
//  WatchListPresenter.swift
//  Movies
//
//  Created by Нурдаулет on 19.10.2023.
//

import Foundation
import Alamofire

class BookmarkPresenter {
    var transferDataDelegate: TransferOfFoundMovies?
    var defaultQueue = DispatchQueue.global(qos: .default)
    var movieIDs: [Int]!
    
    func fetchMovieDetails() {
        var listOfFoundMovies = [SearchingMovieModel]()
        
        let group = DispatchGroup() // Create a dispatch group
        
        for movieID in self.movieIDs {
            group.enter() // Enter the group for each request
            
            AF.request("\(APIManager.shared.linkToGetJSONData)\(movieID)?api_key=\(APIManager.shared.apiKey)").responseDecodable(of: Movie.self) { response in
                defer {
                    group.leave() // Leave the group when the request is completed (success or failure)
                }
                
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
        
        group.notify(queue: DispatchQueue.main) {
            // This block is executed when all requests have completed
            self.transferDataDelegate?.didRetrievedMovies(movies: listOfFoundMovies)
        }
    }

}

