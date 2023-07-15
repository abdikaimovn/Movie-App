//
//  HomePresenterModels.swift
//  Movies
//
//  Created by Нурдаулет on 14.07.2023.
//

import Foundation

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
