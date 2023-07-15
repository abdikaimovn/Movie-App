import Foundation
import Alamofire

protocol HomePresenterDelegate{
    func handleDataFromAPI(movies: [HomeModel])
    func didReceivedDataForListTable(movies: [HomeModel])
    func handleError(error: Error)
}

class HomePresenter{
    var delegate: HomePresenterDelegate?

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
                var listOfMovies = [HomeModel]()
                for movie in movies{
                    listOfMovies.append(HomeModel(id: movie.id, stringImage: movie.poster_path))
                }
                self.delegate?.handleDataFromAPI(movies: listOfMovies)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func receiveDataForListTableCell(category: Categories){
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
                var listOfMoviesForCategories = [HomeModel]()
                for movie in movies{
                    listOfMoviesForCategories.append(HomeModel(id: movie.id, stringImage: movie.poster_path))
                }
                self.delegate?.didReceivedDataForListTable(movies: listOfMoviesForCategories)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
}
