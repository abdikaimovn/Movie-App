//
//  DetailModel.swift
//  Movies
//
//  Created by Нурдаулет on 15.07.2023.
//

import Foundation

struct DetailModel{
    let title: String
    let posterPath: String?
    let backDropPath: String?
    let overview: String
    let runtime: String
    let genre: String
    let releaseDate: String
}

struct MovieDetail: Decodable{
    let backdropPath: String?
    let posterPath: String?
    let name: String
    let overview: String
    var runtime: Int?
    var releaseDate: String
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case name = "title"
        case overview
        case runtime
        case releaseDate = "release_date"
        case genres
    }
    
    struct Genre: Decodable {
        var name: String
    }
}
