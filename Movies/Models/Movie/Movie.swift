//
//  Movie.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import Foundation

struct Movie: Decodable, Equatable {
    let id: String
    let title: String
    let released: String?
    let language: String?
    let country: String?
    let genre: String?
    let plot: String?
    let posterURL: String?
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case released = "Released"
        case language = "Language"
        case country = "Country"
        case genre = "Genre"
        case plot = "Plot"
        case posterURL = "Poster"
    }
}
