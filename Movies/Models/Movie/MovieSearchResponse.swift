//
//  MovieSearchResponse.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import Foundation

struct MovieSearchResponse: Decodable {
    let search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
