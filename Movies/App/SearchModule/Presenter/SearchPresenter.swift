// SearchPresenter.swift
import Foundation
import Alamofire

// Define the data structures for decoding JSON responses
struct SearchResult: Decodable {
    var results: [MovieID]
}

struct MovieID: Decodable {
    var id: Int
}

struct Movies: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    var id: Int
    var title: String
    var posterPath: String?
    var voteAverage: Float
    var runtime: Int?
    var releaseDate: String
    var genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genres
        case runtime
    }

    struct Genre: Decodable {
        var name: String
    }
}

// Define a protocol for transferring found movies and errors
protocol TransferOfFoundMovies {
    func didRetrievedMovies(movies: [SearchingMovieModel])
    func didFailure(error: Error)
}

final class SearchPresenter {
    var transferDataDelegate: TransferOfFoundMovies?
    var defaultQueue = DispatchQueue.global(qos: .default)
    var movieIDs = [MovieID]()

    // Helper method to replace spaces with underscores in a string
    func removeWhiteSpaces(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "_")
    }

    // Fetch movie information based on the given movie title
    func fetchInfoAboutMovie(movieTitle: String) {
        let apiURL = "https://api.themoviedb.org/3/search/movie?api_key=\(APIManager.shared.apiKey)&query=\(removeWhiteSpaces(string: movieTitle))"
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]

        defaultQueue.async {
            AF.request(apiURL, parameters: parameters).responseDecodable(of: SearchResult.self) { response in
                switch response.result {
                case .success(let searchResult):
                    self.movieIDs = searchResult.results
                    self.fetchMovieDetails()
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.transferDataDelegate?.didFailure(error: error)
                    }
                }
            }
        }
    }

    // Fetch details of each movie in parallel and notify when all are retrieved
    func fetchMovieDetails() {
        var listOfFoundMovies = [SearchingMovieModel]()

        // Create a dispatch group to synchronize multiple API requests
        let group = DispatchGroup()

        for movieID in self.movieIDs {
            group.enter() // Enter the group before starting each request

            AF.request("\(APIManager.shared.linkToGetJSONData)\(movieID.id)?api_key=\(APIManager.shared.apiKey)").responseDecodable(of: Movie.self) { response in
                defer {
                    group.leave() // Leave the group when the request is finished, whether it succeeded or failed
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

        // Notify when all requests in the group have completed
        group.notify(queue: .main) {
            self.transferDataDelegate?.didRetrievedMovies(movies: listOfFoundMovies)
        }
    }
}
