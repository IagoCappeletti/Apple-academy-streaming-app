//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by ios-noite-07 on 30/04/24.
//

import Foundation

struct SerieSearchResponse: Decodable {
    let search: [Serie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
