import Foundation
import Alamofire

protocol HomePresenterDelegate {
    func handleDataFromAPI(movies: [PosterModel])
    func didReceivedDataForListTable(movies: [PosterModel])
    func handleError(error: Error)
    func didGetCategoryType(_ categoryType: Categories)
}

class HomePresenter {
    var delegate: HomePresenterDelegate?
    var defaultQueue = DispatchQueue.global(qos: .default)
    
    func identifyCategoryType(_ categoryNumber: Int) {
        var category = Categories.nowPlaying
        switch categoryNumber {
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
        switch ct {
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

        // Using GCD to execute a network request
        defaultQueue.async {
            AF.request(apiUrl, parameters: parameters).responseDecodable(of: HomeModel.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    let movies = movieResponse.results
                    var listOfMovies = [PosterModel]()
                    for movie in movies {
                        listOfMovies.append(PosterModel(id: movie.id, stringImage: movie.poster_path))
                    }
                    // Calling a delegate in the main thread to update the interface
                    DispatchQueue.main.async {
                        self.delegate?.handleDataFromAPI(movies: listOfMovies)
                    }
                case .failure(let error):
                    // Calling a delegate in the main thread to handle the error
                    DispatchQueue.main.async {
                        self.delegate?.handleError(error: error)
                    }
                }
            }
        }
    }

    func receiveDataForListTableCell(category: Categories) {
        let apiUrl = identifyCategoryLink(category: category)

        let parameters: Parameters = [
            "api_key": "3052a38221f4fa7f31b8d86590794875"
        ]

        // Using GCD to execute a network request
        defaultQueue.async {
            AF.request(apiUrl, parameters: parameters).responseDecodable(of: HomeModel.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    let movies = movieResponse.results
                    var listOfMoviesForCategories = [PosterModel]()
                    for movie in movies {
                        listOfMoviesForCategories.append(PosterModel(id: movie.id, stringImage: movie.poster_path))
                    }
                    // Calling a delegate in the main thread to update the interface
                    DispatchQueue.main.async {
                        self.delegate?.didReceivedDataForListTable(movies: listOfMoviesForCategories)
                    }
                case .failure(let error):
                    // Calling a delegate in the main thread to handle the error
                    DispatchQueue.main.async {
                        self.delegate?.handleError(error: error)
                    }
                }
            }
        }
    }
}
