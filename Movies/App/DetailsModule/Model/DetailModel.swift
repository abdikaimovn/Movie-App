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
}

struct MovieDetail: Decodable{
    let backdropPath: String?
    let posterPath: String?
    let name: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case name = "title"
        case overview
    }
}
