import Foundation
import Alamofire

protocol TransferDataBetweenControllesDelegate{
    func handleDataFromAPI(movies: [MovieResponse])
    func handleError(error: Error)
}

struct PopularMovieForRecommendedSection: Codable {
    let results: [MovieResponse]
}

enum Categories: String{
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
    case topRated = "top_rated"
    case popular = "popular"
}

struct MovieResponse: Codable {
    let id: Int
    let title: String
    let poster_path: String
}

class HomePresenter{
    var delegate: TransferDataBetweenControllesDelegate?
    
    func fetchDataFromAPI(category: Categories) {
        var apiUrl: String?
        switch category{
        case .popular:
            apiUrl = "\(APIManager.shared.linkToGetJSONData)popular"
        case .nowPlaying:
            apiUrl = "\(APIManager.shared.linkToGetJSONData)now_playing"
        case .upcoming:
            apiUrl = "\(APIManager.shared.linkToGetJSONData)upcoming"
        case .topRated:
            apiUrl = "\(APIManager.shared.linkToGetJSONData)top_rated"
        }
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]
        
        AF.request(apiUrl!, parameters: parameters).responseDecodable(of: PopularMovieForRecommendedSection.self) { response in
            switch response.result {
            case .success(let movieResponse):
                let movies = movieResponse.results
                self.delegate?.handleDataFromAPI(movies: movies)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
}
