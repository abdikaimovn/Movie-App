//
//  APIManager.swift
//  Movies
//
//  Created by Нурдаулет on 07.07.2023.
//

import Foundation

struct APIManager{
    static let shared = APIManager()
    let apiKey = "3052a38221f4fa7f31b8d86590794875"
    let apiAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzMDUyYTM4MjIxZjRmYTdmMzFiOGQ4NjU5MDc5NDg3NSIsInN1YiI6IjY0YTU4YzJiNWE5OTE1MDBhZGY4Nzk1ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vLKoLkDgecav3TcU9SUom-MPCWD_R2WPlrbVVOgUMUw"
    let linkToFetchImages = "https://image.tmdb.org/t/p/w500"
    //After movie/ you have to choose category like 'now_playing', 'popular', and then add your api key
    let linkToGetJSONData = "https://api.themoviedb.org/3/movie/"
}
