import Foundation
import Alamofire

protocol HomePresenterDelegate{
    func handleDataFromAPI(movies: [PosterModel])
    func didReceivedDataForListTable(movies: [PosterModel])
    func handleError(error: Error)
    func didGetCategoryType(_ categoryType: Categories)
}

class HomePresenter{
    var delegate: HomePresenterDelegate?

//    init(with view: HomePresenterDelegate) {
//        <#statements#>
//    }
    
    func identifyCategoryType(_ categoryNumber: Int) {
        var category = Categories.nowPlaying
        switch categoryNumber{
        case 0:
            category = .nowPlaying
        case 1:
            category = .upcoming
        case 2:
            category = .topRated
        case 3:
            category = .popular
        default:
            break
        }
        delegate?.didGetCategoryType(category)
    }
    
    private func identifyCategoryLink(category ct: Categories) -> String {
        switch ct{
        case .popular:
            return "\(APIManager.shared.linkToGetJSONData)popular"
        case .nowPlaying:
            return "\(APIManager.shared.linkToGetJSONData)now_playing"
        case .upcoming:
            return "\(APIManager.shared.linkToGetJSONData)upcoming"
        case .topRated:
            return "\(APIManager.shared.linkToGetJSONData)top_rated"
        }
    }
    
    func fetchDataFromAPI(category: Categories) {
        let apiUrl = identifyCategoryLink(category: category)
        
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]
        
        AF.request(apiUrl, parameters: parameters).responseDecodable(of: HomeModel.self) { response in
            switch response.result {
            case .success(let movieResponse):
                let movies = movieResponse.results
                var listOfMovies = [PosterModel]()
                for movie in movies{
                    listOfMovies.append(PosterModel(id: movie.id, stringImage: movie.poster_path))
                }
                self.delegate?.handleDataFromAPI(movies: listOfMovies)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func receiveDataForListTableCell(category: Categories){
        let apiUrl = identifyCategoryLink(category: category)
        
        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]
        
        AF.request(apiUrl, parameters: parameters).responseDecodable(of: HomeModel.self) { response in
            switch response.result {
            case .success(let movieResponse):
                let movies = movieResponse.results
                var listOfMoviesForCategories = [PosterModel]()
                for movie in movies{
                    listOfMoviesForCategories.append(PosterModel(id: movie.id, stringImage: movie.poster_path))
                }
                self.delegate?.didReceivedDataForListTable(movies: listOfMoviesForCategories)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
}
